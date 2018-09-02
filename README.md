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
Version 0.1:
* basic functionality
* create databases + retention policy
* backfill measurements
* create continuous queries
