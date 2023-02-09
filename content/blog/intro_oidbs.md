+++
title = "OIDBS: An Open Source MQTT Driven Benchmark Suite for Massive IoT Data"
description = ""
date = 2022-10-18T12:00:00+00:00
updated = 2022-10-19T12:00:00+00:00
draft = false
template = "blog/page.html"

[taxonomies]
contact = ["joinbase0"]

[extra]
lead = "<a href=\"https://github.com/open-joinbase/oidbs\">OIDBS (Open IoT Database Benchmark Suite)</a> has been open sourced for benchmarking massive IoT messaging and end-to-end data stack performance."
+++


# Intro

In the development of JoinBase, we complete the [OIDBS (Open IoT Database Benchmark Suite)](https://github.com/open-joinbase/oidbs). Because we find that there is not a simple, flexible, high performance tool or framework to help benchmarking an IoT end-to-end data stack. To enable a concise end-to-end experience is important for in-production data systems. Because a full IoT data stack may be complex, there can be a huge gap between the local sub-system and the global system.

# Make Benchmark Fast and Simple

<img src="/imgs/blog/intro_oidbs/oidbs_arch.png" alt="OIDBS Arch" class="img-fluid">

### Composable Commands

One key design of OIDBS is: composable commands. 

The benchmark suite consists of three commands: gen, import and bench. 

1. `gen`: to generate the controlled, reproducible message data to files on disks in CSV or JSON format.
2. `import`: to import the CSV or JSON format files to the MQTT brokers or PostgreSQL/Timescale servers.
3. `bench`: run preset SQL queries on specific targets.

These three composable commands decouple main capabilities of various IoT and data scenarios. And the decoupling makes the benchmark faster and less overhead. For example, if the message is generated in-place in the hot loop to send the message, the data calculating and filling must interfere with sending.

### Hierarchical Pluggability   

For maximum external understanding and contribution, we offer pluggable designs at various levels with minimal architecture. The whole OIDBS is easily to be extended from the data source formats, the transport protocols to backend servers via standard interfaces.

### Benchmark Models

The concept, `benchmark model`, has been proposed to the core of OIDBS extensions. A benchmark model is used for grouping different benchmark dataset and its corresponding data-gens, schemas, queries.

In the first launch of JoinBase and OIDBS, two models - 'nyct_lite' and 'nyct_strip' are benched: 

| model name  | model dataset size | description | how to get | 
| :----------- | :----------- | :----------- | :----------- |
| nyct_lite |  10906860 rows | New York City Dataset used in official Timescale <br/> (compressed in one 424MB file) | [Timescale Docs](https://docs.timescale.com/timescaledb/latest/tutorials/nyc-taxi-cab/) |
| nyct_strip | 1000000000 rows | Extended 1-billion-row New York City Dataset with stripped columns<br/> (compressed in 13GB files) |  [download pre-made from mediafire](https://www.mediafire.com/folder/4xaot2rywzyd7/nyct_strip) <br/> or <br/> prepare from [this github project](https://github.com/toddwschneider/nyc-taxi-data) |
<p align="center"> Tab.1 OIDBS models introduction <p/>

These two models are derived from official, real-world [New York city dataset](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page). More about why these two models proposed could be seen in [the JoinBase's benchmark page](/benchmark/#benchmark-model).

# Demo

Let's watch a simple example about how to use OIDBS to benchmark the throughput of the latest Mosquitto release in minutes. This video is also a great, quick-start demo for how to use the Mosquitto with its own client.

<div align="center" class="video-container">
<iframe class="video" width="560" height="315" src="https://www.youtube.com/embed/Y3ETIbGcZ6I?start=1" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
<p align="center"> Video: Quick Start to OIDBS <p/>

From the result of this demo, we can see that the performance of the forward throughput of the current Mosquitto release in WSL2(Ubuntu) with one-pub-one-sub is 10906860 messages / 43.48 seconds ~= 250K mps or 1.6GB / 43.48 seconds ~= 36MB(in csv format)/s.

However, the 250k messages/s with localhost is not good because one-pub-one-sub means the concurrency of connections is one. More importantly, we must point out that, the Windows environment is not suitable for benchmarking a MQTT broker, not mention that WSL2 is essentially a virtual machine. Here, we just show how easy to use the OIDBS benchmark. Because there is no difference between Linux and Windows WSL2 in the workflow. For non-production usages, this Windows setup is still acceptable.

# One More Thing

Finally, we are proud to point out that, for the same 1 connection concurrency condition, [our JoinBase](https://github.com/open-joinbase/JoinBase) is still 30% faster than that of Mosquitto. But please note that, in JoinBase, we do many many heavy ultra works, including message parsing, message transferring, data computing and storing. In the near future, We will demo that, under the extreme pressure of OIDBS, the overwhelming performance advantage of JoinBase over the existing mainstream MQTT brokers, and welcome everyone to [request our free distribution](/request). 

A new TPCx-IoT inspired benchmark model will be released soon. Watch our communities:

[OIDBS community](https://github.com/open-joinbase/oidbs)

[JoinBase community](https://github.com/open-joinbase/JoinBase)



