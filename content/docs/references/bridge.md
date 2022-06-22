+++
title = "Dedicated MQTT Bridge"
description = ""
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 700
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "We provide a dedicated MQTT bridge to allow existing broker-based architectures for experiencing the joinbase seamlessly."
toc = true
top = false
+++

For fully access to all innovations and powers of joinbase, it is recommended to use [the client direct connection mode](/docs/references/mqtt/). 

However, If the above direct connection mode cannot be achieved immediately, you can use this working mode. We also provide an dedicated MQTT bridge for existing users, who want to explore the joinbase without making any changes to your existing architectures.

Finally, please note that, the message writing performance in the bridge mode will be highly limited by your front-end broker, usually by orders of magnitude lower.

## Usage

### Config

> Get a helpfull information.

```bash
$ oibb --help
```

> There is a template configuration file base TOML under the `config` directory, 
which can be modified as needed.

```bash
$ vim ./config/bridge.toml
```

### Run

> You can change the log output level by setting `BASE_LOG` environment variable.

```bash
$ BASE_LOG=info oibb --config ./config/bridge.toml
```

### Stop
> `NOTE`
> to make sure it won't lose data, don't kill the process directly, it can receive a `TERM` signal to shutdown normally. 

```bash
$ pkill -TERM oibb
```

