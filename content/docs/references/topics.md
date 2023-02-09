+++
title = "Topics"
description = ""
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 560
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "Topic is the core concept of JoinBase which bridges three data standards or protocols  - database, MQTT and HTTP."
toc = true
top = false
+++

Topic is just an URI or path for addressing the database entities. JoinBase extends the database qualified table to MQTT/HTTP protocols to unify the representation of storage objects or data sinks. With topic, JoinBase has one unique data entity object semantic description under all different protocols.

## Core

<p align="center">
<img src="/imgs/docs/topics.png" class="img-fluid">
</p>
<p align="center"> Asynchronous Replication Diagram <p/>

In the JoinBase, the data sink is just described by the qualified table, a.k.a., database.table. **The qualified table is just the topic called in MQTT protocol and the path called in HTTP protocol.** 

For example, the following PG console or shell commands are equivalent：

| Protocols |  DB Entity/Topic/Path     |       Statements/Commands          |
| :---------| :------------------------ | :------------------------ | 
| Database  | abc.t                     | insert into abc.t values (1,2) |
| MQTT      | /abc/t                    | mosquitto_pub -d -t /abc/t -h 127.0.0.1 -u abc -P abc -m '{"a":1,"b":2}' |
| HTTP | /abc/t   | curl -H 'X-JoinBase-User: abc' -H 'X-JoinBase-Key: abc'  -X POST 'http://127.0.0.1:8080/abc/t' -d '{"a":1,"b":2}' |


## Topic Aliases

To provide the greatest degree of semantic compatibility, JoinBase supports the concept called `Topic Aliases`.

With topic aliases, You can mapping any topic/path into the normalized [topic/path](/docs/references/topics) in JoinBase. This is done by setting the mappings in the conf file. For example, the following lines in the conf,

```toml
[topic.aliases]
"/abc/sensors" = ["/edge/x2view/1234567890/some_deeper_uri_path"]
"/abc/sensors" = ["/edge/x2view/0123456789/another_deeper_uri_path"]
```

Two paths "/edge/x2view/1234567890/some_deeper_uri_path" and "/edge/x2view/0123456789/another_deeper_uri_path" are mapped to one single normalized topic "/abc/sensors" which is equivalent to the database entity "abc.sensors".