+++
title = "Quick Start for Enterprise"
description = "Quick Start"
date = 2021-05-01T08:20:00+00:00
updated = 2021-05-01T08:20:00+00:00
draft = false
weight = 200
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "Just make your first query in one minute!"
toc = true
top = false
+++

## Get JoinBase Enterprise

All individuals or companies are welcome to request the free JoinBase Enterprise via the [page](/request).

To quickly prepare JoinBase, see more in [Installation](/docs/references/install/) page.

## Config and Start Server
The only item in conf file you should change in the first time is:

* directories of your data, schema and WAL(Write-Ahead Logging).

```
meta_dirs = ["path_to_your_meta_dir"]
data_dirs = ["path_to_your_data_dir"]
wal_dir = "path_to_your_wal_dir"
log_dir = "path_to_your_log_dir"
```

See more about config in [Configuration](/docs/references/conf/) page.

After the config, you can start the JoinBase's server from the root directory of JoinBase by:
```bash
joinbase_start
```

See more about management and administration in [`Management`](/docs/references/mgmt/) page. 

> 🔍
> 
> Use `tail -f` to track your log in the directory of above `log_dir`(path_to_your_log_dir)

## Add Users

JoinBase system follows the philosophy of whitelist. Even you have started a server, you can do nothing if you do not explicit allow.

So, in the next step, you should add some user via our [`base_admin`](/docs/references/mgmt#base_admin) tool. 

The following subcommand `create_user` creates a user with a demo username `abc` and password `abc`:
```bash
base_admin create_user abc abc
```

> 🔍
> 
> It is recommend that you should not provide the input in the password position. If the password is not provided, the command will request you to provide a password in a non-displayed style.

## Connect to JoinBase



After setup an `abc` user, You can use this user to connect to our PostgreSQL wire protocol compatible server.

```bash
psql -h 127.0.0.1 -p 5433 -U abc
```

JoinBase's own language choose to support more intuitive MySQL style management statements rather than PostgreSQL's  `\` starting command, although JoinBase supports PostgreSQL's clients.
```sql
show databases;
use system;
show tables;
```

See more about JoinBase language in [Language](/docs/references/lang/) page.

> 🔍
> 
> append `-d db_name` to psql to make psql connected to that database in default.


> 🔍
> 
> Each login has a log. If the import or write does not generate a log, check whether the port is occupied by other services.
## Create Table

There is nothing interesting unless we have some tables for writing data to or reading data from.

The structure of JoinBase table is directly mapping from the MQTT message. By the mapping, the json payload of one MQTT message will be extracted and saved into the targeted table. See more about mapping of MQTT messages in [MQTT Messages](/docs/references/mqtt/) page.

Let's create a database and a table to store the data. 
```sql
create database abc;
use abc;
```
```sql
CREATE TABLE IF NOT EXISTS t
(
    a Nullable(UInt32),
    b Int64
);
```

Note, the above statement is for demo. You should use a partition schema for a big sized table. 

See more about [`Partition`](/docs/references/concept#partition) and [`create table`](/docs/references/lang#create_table) page.

## Ingest Message

Now, we can do a test query for the new table.

```sql
abc=> select * from abc.t;
SELECT 0
```

Yes. There is no data in the new table `t`. Let's inject a sample data into the table.

You can use all provided interfaces to ingest the data. For example:

1. HTTP interface

```bash
curl -s -H 'X-JoinBase-User: abc' -H 'X-JoinBase-Key: abc'  -X POST 'http://127.0.0.1:8080/abc/t' -d '1,2'
```

The `curl` is one popular HTTP client tool. See more in [HTTP Interface](/docs/references/http/) page.

2. MQTT interface

```bash
mosquitto_pub -d -t /abc/t -h 127.0.0.1 -u abc -P abc -m '{"a":1,"b":2}'
```

The `mosquitto_pub` is a 3rd party MQTT client tool from [Eclipse Mosquitto](https://mosquitto.org/). See more in [MQTT Interface](/docs/references/mqtt/) page.

3. PostgreSQL interface

```sql
INSERT INTO abc.t VALUES (1,2)
```

This statement is issued from the PostgreSQL's official console `psql`. See more in [PostgreSQL Interface](/docs/references/postgresql/) page.

> 🔍
> 
> Use latest tools to avoid potential compatibility problems.

## Make the Query

Let's go back for the first query again:

```sql
abc=> select * from abc.t;
  a  |  b  
-----+-----
   1 |   2
(1 row)
```

Wow!

## Go Further

Congrats for finishing the first query on the JoinBase! Yes, compared with traditional databases or big data platforms, the use of base is super simple!

You may want to understand more about JoinBase. [Concept →](/docs/references/concept/)
