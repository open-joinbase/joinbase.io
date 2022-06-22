+++
title = "Payload Mapping"
description = ""
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 710
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "In the joinbase, we provide a payload mapping mechanism to make users easily mapping any complex JSON data to the joinbase's structured table."
toc = true
top = false
+++

## Payload

Currently, joinbase supports two kinds of payload in the body of MQTT message: [CSV](https://en.wikipedia.org/wiki/Comma-separated_values) and [JSON](https://en.wikipedia.org/wiki/JSON).

It is planned to support more payload formats in the future.

## Rules

#### Automatic mapping

**You do not need to provide any explicit mapping definition, if you design the message payload format in advance.** Because we provide an automatic mapping as the following simple rule:

* the top-level JSON field name corresponds directly to the table column name.

> 💡
>
> Theoretically, any JSON message can be automatically mapped with default rule. Because the nested object in top level message can be mapped to as a `String` column if you do not care performance.


Let's see an example about, how the automatic mapping without explicit mapping definition works:

Connect the test joinbase database.

```bash
$ psql -U username -d test_db -h 127.0.0.1
```

Create a database and a table base default mapping rule.
```sql
> create database test_db;
> create table test_tab(ci8 Int8, cu64 Int64, cts DateTime);
```

Write a corresponding data to the joinbase default MQTT broker by Mosquitto tool [^footnote].

in CSV:
```bash
$ mosquitto_pub -d -t /test_db/test_tab -h 127.0.0.1 -p 1883 -u username -P password -m '-1,123456,2021-09-08T13:42:29+08:00'
```

in JSON:
```bash
$ mosquitto_pub -d -t /test_db/test_tab -h 127.0.0.1 -p 1883 -u username -P password -m '{"ci8":-1,"cu64":123456,"cts":"2021-09-08T13:42:29+08:00"}'
```

Check the written data.
```sql
> select * from test_tab;
 ci8 |         cts         | cu64 
-----+---------------------+------
  -1 | 2021-09-08 13:42:29 |  100
(1 row)
```
> 💡
>
> Payload in CSV supports multiple lines.

#### Custom mapping

If you message payload design does not follow the default automatic mapping rule, you can explicitly specify your mapping logics via the custom mapping rule definition.

Custom mapping rule definition is specified in the table attribute name `JSON_MAPPINGS` when you create the table schema. It will be allowed to change in the latter with `alter` command.

Custom mapping is targeted to help on the conversion from semi-structured data formats to the structured table, and finally help users to get the top analytical performance uniquely provided by the joinbase. See the [`denormalization`](/docs/references/performance/) section for more 

1. Any fixed JSON structure can be 1-1 mapped to the structured table.
2. For JSON messages which have the dynamic array structure, an flattening mapping mech to allow flattening array to multiple records.
3. For the other cases, you can use string and related functions.

let see an example `JSON_MAPPINGS` attribute:

```sql
JSON_MAPPINGS ci8 <- '/a/b', cu64 <- '/c/0', cts <- '/d/1/e'
```

* JSON_MAPPINGS is the table attribute name for json to column mapping definition. 
* The entry `ci8 <- '/a/b'` just defines a mapping from the path pattern `'/a/b'` to the table column named `ci8`. That is, the value of column `ci8` will be extracted from the JSON message's path `'/a/b'`. 
* If no mapping defined in this, it is still assumed the table column will be extracted via default mapping 

> 💡
> 
> Unlike a file system, the "/" query does not identify the root. Instead, "" is the root and "/" is the
child of the root whose key is the empty string. Similarly, "/xyz" and "/xyz/" are two different nodes.


##### 1-1 Mapping

Let's see an example about how the 1-1 custom mapping works:


> Create a test table based the path pattern syntax
```bash
create table test_tab1(
  ci8 Int8, cu64 Int64, cts DateTime
) 
JSON_MAPPINGS ci8 <- '/a/b', cu64 <- '/c/0', cts <- '/d/1/e';
```

> Write a corresponding JSON data by the joinbase default MQTT broker.
```bash
$ mosquitto_pub -d -t /test_db/test_tab1 -h 127.0.0.1 -p 1883 -u username -P password -m '{"a":{"b": -1},"c": [100],"d":["", {"e": "2021-09-08T13:42:29"}]}'
```

> Check the written data.
```sql
> select * from test_tab1;
 ci8 |         cts         | cu64 
-----+---------------------+------
  -1 | 2021-09-08 13:42:29 |  100
(1 row)
```


##### Dynamic Array Flattening

Dynamics will compromise the performance. So, if you can guarantee the 1-1 mapping between the JSON structure to the table, you get the best performance.

For JSON with the dynamic array which cannot be optimized right away, joinbase provides a flattening mapping, according to the [`denormalization`](/docs/references/performance/) principle. 

In the path pattern syntax in the `JSON_MAPPINGS`, one array and only one array now can be flatten with other top fields into multiple table rows/records via wildcard symbol `*`.

Let's see a quick example about how dynamic array flattening help us in `denormalization`:

> Assumed sample JSON message:

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

> Create a test table based the path pattern syntax:

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

> Send the above sample message:

```bash
mosquitto_pub -d -t /abc/sensors -h 127.0.0.1 -p 1883 -u abc -P abc -m '{"timestamp":1636666666,"dev_id":"id-01","dev_name":"abc","data":[[1,25.1],[2,25.5],[3,25.9]]}'
```

> Check the saved records in joinbase:

```sql
abc=> select * from sensors;
 dev_id | dev_name | sensor_id |      timestamp      | value 
--------+----------+-----------+---------------------+-------
 id-01  | abc      |         1 | 2021-11-12 05:37:46 |  25.1
 id-01  | abc      |         2 | 2021-11-12 05:37:46 |  25.5
 id-01  | abc      |         3 | 2021-11-12 05:37:46 |  25.9
(3 rows)
```

Here, you can see that, one JSON message has been flattened into 3 rows in the table. The data array's inner arrays' first element goes to the sensor_id field separately, and inner arrays' second element goes to the value field separately.


-------------
[^footnote]: `mosquitto_pub` is a simple MQTT command line tool, you can get it [here](https://mosquitto.org/download/).
