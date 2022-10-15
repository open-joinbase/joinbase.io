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
lead = "Make the first query in JoinBase Enterprise in three minutes!"
toc = true
top = false
+++

## Get JoinBase Enterprise

Now JoinBase Enterprise is in the beta test. All interested users are welcome to request the trial for free. We also provide **Open Partner Plan** for early partners.

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

> 💡
> 
> Use `tail -f` to track your log in the directory of above `log_dir`(path_to_your_log_dir)

## Add Users

JoinBase system follows the philosophy of whitelist. Even you have started a server, you can do nothing if you do not explicit allow.

So, in the next step, you should add some user via our [`base_admin`](/docs/references/mgmt#base_admin) tool. 

The following subcommand `create_user` creates a user with a demo username `abc` and password `abc`:
```bash
base_admin create_user abc abc
```

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

> 💡
> 
> append `-d db_name` to psql to make psql connected to that database in default.

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

## Ingest MQTT message

Now, we can do a test query for the new table.

```sql
abc=> select * from abc.t;
SELECT 0
```

Yes. There is no data in the new table `t`. Let's inject a sample data into the table.

We just use a 3rd party tool `mosquitto_pub` from [Eclipse Mosquitto](https://mosquitto.org/) to send a message into JoinBase as an example.

```bash
mosquitto_pub -d -t /abc/t -h 127.0.0.1 -u abc -P abc -m '{"a":1,"b":2}'
```
Here, the default message protocol of `mosquitto_pub` is MQTT v3.1.1. For MQTT v3.1.1 messages, we map the topic to database.table. However, for v5 messages, we change to use the customized user properties. 

See more in [MQTT Messages](/docs/references/mqtt/) page.

> 💡
> 
> Use latest tool binaries to avoid protocol compatibility problems.

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
