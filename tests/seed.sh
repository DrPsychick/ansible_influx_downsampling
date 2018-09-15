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
# datetime (UTC): 2018-09-04 10:00:00 or "now"
# value: ("seq+step10start10"|"random"|...)

tr=${1:-1m}
ivl=${2:-10s}
dt=${3:-"2018-09-01 10:00:00"}
val=${4:-"random"}

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

curl -s "$influxdb/query" --data-urlencode 'q=CREATE DATABASE test' > /dev/null || {
  echo "InfluxDB not reachable!"; exit 1;
}

# time
# start date = now-$tr_sec
if [[ "$dt" = "now" ]]; then
  start_sec=$(($(date -u +%s)-tr_sec))
else
  start_sec=$(date -u -d "$dt" +%s)
fi

echo "Ready to go..."
echo "Timerange: from $start_sec ($(date -u -d @$start_sec +"%Y-%m-%d %H:%M:%S")), ${tr_sec}s in ${ivl_sec}s intervals (UTC)"
echo "Generating value with '$value'"

ts=$start_sec
for i in $(seq 1 $((tr_sec/ivl_sec))); do
  v=$(eval "$value")

  echo "time = $ts interval = $i, value = $v ($(date -u -d @$ts +"%Y-%m-%d %H:%M:%S") UTC)"
  curl -s -X POST "$influxdb/write?db=$database" --data-binary "test value=$v ${ts}000000000"

  ts=$((ts+ivl_sec))
  i=$((i++))
done

query="q=SELECT MEAN(value) FROM test.autogen.test WHERE time >= ${start_sec}000000000 AND time < ${start_sec}000000000 + 1m GROUP BY time($tr)"
echo "$query"
curl -s "$influxdb/query?db=$database" --data-urlencode "$query" |json_pp
