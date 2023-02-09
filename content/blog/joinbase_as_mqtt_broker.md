+++
title = "JoinBase 2022.11: An IoT Database with Built-in MQTT Broker"
description = ""
date = 2022-11-08T12:00:00+00:00
updated = 2022-11-08T12:00:00+00:00
draft = false
template = "blog/page.html"

[taxonomies]
contact = ["joinbase0"]

[extra]
lead = "In the 2022.11 release, JoinBase now can be used as a high performance MQTT broker with full publishing/subscribing capabilities. According to the primary stressing, <b>the performance of the first full-broker-enabled JoinBase is ~5x faster than that of one popular broker EMQX (5.0.9)</b>."
+++

# Quick Intro
<div class="text-center">
<img src="/imgs/blog/joinbase_as_mqtt_broker/joinbase_arch.png" alt="joinbase" class="img-fluid">
<p align="center"> IoT data made simple with JoinBase! <p/>
</div>

JoinBase is a free all-in-one data stack built around our unique and innovative database technologies. 

We are committed to simplifying the IoT data pipeline while delivering the highest production efficiency. By lowering the consumption threshold of IoT data, we believe that JoinBase can benefit every organization and individual in this era.


# Why Built-in Broker

The answer is, **not only the built-in broker!** 

The IoT data and data stack are expanding violently, and out of control for many enterprises. JoinBase wants to change this.

We plan to add more interesting IoT scenario simplifications and integrations in JoinBase to allow developers to build IoT data systems by using one or two simple techniques which they are familiar with, from zero to planetary scale.

# Early Access Stressing

<div class="text-center">
<img src="/imgs/blog/joinbase_as_mqtt_broker/stopwatch.jpg" alt="joinbase" class="img-fluid">
<p align="center"> Let's stress! <p/>
</div>

In order to observe the performance of each brokers under the ultimate pressure, we, again like our [OIDBS](/blog/intro_oidbs), create a new fastest stressing/benchmarking tool called `MQTTBT`. In this new stressing tool, the total end-to-end ingestion throughput is proposed to evaluate. We will publish a dedicated blog article for introducing this tool soon (you can always request it in the community in advance).

The following the stressing process and the result of JoinBase 2022.11 in in 2p-1s (2 publisher to 1 subscriber):
<div class="text-center">
<img src="/imgs/blog/joinbase_as_mqtt_broker/stress_results_joinbase.gif" alt="stress result of JoinBase" class="img-fluid">
<p align="center"> Stressing process and the result of JoinBase 2022.11 (gif) <p/>
</div>

Surprisingly, it is found that many popular brokers, like EMQX and HiveMQ CE, can not pass our stress tool under non-trivial QoS=0 ingestion connections. 

When the pressure exceeds their capacity, EMQX will disconnect the subscribers, HiveMQ CE will drop outgoing messages even for 1p-1s. Ridiculously, for the lack of right documents, we still can not figure out how to config them to work under non-trivial ingestion connections after hours searching.

Although the message in QoS=0 is not guaranteed by the spec, the tacklings of these brokers are not IoT scenario friendly. (We discuss the good design in the later section.) 

In the real-world IoT scenario, the sensor value is generated continuously, one loss point is not important, but QoS=0 provides 10x best performance than QoS=1. If the connection is lost, you just lose the in-flight message, which is usually one for that client. JoinBase guarantees that if the connection is reliable, the message even with QoS=0 is guaranteed to be stored reliably (assumed that the OS is running normally). Also in JoinBase, millions of connections and millions of messages are unified without any compromises. This brings more possibilities and greater flexibility to the design of large-scale IoT data transport networks.

<div class="text-center">
<img src="/imgs/blog/joinbase_as_mqtt_broker/stress_results_emqx.gif" alt="IoT scenarios" class="img-fluid">
<p align="center"> Stressing process and the result of EMQX (gif) <p/>
</div>

The above gif is the EMQX stressing process and result in 2p-1s. It is easy to find that <b>the performance of the JoinBase 2022.11 is ~5x faster than that of one popular broker EMQX (5.0.9) in the same stressing condition</b>. The HiveMQ even does not pass our stressing in any p-s combination.

We will present a detailed benchmark report in the near future.

# Safety and Privacy

In benchmarking, we find that EMQX at least silently reads all disk infos in current system, like:

```log
2022-11-07T12:53:19.340116+00:00 [notice] alarm_handler: {set,{{disk_almost_full,"/data/n4"},[]}}
```

Here, `/data/n4` is an unused disk in the system, but EMQX is put in another disk with nothing about knowing `/data/n4` in conf. Futhermore, EMQX enables its telemetry by default, like many other open-source products (for example, VSCode or TimescaleDB).

We strongly recommend that any infrastructure product should not collect any user information without explicit permission.

JoinBase keeps highest standard in the field of product safety and privacy:

1. JoinBase do not silently write any data to the disk of users or any location of the Web.
    
    All data directories must be specified in the conf file. And we suggest you change to your onw directories at the first get started document.

2. You can do nothing to JoinBase if you do not create a dedicated user.

   In fact, the core philosophy of JoinBase is allow-list based. All external interactions are checked explicitly. You must create a new user to use JoinBase. (Don't worry, it is so quick). Compromises that often occur on other databases by the default initial configuration never happen in JoinBase. 

3. JoinBase do not send any data out to any Web location.

   And JoinBase do not do any non-user-business background works, like telemetry. On the contrary, many distributions of open source projects collect various user information by default.
      

# Think Time

<div class="text-center">
<img src="/imgs/blog/joinbase_as_mqtt_broker/think.jpg" alt="joinbase" class="img-fluid">
<p align="center"> Why is JoinBase faster? <p/>
</div>

We don't want to fire any war between languages or systems. Here, we just show some thoughts under the hood which users should know to construct a performance critical engineering:

1. Performance is largely independent of language, provided the language and system keep wise in its design.

Of course, to make one language and system kept wise is hard. 

Here, [JoinBase](https://github.com/open-joinbase/) is done in [Rust](https://www.rust-lang.org/), correspondingly EMQX is done in [Erlang](https://en.wikipedia.org/wiki/Erlang_(programming_language)) and HiveMQ CE is done in Java. 

Erlang is an interesting language to provide wide features to enable Erlang based network application programming easier. Java use GC to make developer happy without worries about memory safety. However, **there is no free lunch**. Features come with kinds of prices inevitably.

The Rust philosophy, conversely, is [KISS](https://en.wikipedia.org/wiki/KISS_principle). All the things like actors or hot-swappiness should and could be done in the external mechanism. JoinBase follows the Rust philosophy and built from scratch. We keep every call in great engineering and performance shape for our users. We even fix the broken message channel in recent Rust standard library. Yes, even official language standard library has problems! Don't rely blindly!

2. Correct design philosophy is important for your business

One common problem HiveMQ CE and EMQX mentioned in above section is that, they are not resilient enough under stressful situations. 

The right reaction under high load is `back-pressure`. From the kernel to the application layer, we have many opportunities to do this kind of transport back-pressure. Blindly killing connection or messages is the ugliest choice. It makes the system highly underutilized, and more importantly, unavailable in high pressure.

# Coming Soon

1. Stress/benchmark mainstream brokers with open-source tools.

Any benchmark which can not be reproduced is meaningless. Any benchmark without apple-to-apple comparison is meaningless as well. We are responsible for providing insights to all IoT users on how to choose high performance data system. 

We will release the complete benchmark report in the near future. Stay tuned!

2. Beyond the interoperability between database and MQTT.

In JoinBase, we have made the `Topic` concept in MQTT and the `Table` concept in database exchangeable. Soon, we will enable the query capability via MQTT subscribing. This shows how we greatly push both two communities by creating a new work pattern!

3. Any great idea proposed by users in [the community issues](https://github.com/open-joinbase/joinbase/issues).

# More Links

Get your IoT infrastructure one step ahead with free JoinBase by [request latest free JoinBase](/request).

Talk with JoinBase developers in [the Discord server](https://discord.gg/sqX6vfnURj).

Watch or submit your ideas [in the community](https://github.com/open-joinbase/joinbase).