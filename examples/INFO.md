Dump (portion) of a live database to test the playbook locally
==============================================================

* Dump data from a database and restore to a new one
```
from=$(date -u -d -14day +"%Y-%m-%dT%H:%M:00Z")
to=$(date -u -d -0day +"%Y-%m-%dT%H:%M:00Z")

# dump certain time frame of the whole database
docker exec -it  monitoring_influxdb_1 influxd backup -portable -database telegraf -retention autogen -start $from -end $to /var/lib/influxdb/telegraf.backup

# start a second influx for testing import
docker run -d --rm --name influx_test -p 8087:8086 -v influx_test:/var/lib/influxdb influxdb:alpine

# move the dump into the new influxdb container
mv /var/lib/docker/volumes/monitoring_influxdb/_data/telegraf.backup /var/lib/docker/volumes/influx_test/_data/

# restore dump on the new influx
docker exec -it influx_test influxd restore -portable /var/lib/influxdb/telegraf.backup

# delete backup
rm -rf /var/lib/docker/volumes/influx_test/_data/telegraf.backup

# verify
curl -s http://localhost:8087/query?db=telegraf --data-urlencode "q=SELECT MEAN(usage_user) AS usage_user FROM cpu WHERE time >= '$from' AND time < '$to' GROUP BY host"

# cleanup
# docker stop influx_test
# docker volume rm influx_test
```
