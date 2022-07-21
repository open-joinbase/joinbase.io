+++
title = "MQTT Messages"
description = ""
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 600
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "MQTT Protocol is the first-class citizen of JoinBase."
toc = true
top = false
+++

In JoinBase, we provide a MQTT server, can be seen as a common MQTT broker. So IoT devices just send MQTT messages to JoinBase server, then JoinBase will store data reliably for you. Finally, you can do fastest real-time IoT data analysis on top of stored bigdata via an easy SQL compatible language at any moment. All these are done in the one-stop JoinBase. There is no need to use any other systems or tools.

### Working Modes

There are two common working modes or scenarios for JoinBase:

1. Connections from direct MQTT clients on kinds of IoT devices.

**This mode is highly recommended** because we support the top performance in world record level all-in-one product. 

If you want to use existed brokers, you can start two connections in your device to connect: one for your broker and one for the JoinBase.

2. Connections from MQTT brokers on [the bridge mode](/docs/references/bridge/). 

If the above direct connection mode cannot be achieved immediately, you can use this working mode. We provide an excellent dedicated MQTT bridge. For detailed configuration and usage, please refer to [here](/docs/references/bridge/). But please note that the message writing performance will be highly limited by your front-end broker, usually by orders of magnitude lower.

### MQTT Message to Table Mapping

In order for the message to be correctly stored in the appropriate database table, we have made the following conventions:

|    Table             |         MQTT Message             |
| :------------------- | :------------------------ | 
| db_name.table_name   | (3.1.1) topic: /db_name/table_name  <br/>  (5.0) user properties: { "JoinBase.database": "db_name", "JoinBase.table": "table_name"} |
| fields    | Payload. <br/>  JoinBase supports [a payload mapping mechanism](/docs/references/mapping/) for mapping the payload to the database table. |