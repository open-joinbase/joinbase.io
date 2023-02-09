+++
title = "MQTT Interface"
description = ""
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 600
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "JoinBase can be used as a high performance MQTT broker."
toc = true
top = false
+++

A built-in MQTT broker capacity is implemented in JoinBase. So,
1. IoT devices just send MQTT messages to JoinBase server, 
2. JoinBase will store data reliably for you, 
3. And then you can subscribe to that topic/table in other devices. 
4. Finally, you can do fastest real-time IoT data analysis on top of stored bigdata via an easy SQL compatible language. 
5. In the same time, you can use the JoinBase a high performance MQTT broker for routing messages to other subscribers as well.

### Working Modes

There are two common working modes or scenarios for JoinBase:

1. Connections from direct MQTT clients on kinds of IoT devices.

**This mode is highly recommended** because we support the top performance in world record level all-in-one product. 

If you want to use existed brokers, you can start two connections in your device to connect: one for your broker and one for the JoinBase.

2. Connections from MQTT brokers on the bridge mode. 

If the above direct connection mode cannot be achieved immediately, you can use this working mode. We provide an excellent dedicated MQTT bridge. We also provide an dedicated MQTT bridge for existing users, who want to explore the JoinBase without making any changes to your existing architectures.

> 🔍 
>
> Please note that the message writing performance will be highly limited by your front-end broker, usually by orders of magnitude lower.

1. MQTT Bridge Config

> Get a helpfull information.

```bash
$ oibb --help
```

> There is a template configuration file base TOML under the `config` directory, 
which can be modified as needed.

```bash
$ vim ./config/bridge.toml
```

2. MQTT Bridge Run

> You can change the log output level by setting `BASE_LOG` environment variable.

```bash
$ BASE_LOG=info oibb --config ./config/bridge.toml
```


### MQTT Message to Table Mapping

In JoinBase, we have made the `Topic` concept in MQTT and the `Table` concept in database exchangeable. In order for the message to be correctly stored in the appropriate database table, we have made the following conventions:

|    Table             |         MQTT Message             |
| :------------------- | :------------------------ | 
| db_name.table_name   | (3.1.1) topic: /db_name/table_name  <br/>  (5.0) user properties: { "JoinBase.database": "db_name", "JoinBase.table": "table_name"} |
| fields    | Payload. <br/>  JoinBase supports [a payload mapping mechanism](/docs/references/mapping/) for mapping the payload to the database table. |