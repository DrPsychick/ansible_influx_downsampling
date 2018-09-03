[![Build Status](https://travis-ci.org/DrPsychick/ansible-influx-downsampling.svg?branch=master)](https://travis-ci.org/DrPsychick/ansible-influx-downsampling)

Configure influxDB for downsampling
===================================

Two usage scenarios:
* You already have an influxdb running and it's getting BIG, so you want to introduce downsampling on-the-fly to make things faster and cheaper
* You intend to use influxdb and want to set it up with downsampling in mind

honestly the two use cases are not much different. The biggest difference is the time it takes to run through the playbook. Of course, if you work on existing data, don't forget to have a proper backup!

Preparation
-----------
As preparation you don't need much, expect knowing how exactly you want to downsample your data.

History
-------
Version 0.3:
T more tests:
T * run backfill without CQ to switch RP on existing data
T * run backfill without CQ during operation (configurable timing of input)
T howto switch retention policy (cleanup after all is setup)
T * Case: copy from "autogen", no CQ, drop source after backfill + set default RP -> see test

Version 0.2:
W Check variables upfront (define clear dependencies) and print useful error messages before acting
T full readme -> docs
T multiple examples -> docs/example
T more tests: 
T * test parallel tests
T * prepare seeding (generator or file?)
T * run downsampling + backfill on existing DB (needs seed)
T * run downsampling + backfill + switch RP on existing DB (needs seed)
T * run backfill with step 7 (on RP with 7d)
* set RP default yes/no
* improve/extend dict structure (BC break!)
* update continuous queries (drop+create)
* stats (total data points written per DB / average downsampling ratio)
* support selective group by in backfill and continuous query
Version 0.1:
* basic functionality
* create databases + retention policy
* backfill measurements
* create continuous queries
