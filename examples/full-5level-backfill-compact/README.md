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

