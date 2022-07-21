+++
title = "Management"
description = "Management and administration of JoinBase"
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 400
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "Currently we provide a series of tools for super easy management and administration of JoinBase."
toc = true
top = false
+++

## Management

After config, you can start the server of JoinBase:

```bash
base start
```

The JoinBase server will listen on multiple ports to accept connections with different protocols.

To gracefully stop the server of JoinBase:

```bash
base stop
```

## Administration

#### <a id="base_admin"></a> base_admin

`base_admin` is a tool to do the UDAC(User and Device Access Control) of JoinBase.

* `create_user`

Use subcommand `create_user` creates a user with specific username and password:
```bash
base_admin create_user abc abc
```

* `list_users`

Use subcommand `list_users` to check the users:
```bash
base_admin list_users
```

* `help`

For all tools in JoinBase, you will get help from subcommand `help`.
```bash
base_admin help
```



