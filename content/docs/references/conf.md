+++
title = "Configuration"
description = ""
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 300
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "Basic configuration for JoinBase."
toc = true
top = false
+++

In JoinBase, we hope to that was extremely complex and difficult to control in the traditional database system or big data platform.

### Philosophy of JoinBase's Config

Config should be done in:

1. all-in-one place
2. show main configurable items that the system exposes to users 
3. self-explained
4. reasonable default value

You can use the above standards to configure JoinBase in the $JoinBase_HOME/base.conf ([toml](https://toml.io/en/) format file).

### Noteworthy

The only item in conf file you should change in the first time is:

* directories of your data, schema, log and WAL(Write-Ahead Logging).

Because JoinBase is a database system. It will definitely save users' data into some places of users' disks. Therefore, we believe, it is best to let users explicitly specify and reserve a suitable space for the database, from both the privacy and system work's perspectives.