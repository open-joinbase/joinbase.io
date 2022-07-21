+++
title = "High Availability"
description = ""
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 890
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "In this document, the guidance on the high availability of JoinBase is provided."
toc = true
top = false
+++

## Asynchronous Replication

JoinBase has experimental support for the asynchronous primary-secondary replication. 

<p align="center">
<img src="/imgs/docs/replication.png" class="img-fluid">
</p>
<p align="center"> Asynchronous Replication Diagram <p/>

The key here is, the data/messgae/write can only be sent to the primary node, but the query/read can be sent to any one.

Compared with that of other databases, the asynchronous replication implementation of JoinBase has the following unique advantages：

1. Almost Zero Overhead

    The secondary nodes have little performance impact on the primary, as long as the number of secondary nodes is not too crazy (for example, less than 1000 nodes).

2. Up-to-Sub-Second Latency

    This makes out of sync data interval very tiny or no if your message ingestion frequency is not too crazy (for example, sub-second-frequency ingestion).

3. Scale-out-able Query Capabilities

    JoinBase makes platform-type users to expand their query capabilities without any worry. Note, our single-node primary has supported near ten-millions connections and messages per second. 

4. DevOps Free (of course)

   Just config several parameters in your conf, all happens automatically.

## Synchronous Replication

It is believed that the JoinBase's extreme performance asynchronous replication is enough for IoT domain users. However, in theory, the asynchronous replication can not guarantee 100% data safety. When a permanent failure for the primary node occurs (the primary node can not come back after some major failure), out of sync data data may be lost. 

Please note, out of sync data data in non-permanent failures still survives greatly with the asynchronous replication. As an example, an AWS instance with EBS volume is practically considered to have no permanent failure.

JoinBase does not provide the synchronous replication option now. Because the synchronous replication causes orders of magnitude performance degradation, which most of databases will not tell you. And, for the IoT data, data durability failures in the very tiny probability (a.k.a., permanent failure case) are often tolerable. Please recall the design principle of the MQTT protocol.

If you really want the effect of synchronous replication, one MQTT messaging based solution proposed: dual/multiple active primary runnings. That is, clients send multiple messages to dual/multiple active primary nodes. For using this solution, the message's QoS should be 1. JoinBase honors QoS 1, which reliably persists messages in the server side. 

A new innovative clustering mechanism is in the progress for more elastic high availability guarantee options. Stay tunned!

    
