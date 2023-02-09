+++
title = "JoinBase 2022.12: HTTP and WebSocket Interfaces are Up for the Multi-protocol Time-series Database"
description = ""
date = 2022-12-29T12:00:00+00:00
updated = 2022-12-30T12:00:00+00:00
draft = false
template = "blog/page.html"

[taxonomies]
contact = ["joinbase0"]

[extra]
lead = "In JoinBase 2022.12, the HTTP and WebSocket Interfaces are introduced, which makes JoinBase becoming a general multi-protocol time-series database. Futhermore, three extension points and topic aliases are also added into JoinBase to empower users with unlimited custom capabilities."
+++

# HTTP Interface

In the existing databases, there are very few databases that can natively support HTTP interface. This brings up a problem: if users want to provide REST services based on these databases, they need to combine other HTTP services on the top of current databases.

The HTTP interface is an effort of JoinBase to prompt the end-to-end experience for its users. See the HTTP version of quick-start:

<div class="row justify-content-center text-center">
      <div id="jb1m"></div>
      <script src="/asciinema-player.min.js"></script>
      <script>
        AsciinemaPlayer.create('/casts/quick_start_http.cast', document.getElementById('jb1m'), { preload: true, autoPlay: true });
      </script>
      <p>Tips: you can copy the command from the cast, paste the command into your shell to execute!</p>
</div>

In the above cast, a simple read-write-read REST based flow has been demonstrated:

1. Combine the SQL and HTTP client, you can do all data works under the PostgreSQL wire protocol. If you are a frontend developer, just work with curl is enough. A database console like psql or mysql is not needed any more.
2. The HTTP interface also supports the batch data ingestion like in the MQTT interface.
3. It is a piece of cake to integrate with your own tools or apps. Just your own REST style.

#### Quick Benchmark

Another of big problem of HTTP protocol is that it is verbose and low efficient for the high performance application layer. Most database authors lack the performance optimization practice for the transport layer. This is another reason why the HTTP interface is not popular in the database community.

However, JoinBase, as built from scratch, fixes this problem. The authors of JoinBase are practiced with modern software optimizations for full stack in the long time. This time, we bring a top performance HTTP interface for our users like that done for the [MQTT interface implementation](/benchmark) previously.

The HTTP benchmark tools are very mature now. Here, we just pick up the great tool - [wrk](https://github.com/wg/wrk), for the quick benchmark. We use another popular [database with HTTP interface support - ClickHouse](https://clickhouse.com/docs/en/interfaces/http/), as the comparison object.

We build the wrk from latest head to and use ClickHouse latest stable version 22.9.7.34. The hardware is based on a single socket with Intel Xeon Platinum 8260 which has 48 hyper-threads. So the benchmark thread number of wrk is 24 threads. Benchmarking on a single node will lead to the competition for running resources. So, such a benchmark is not very rigorous. But, in our experience, the results are quantitatively acceptable from the view of comparison. Because, for all benchmark subjects, the environment and client configs are the same. And the running resource is reserved for both the client and the server.

Just jump to some interesting results:

1. HTTP Ping 

<div class="text-center">
<img src="/imgs/blog/http/http_ping_joinbase_vs_clickhouse.png" alt="multi-protocol" class="img-fluid">
<p align="center"> HTTP ping bench with wrk <p/>
</div>

This ping bench is for evaluating the intrinsic HTTP protocol implementation performance. The throughput of JoinBase ping is around ~25x faster than that of ClickHouse ping. The performance of JoinBase ping stands for the performance with a small message interaction. It is great to see that, even some conservative optimizations in the first release, **JoinBase can reach 1.6 million HTTP requests/response per second**. Although, this performance is not matched against 7 million mps in our MQTT interface. But the record of MQTT interface is done for QoS=0, the implementation of HTTP interface is equivalent to the QoS=1 level of MQTT interface.

There is another interesting difference between JoinBase and almost other databases: an authentication information must be provided to all the JoinBase interface before using. So, **you can not use JoinBase before setting up a user/password**. But common DBMSs, like ClickHouse, PostgreSQL and MySQL, allow default user which often results in silent compromises in the real world.

2. HTTP Pipelined Ping 

One interesting feature of wrk is that wrk supports the HTTP pipelining. JoinBase's HTTP interface does not fully optimize for HTTP pipelining. Because, in the IoT scenario, the client pipelining makes non-sense and most clients does not support pipelining.

But JoinBase implements all the HTTP interface features from the scratch. This makes JoinBase can control all the aspects of implementation. We just make a tiny change to allow JoinBase can correctly handle the pipelined requests.

Let see the result:

<div class="text-center">
<img src="/imgs/blog/http/http_ping_pipeline_joinbase_clickhouse.png" alt="multi-protocol" class="img-fluid">
<p align="center"> HTTP pipelined ping bench with wrk <p/>
</div>

Clearly, our pipeline implementation **boosts the throughput to 3 million requests per second**, which is ~2x of the non-pipelined case (and ~50x of that of ClickHouse ping). On the contrary, ClickHouse does not support the pipelined HTTP requests at all. So, all the socket connections suck in the bench. 

3. HTTP Based Select Query

Let's roll a further non-trivial case into the benchmark: do one plain query via the HTTP interface.

Due to that JoinBase use the HTTP body to carry the query, we use the following simple script for wrk benching. For the ClickHouse, it supports to put the query text in the uri's parameters, so the direct wrk command is OK to run. (The ugly is that you need to escape necessary characters in the uri, which is not for human-beings.)  

<div class="text-center">
<img src="/imgs/blog/http/wrk_conf_bench_select.png" alt="wrk script for benching query select" class="img-fluid">
<p align="center"> Simple wrk script for benching JoinBase <p/>
</div>

<div class="text-center">
<img src="/imgs/blog/http/http_select_joinbase_vs_clickhouse.png" alt="multi-protocol" class="img-fluid">
<p align="center"> HTTP based select query bench with wrk <p/>
</div>

The bench result is very profound: the performance of JoinBase HTTP based simple query is ~100x that of ClickHouse. JoinBase crushes the ClickHouse in this query scenario! JoinBase truly have a unique base, you can't achieve an order of magnitude performance improvement with the copycat.

We have more non-trivial queries shown in our [benchmark page](/benchmark)'s concurrency benching section. Here, the HTTP interface itself is not the bottleneck of the performance, so they share the same excellent outcome. It is also encouraged our users to repeat the bench yourself.

**"JoinBase's HTTP interface is so fast that you can use it to provide unlimited production-level REST services without any worry."**

# WebSocket Interface

WebSocket interface is also available from now. And a new webAssembly based high performance interface is experimented in the interface implementation. If you are interesting, feel free to [request](/request) the free JoinBase.


# Multi-protocol Ecosystem

<div class="text-center">
<img src="/imgs/blog/http/multi-protocol.png" alt="multi-protocol" class="img-fluid">
<p align="center"> Multi-protocol Ecosystem of JoinBase <p/>
</div>

With the HTTP interface up, the end-to-end experience has been enabled for any time-series data services. So, JoinBase becomes a more general time-series optimized database.

The HTTP interface is one long waiting feature requested by the community. Now we just complete this feature for our community. And we are interesting more interfaces, for example, the green-colored words in the above picture. But we don't have enough information right now to confirm whether implementing them is necessary. **If you are interested in these or other protocols/interfaces, please join our community!**

Finally, all interfaces in JoinBase has two modes: plain and secured. It is found that the secured transports are usually implemented within 80%+ performance of the plain transports. (More benchmarks of secured transports will be shown in the future.). JoinBases only recommend to use secured transports in the production in that the secured transports are fast enough.


# Extensions

From this release, JoinBase start to support [three types of extensions](/docs/references/extensions): UDM(User Defined Mapping), UDF(User Defined Function) and UDVF(User Defined Vector Function). Through these extensions, JB solves the problem of user-defined logic hooking in main aspects. Let's discuss the UDM as the example.

Some of our users say that it is hard to change the message payload themselves because the end devices are bought from 3rd party vendor. The [UDM extension](/docs/references/extensions#user-defined-mapping) just come to solve this problem. 

In the first release of JoinBase, like some MQTT brokers or databases, JoinBase has supported a rule based mapping. But the real-world JSON payload is arbitrarily nested, the simple rule based way is not enough to solve the arbitrarily complex payload mapping. Most brokers or databases just stop here. Some databases, like MongoDB or PostgreSQL, support the store the JSON or its variants directly. The price is that the query and analysis performance drops by orders of magnitude.

JoinBase solves this problem by integrating a message stream processing/mapping engine into the database. Just image that you have an embedded Kafka in JoinBase. The difference for JoinBase is that we push the processing engine into the top performance in that all components in JoinBase are organically integrated together in the zero-abstraction, zero-copy and zero-allocation style.

A real-world complex session based message mapping extension has been provided for one of our energy IoT users in the form of UDM. Interestingly, the UDM extension can be more efficient than that of general rule based mapping engine, since you can provide a much simplified custom logic in your UDM.

If you are interesting, feel free to [request](/request) the latest free JoinBase.

# Topic Aliases

Some of our users say that it is hard to change the message topic as well because the end devices are from 3rd party vendor. From this release, JoinBase start to support one feature called [`Topic Aliases`](/docs/references/topics#topic-aliases).

With topic aliases, You can mapping any topic/path into the normalized [topic](/docs/references/topics) in JoinBase. This is done by simply setting the mappings in the conf file. For example, the following lines in the conf,

```toml
[topic.aliases]
"/abc/sensors" = ["/edge/x2view/1234567890/some_deeper_uri_path"]
"/abc/sensors" = ["/edge/x2view/0123456789/another_deeper_uri_path"]
```

Two paths "/edge/x2view/1234567890/some_deeper_uri_path" and "/edge/x2view/0123456789/another_deeper_uri_path" are mapped to one single normalized topic "/abc/sensors" which is equivalent to the database entity "abc.sensors". All messages sent to the two long topics will go to the database table "abc.sensors".


# One More Thing

JoinBase provides lots of values beyond the peers of this era. We sincerely invite more users to join our community. JoinBase can help you!

Get your AIoT data services one step ahead with free SmartBase and JoinBase by [request here](/request).

Talk with SmartBase and JoinBase developers in [the Discord server](https://discord.gg/sqX6vfnURj).

Watch or submit your ideas [in the community](https://github.com/open-joinbase/joinbase).