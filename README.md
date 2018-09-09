[![Build Status](https://travis-ci.org/DrPsychick/ansible-influx-downsampling.svg?branch=master)](https://travis-ci.org/DrPsychick/ansible-influx-downsampling)

Configure influxDB for downsampling
===================================

Motivation:
-----------
InfluxDB uses a default retention policy that keeps data **forever** in 7 day shards - in RAW format (data points every 10 or 30 seconds, depending on your input configuration).
Of course this is a good default, but once you have old data and want to introduce downsampling without loosing data, its a **lot** of manual work to setup all the queries etc.

So ... I have done this for you!

Two usage scenarios:
* You already have an influxdb running and it's getting BIG, so you want to introduce downsampling on-the-fly to make things faster and cheaper
* You intend to use influxdb and want to set it up with downsampling in mind (so it does not grow big over time in the first place)

Honestly the two use cases are not much different. The biggest difference is the time it takes to run through the playbook when you enable backfilling. Of course, if you work on existing data, don't forget to have a proper backup!

Preparation
-----------
As preparation you don't need much, expect knowing how exactly you want to downsample your data as you need to setup your configuration first.

Setup
-----

Easiest setup is create a role in your own repository and adding this:
* Decide on the name of the setup, let's call the role "" and the setup"frank"
* *hint* you can have any number of setup configured in this role. You just always have to load first **your** role (defining the setup) and then **DrPsychick.ansible_influx_downsampling** for each setup.

`tasks/main.yml`
```---

- name: "Include definition from influxdb_{{vars_name}}.yml"
  include_vars: influxdb_{{vars_name}}.yml
    when: vars_name is defined
```

`vars/influxdb_frank.yml`
--> take one from the examples directory as a base for your own: [examples/](examples/)

Now in your playbook, include both roles:
```
- name: InfluxDB 
  hosts: localhost
  roles: 
    - { role: , vars_name: "frank" }
    - { role: DrPsychick.ansible_influxdb_downsampling}
```


Attention
=========
If you enable **backfill**:
* Check the size of your data first. Depending on the amount of series in a measurement, you need to configure the time range for backfilling. A good default is "1d".
* Timeouts: Your InfluxDB as well as the calls in this playbook may time out! Or you may hit other limits in the influxdb.conf.
* Stats: They will **likely** crash because they query big time ranges with lots of data. Only turn them on for small backfill jobs.

My Settings for backfilling 9GB of data on 5 aggregation levels on a docker container with 3GB of RAM (no CPU limit for backfilling)
* `ansible_influx_databases`, 5 levels: 14d@1m, 30d@5m, 90d@15m, 1y@1h, 3y@3h
* `ansible_influx_timeout`: 600 (10 minutes)
* influxdb.conf: `query-timeout="600s", max-select-point=200000000, max-select-series=1000000, log-queries-after="10s"`
* duration:

My full setup can be found in [examples/full-5level-backfill-compact/](examples/full-5level-backfill-compact/)

History
=======

Version 0.3: Complete incl. automatic compaction, tests and good examples.

* [ ] full readme -> docs
* [ ] multiple examples -> docs/example
* [x] more tests:
   * [x] run backfill without CQ and switch RP on existing data (compact/evict old data)
   * [x] run backfill without CQ during operation and switch RP
   * [x] setup with 2 levels and CQ
* [x] howto switch retention policy (cleanup after all is setup)
   * [x] Case: copy from "autogen", no CQ, drop source after backfill + set default RP -> see test
* [ ] shift RPs by "spread" seconds: 60+/-5sec EVERY 5m+-1s,2s,3s,... + step in seconds : use time(1m,1s) for offset!
* [ ] add RP shard duration option
* [ ] refactor/cleanup variables
* [ ] add changed_when conditions

Version 0.2: Fully working and tested. No deleting of data. Stats + CQ update.

* [x] Update description + basic readme
* [x] Check variables upfront (define clear dependencies) and print useful error messages before acting
* [x] fix: continuous_query is required even if empty (bad usability)
* [x] more tests: 
   * [x] test parallel tests
   * [x] prepare seeding (generator or file?)
   * [x] run downsampling + backfill on existing DB (needs seed)
   * [x] run backfill with step X (on RP with 7d)
* [x] set RP default yes/no
* [x] improve/extend dict structure (BC break!)
* [x] update continuous queries (drop+create)
* [x] stats (total data points written per DB / average downsampling ratio)
* [x] support selective group by in backfill and continuous query

Version 0.1:

* basic functionality
* create databases + retention policy
* backfill measurements
* create continuous queries
