+++
title = "JoinBase Tips Series #1: Quick Start JoinBase"
description = ""
date = 2023-02-22T12:00:00+00:00
updated = 2023-03-02T12:00:00+00:00
draft = false
template = "blog/page.html"

[taxonomies]
contact = ["jblchen"]

[extra]
lead = "Let's take a minute to get started quickly and complete your first query in JoinBase!"
+++

# Get JoinBase
### Operating system 
Currently, JoinBase supports Linux distributions with modern kernels, such as the [latest Ubuntu 20.04.4+ LTS](https://releases-ubuntu-com.translate.goog/20.04/?_x_tr_sl=auto&_x_tr_tl=zh-CN&_x_tr_hl=zh-CN) . ( [Windows WSL2 with latest kernel](https://en-m-wikipedia-org.translate.goog/wiki/Windows_Subsystem_for_Linux?_x_tr_sl=auto&_x_tr_tl=zh-CN&_x_tr_hl=zh-CN) also works fine.)

### Processor
Supports mainstream 64-bit CPU architectures (X86-64, ARM, RISC-V) and supports everything from $6 ARMv8 SBCs to AWS 384 cores (z-series).

Currently, the x86-64v3 (AVX2+) version is available for public download. More downloads for other arch versions are coming soon.

### Download

Compared with the cumbersome installation process of other databases, the installation of JoinBase is very fast. Click [here](https://joinbase.io/products/) to download the free JoinBase.

### Install

Compared with the cumbersome installation process of other databases, JoinBase does not need to be installed: JoinBase is provided in the form of a compressed package, just unzip it to any directory on your machine, and run it in this directory.

### Install Client Console

You should choose one client to manage JoinBase. We suggest using the most popular PostgreSQL protocol for starting. In Ubuntu, you can try the following commands to get PostgreSQL client:

```bash
sudo apt-get update
sudo apt-get install postgresql-client
```

JoinBase supports any PostgreSQL-compatible client and driver. For more information and use cases, please refer to: [PostgreSQL Interface](/docs/references/postgresql)

# Configure and start the server

Before proceeding, you should change the following items in the conf file:

```
meta_dirs = ["path_to_your_meta_dir"] 
data_dirs = ["path_to_your_data_dir"] 
wal_dir = "path_to_your_wal_dir" 
log_dir = "path_to_your_log_dir"
```

>NOTE: If you do not change the path, the file will be saved to the default path.

After completing the above configuration, you can start the JoinBase server from the root directory of JoinBase in the following way:

```
bash joinbase_start
```

When you see the following content, JoinBase has started successfully!

<div class="text-center">
<img src="/imgs/blog/tips_1/start.png" alt="start" class="img-fluid">
<p align="center">JoinBase started successfully<p/>
</div>

# Add user

The JoinBase system follows the concept of a whitelist. Even if you have started the server, if you do not create an account, you can not use it.

So, in the next step you should add some users via our base_admin tool.

Create a user with username abc and password 123 using the following subcommand create_user:

```
base_admin create_user abc 123       
```

It is recommended that you do not provide input in place of passwords. If no password is provided, the command will ask you to supply it without displaying it.

# Connect to JoinBase

After setting up the abc user, you can log in as that user to connect to our PostgreSQL wire protocol compliant server.

```
psql -h 127.0.0.1 -p 5433 -U abc  
```

JoinBase's own language choice supports more intuitive MySQL-style management statements rather than PostgreSQL's \startup commands, although JoinBase also supports the PostgreSQL client.

# Create table

This process is meaningless unless we have some tables to write data to or read data from.

The structure of the JoinBase table is directly mapped from the MQTT message. Through the mapping, the json payload of an MQTT message will be extracted and saved into the target table. See more information about MQTT message mapping in the MQTT messages page. 

Let's create a database and a table to store data.

```sql
create database abc;
use abc;
```

```sql
CREATE TABLE IF NOT EXISTS t(a Nullable(UInt32),b Int64);
```
# Test query
We can now make test queries against the new table.

```sql
select * from abc.t;
SELECT 0
```

Yes, there is no data queried in the new table t. Let's inject sample data into the table.

You can use all provided interfaces to ingest data, such as HTTP interface, MQTT interface, and PostgreSQL interface.

This time we demonstrate the PostgreSQL interface. Regarding the use of other interfaces, you are welcome to pay attention to our follow-up articles, and we will introduce them in detail.

```sql
INSERT INTO abc.t VALUES (1,2);
```

In this way, the data is successfully inserted into the newly created table.


# Carry out testing

Returns the query that just got no results.

Now, let's try again.

```sql
select * from abc.t;
```

very good! When you see the following results, it means you have successfully completed the query.

<div class="text-center">
<img src="/imgs/blog/tips_1/query.png" alt="query" class="img-fluid">
<p align="center">result<p/>
</div>

# Go further
A thousand miles begins with a single step. Congratulations on completing your first query on JoinBase!

Yes, compared to traditional databases or big data platforms, JoinBase is super easy to use!

JoinBase provides a lot of value beyond the peers of this era. We sincerely invite more users to join our community. JoinBase can help you!

Download JoinBase: [Download](https://joinbase.io/products/) the full-featured version of JoinBase and SmartBase for free now , so that your AIoT digital capabilities will be one step ahead.

JoinBase Global Community: [Github Global Community](https://github.com/open-joinbase/joinbase)

JoinBase Chinese Community: [WeChat Group](https://joinbase.io/community/)

JoinBase Discord Server: [Discord](https://discord.com/invite/sqX6vfnURj)

At the same time, welcome to leave a message in the comment area. If you have any questions, we will answer them for you.