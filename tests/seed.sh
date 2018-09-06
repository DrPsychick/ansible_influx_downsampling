#!/bin/bash

# docker container
influxdb=http://localhost:8086
database=test
retention_policy=autogen
measurement=test
db_name=$database.$retention_policy.$measurement

# generate data:
# timerange: 1m -> 60m
# interval: 1s -> 1m
# value: ("seq+step10start10"|"random"|...)

tr=${1:-1m}
ivl=${2:-10s}
val=${3:-"random"}

# timerange / interval
if [[ "$tr" == *m ]]; then
  tr_sec=$((60*$(echo $tr|tr -d 'm')))
else
  tr_sec=$(echo $tr|tr -d 's')
fi
if [[ "$ivl" == *m ]]; then
  ivl_sec=$((60*$(echo $ivl|tr -d 'm')))
else
  ivl_sec=$(echo $ivl|tr -d 's')
fi

if [ $ivl_sec -gt $tr_sec ]; then
  echo "Idiot! Interval cannot be bigger than the time range."
  exit 1
fi

# value
if [[ "$val" == "random" ]]; then
  value='echo $RANDOM'
elif [[ "$val" == seq* ]]; then
  dir=$(echo "$val" | sed -e 's/^seq\([\+-]\).*/\1/')
  step=$(echo "$val" | grep 'step' | sed -e 's/^seq[\+-]step\([0-9]\+\).*/\1/')
  [ "$step" == "" ] && step=1
  start=$(echo "$val" | grep 'start' | sed -e 's/^seq[\+-].*start\([0-9]\+\)$/\1/')
  [ "$start" == "" ] && start=0
  value='echo $((start+i*step))'
  #echo "$value ($start $dir $step)"
else
  echo "Values '$val' Not yet implemented!"
  exit 1
fi

curl -s "$influxdb/query" --data-urlencode 'q=CREATE DATABASE test' || { 
  echo "InfluxDB not reachable!"; exit 1; 
}

echo "Ready to go..."
echo "Timerange: ${tr_sec}s in ${ivl_sec}s intervals"
echo "Generating value with '$value'"

# time
# start date = now-$tr_sec
start_sec=$(($(date +%s)-tr_sec))
ts=$start_sec
for i in $(seq 1 $((tr_sec/ivl_sec))); do
  v=$(eval "$value")
  ts=$((ts+ivl_sec))

  echo "interval = $i, value = $v"

  curl -s -X POST "$influxdb/write?db=$database" --data-binary "test value=$v ${ts}000000000"
  i=$((i++))
done

curl -s "$influxdb/query?db=$database" --data-urlencode "q=SELECT MEAN(value) FROM test.autogen.test" |json_pp
