+++
title = "Payload Mapping"
description = ""
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 580
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "In the JoinBase, we provide several payload mapping mechanisms to make users easily mapping any complex data to the JoinBase's structured table."
toc = true
top = false
+++

## Payload

JoinBase supports two built-in kinds of payload in the body of HTTP/MQTT message: [CSV](https://en.wikipedia.org/wiki/Comma-separated_values) and [JSON](https://en.wikipedia.org/wiki/JSON). Futhermore, via the mechanism of UDM(User Defined Mapping), JoinBase can support the arbitrary user defined mapping logic. 

## Mapping Mechanisms

#### Automatic Mapping

The automatic mapping is very simple and direct: **the top-level JSON field name corresponds directly to the table column name.**

> 🔍
>
> You do **not need to provide any explicit mapping definition**, if you can design one simple 1-1 mapping enabled message payload in advance.


Let's see an example:

1. Connect the test JoinBase server.

```bash
$ psql -U username -d test_db -h 127.0.0.1
```

2. Create a database and a simple table without any explicit mapping attribute.
```sql
> create database test_db;
> create table test_tab(ci8 Int8, cu64 Int64, cts DateTime);
```

3. Write a corresponding data to the JoinBase default MQTT broker by Mosquitto tool [^footnote].

in CSV:
```bash
$ mosquitto_pub -d -t /test_db/test_tab -h 127.0.0.1 -p 1883 -u username -P password -m '-1,123456,2021-09-08T13:42:29+08:00'
```

in JSON:
```bash
$ mosquitto_pub -d -t /test_db/test_tab -h 127.0.0.1 -p 1883 -u username -P password -m '{"ci8":-1,"cu64":123456,"cts":"2021-09-08T13:42:29+08:00"}'
```

4. Check the written data.
```sql
> select * from test_tab;
 ci8 |         cts         | cu64 
-----+---------------------+------
  -1 | 2021-09-08 13:42:29 |  100
(1 row)
```
> 🔍
>
> Batched message ingestion: payload in CSV supports multiple lines as multiple records into the table.

#### Rule Based Mapping

If you message payload design does not follow the default automatic mapping rule, you can explicitly specify your mapping logics via one **mapping rule definition language**.

The rule definition language is simple and [JSON Pointer](https://www.rfc-editor.org/rfc/rfc6901) inspired.

The rule definition language is specified in the table attribute name `JSON_MAPPINGS` when you create the table schema. You can change the `JSON_MAPPINGS` attribute in the latter with `alter` command.

Let see an example `JSON_MAPPINGS` attribute:

```sql
JSON_MAPPINGS ci8 <- '/a/b', cu64 <- '/c/0', cts <- '/d/1/e'
```

the key points of the JSON_MAPPINGS table attribute:

1. The entry `ci8 <- '/a/b'` just defines a mapping from the JSON Pointer path pattern `'/a/b'` to the table column named `ci8`. That is, the value of column `ci8` will be extracted from the JSON message's path `'/a/b'`. 
2. If no mapping defined in this, it is still assumed the table column will be extracted via default mapping. 

> 🔍
> 
> Unlike a file system, the "/" query in JSON Pointer does not identify the root. Instead, "" is the root and "/" is the child of the root whose key is the empty string. Similarly, "/xyz" and "/xyz/" are two different nodes.


##### 1-1 Mapping

If your JSON message has no dynamic array, then 1-1 mapping rule definition is enough.

Let's see an example:


1. Create a test table based the path pattern syntax
```bash
create table test_tab1(
  ci8 Int8, cu64 Int64, cts DateTime
) 
JSON_MAPPINGS ci8 <- '/a/b', cu64 <- '/c/0', cts <- '/d/1/e';
```

2. Write a corresponding JSON data by the JoinBase default MQTT broker.
```bash
$ mosquitto_pub -d -t /test_db/test_tab1 -h 127.0.0.1 -p 1883 -u username -P password -m '{"a":{"b": -1},"c": [100],"d":["", {"e": "2021-09-08T13:42:29"}]}'
```

3. Check the written data.
```sql
> select * from test_tab1;
 ci8 |         cts         | cu64 
-----+---------------------+------
  -1 | 2021-09-08 13:42:29 |  100
(1 row)
```


##### Dynamic Array Flattening

For JSON message with the dynamic array, JoinBase's rule definition language provides a flattening mapping pattern syntax: **one and only one array now can be flatten into multiple table records via wildcard symbol `*`**.

> 🔍
>
> Dynamics will compromise the performance. When you can control the format of message, 1-1 mapping will provide better performance.

Let's see a quick example about how dynamic array flattening help us:

1. A sample JSON message:

```json
{
  "timestamp": 1636666666,
  "dev_id": "id-01",
  "dev_name": "abc",
  "data": [
    [
      1,
      25.1
    ],
    [
      2,
      25.5
    ],
    [
      3,
      25.9
    ]
  ]
}
```

2. Create a test table based the path pattern syntax:

```bash
create table sensors(
  timestamp DateTime, 
  dev_id String, 
  dev_name String,
  sensor_id UInt32,
  value Float32
) 
JSON_MAPPINGS 
    timestamp <- '/timestamp', 
    dev_id <- '/dev_id', 
    dev_name <- '/dev_name',
    sensor_id <- '/data/*/0',
    value <- '/data/*/1';    
```

3. Send the above sample message:

```bash
mosquitto_pub -d -t /abc/sensors -h 127.0.0.1 -p 1883 -u abc -P abc -m '{"timestamp":1636666666,"dev_id":"id-01","dev_name":"abc","data":[[1,25.1],[2,25.5],[3,25.9]]}'
```

4. Check the saved records in JoinBase:

```sql
abc=> select * from sensors;
 dev_id | dev_name | sensor_id |      timestamp      | value 
--------+----------+-----------+---------------------+-------
 id-01  | abc      |         1 | 2021-11-12 05:37:46 |  25.1
 id-01  | abc      |         2 | 2021-11-12 05:37:46 |  25.5
 id-01  | abc      |         3 | 2021-11-12 05:37:46 |  25.9
(3 rows)
```

The biggest difference between 1-1 mapping and dynamic array flattening is that, **one JSON message has been flattened into 3 rows/records in the table**. The data array's inner arrays' first element goes to the sensor_id field separately, and inner arrays' second element goes to the value field separately.


#### User Defined Mapping

Arbitrary user defined mapping logic is supported via JoinBase's .

Via the mechanism of [UDM(User Defined Mapping)](/docs/references/extensions/), JoinBase can support the arbitrary user defined mapping logic. For example, you can use [Protocol Buffers](https://github.com/protocolbuffers/protobuf) or [FlatBuffers](https://google.github.io/flatbuffers/) binary message format in your payload if you like.

-------------
[^footnote]: `mosquitto_pub` is a simple MQTT command line tool, you can get it [here](https://mosquitto.org/download/).
