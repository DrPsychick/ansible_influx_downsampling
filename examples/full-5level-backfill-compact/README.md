Full five level downsampling including backfill and compaction
==============================================================

My setup
--------

Disk space before migrate + compact
```
9.5G  /var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf

```

Disk space after migrate + compact
```
 56M  /var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_3y
116M  /var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_90d
 84M  /var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_1y
100M  /var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_14d
 71M  /var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_30d

```

before:
162M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/_internal
680K	/var/lib/docker/volumes/monitoring_influxdb/_data/data/annotation
57M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_3y
116M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_90d
85M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_1y
105M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_14d
73M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_30d
9.6G	/var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf
11G	/var/lib/docker/volumes/monitoring_influxdb/_data/data/

after:
188M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/_internal
680K	/var/lib/docker/volumes/monitoring_influxdb/_data/data/annotation
57M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_3y
116M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_90d
85M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_1y
107M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_14d
74M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf_30d
363M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/telegraf
989M	/var/lib/docker/volumes/monitoring_influxdb/_data/data/
