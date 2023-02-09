+++
title = "Pstations: TPCx-IoT Inspired IoT Data Benchmark Model for OIDBS"
description = ""
date = 2022-10-23T12:00:00+00:00
updated = 2022-10-26T12:00:00+00:00
draft = false
template = "blog/page.html"

[taxonomies]
contact = ["joinbase0"]

[extra]
lead = "TPCx-IoT inspired IoT data benchmark model, named <b>Pstations</b>, has been added to <a href=\"https://github.com/open-joinbase/oidbs\">OIDBS (Open IoT Database Benchmark Suite)</a>."
+++

# Problems

<img src="/imgs/blog/pstations/things.jpg" alt="IoT scenarios" class="img-fluid">
<p align="center"> How to benchmark the internet of things? <p/>

IoT scenarios are increasingly becoming scalable. From the case of big giants like that Apple which needs handling [hundreds of million Apple watches](https://www.statista.com/statistics/1221051/apple-watch-users-worldwide/) to that of one small individual who just wants to build up a homebrew [animal monitoring system](/blog/tinywild/). 


# Motivation

In OIDBS, we have solved the methodologies of benchmark. Nextly, we may pick up for a nice data model. Two New York City taxi dataset based models have been proposed. The problem of them is, that they are fixed external data sources. A scalable and fast enough model is needed for the scalable IoT scenarios as mentioned.

Generally, any data sources can be chosen to do the benchmark. But it is better to refer to any useful previous work in that a real-world inspired model reduce the understanding resistance to the benchmark of users.

# TPCx-IoT Screwed Up

<img src="/imgs/blog/pstations/tpc.jpg" alt="IoT scenarios" class="img-fluid">
<p align="center"> How to benchmark the internet of things? <p/>

[TPCx-IoT](https://www.tpc.org/tpcx-iot) is a benchmark for IoT gateway systems proposed by [TPC org](https://www.tpc.org). But it has many problems:

1. This benchmark is not user oriented but commercial vendor oriented.
Like other "notorious" benchmarks proposed by TPC (for example, TPC-H and TPC-DS), the hardware is provided per vendor, different hardwares plus different softwares with "dedicated optimizations" make the result ranking totally no sense.

2. This benchmark is mainly for benching data system for IoT.
There is no gateway ingestion interfaces considered in the spec. Then the benchmark in transporting is not standardized, which leaves the benchmark capabilities of this ingesting or importing suspectable.
Although  is mentioned in the spec, but there is one main-stream MQTT gateway used in the kit.  

3. The benchmark is complex. Not explicit pluggablity and extensibility in the benchmark kit. If a benchmark is hard to repeat, it just makes nonsense.

# Pstations in OIDBS Comes

<img src="/imgs/blog/pstations/grid1.jpg" alt="Power Grid" class="img-fluid">
<p align="center"> Do you know the power grid of California has 3,200 power substations in around 2017? <p/>

Pstations is an OIDBS model adapted from the power substations model of TPCx-IoT. The workflow of benchmark framework is still that of OIDBS, but the data features and scenarios are based on those power substations.

`Pstations` model is simple actually. Let us do a concise understanding via the following schema creation SQL:
```sql
create table benchmark.pstations
(
    station_id UInt32,
    sensor_id UInt8,
    sensor_kind UInt8,
    sensor_value Float32,
    ts DateTime
)
partition BY ymdh(ts);
```

Here, the schema is only for understanding model because from the message to the table record is simply a 1-1 mapping.

The model `pstations` contains 5 fields: station_id, sensor_id, sensor_kind, sensor_value and ts. The model objects consists of two-level object: stations(the short of substations) and sensors. In a real-world configurations, it may have thousands of stations, and hundreds of sensors. **This means that it is very reasonable for even 1 million sensoring points per second.** This is the biggest characteristic of the TPCx-IoT model which has been reserved by `pstations`.

In the model `pstations`, we use a maximum flexibility schema. That is, the type of sensor is recorded by the sensor_kind field. So, you can extend sensor types as much as possible (here, is limit to max 256 by UInt8 type). 

One point is that it is possible to use Enum-like types here. But the Enum-like type is a database concept, other IoT data systems, like message brokers, do not have such concept. So, for no barriers to understanding for all users, we just use the plain integer ids to represent the objects in the model.

Get more details from the sources of [the OIDBS project](https://github.com/open-joinbase/oidbs).

### How to Use

Just a one-liner is used to generate a CSV format pstations model data file:

```bash
oidbs -- gen OUTPUT_PATH -w 1 -i 2 -m '{"num_sensors":2,"num_stations":4}' -o
```

Here is the table of parameters:

| parameter  | meanings | 
| :----------- | :----------- |
| OUTPUT_PATH |  the only mandatory parameter for output file path, please change to your own path. |
| -w |  the number of generation workers. <br/>In the same time, it decides the number of output files, then decides the ingesting/importing concurrency. |
| -i |  the time interval per worker to gen in seconds, the default is 1 second. Note that the time interval is per worker means that different workers generate the records in different time spans. |
| -m |  the model parameters, in the model specific json string format, the default is empty json object. <br/>In the `pstations` model, there are two model parameters: num_sensors and num_stations. We can not specific these parameters in advance in the fixed parameter list, because the number of models is unlimited. |
| -o |  the flag to enable output out of order. <br/>It doesn't make much sense for the brokers, because brokers do not care the ordering of messages before their incoming.  <br/>This is mainly for benching the end-to-end data stack with databases in the pipeline. We will demonstrate out-of-order messaging could have a huge performance impact on databases in the pipeline in the future. |


### Pstations Edge-100m

Recently, we are preparing an [**Edge Data Stack Capabilities Ranking**](/ranking) for the world (WIP). The interesting results will be discussed in that dedicated page when comes out.

Because from low-end SBCs(Single-board computers) to high-end edge nodes, the performance gap is two or more orders of magnitude. The existed external NYC taxi dataset model is either too big or too small. That's exactly what `pstations` came to solve.

Here, we just proposed a `pstations edge-100m` for the edge scenarios, which could be generated with the following OIDBS command:

```bash
oidbs -- gen OUTPUT_PATH -w 10000 -i 100 -m '{"num_sensors":10,"num_stations":10}' -o
```

here, we have ten sensors in every ten stations will generate 10000 files with 100 seconds time in the echo file's time span. The total rows of records in the `pstations edge-100m` is 100 millions which is the stem of edge-100m naming.

# Demo

<div class="row justify-content-center text-center">
      <div id="jb1m"></div>
      <script src="/asciinema-player.min.js"></script>
      <script>
        AsciinemaPlayer.create('/casts/pstations.cast', document.getElementById('jb1m'), { preload: true, autoPlay: true });
      </script>
      <p>Tips: you can copy the command from the cast, paste the command into your shell to execute!</p>
</div>

Here, it is interesting to find that we generate the 3.4GB `pstations edge-100m` dataset in 3.88s in this machine. A modern tool built for the modern hardwares makes our lives easier!

Please see [the demo in the introduction article](/blog/intro-oidbs/#demo) about how to import the generated model's data against your MQTT brokers or IoT data stacks like JoinBase.

# Outlook

The `pstations` model can be strengthened in some places. For example, we use a biased random data distribution for the fields, maybe more distributions could be tested. In the future, we hope more real-world inspired models can be added into the OIDBS to make benchmarks covering more dedicated scenarios.

One of most important near episodes is the upcoming [**Edge Data Stack Capabilities Ranking**](/ranking). The capabilities of edge computing systems will be rolled out within modern IoT data stack perspectives, from the smallest 4.2cm*4.2cm SBC to the largest hundreds-of-cores bare metal server.
