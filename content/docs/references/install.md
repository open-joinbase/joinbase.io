+++
title = "Installation"
description = ""
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 100
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "Basic configuration for JoinBase."
toc = true
top = false
+++

## Install

### Plain file

JoinBase does not need to be installed. The JoinBase release is shipped in a compressed package. Just decompress it to any directory of your machine. Then, go that directory to use. 

### Docker image

If you prefer the Docker way, try JoinBase with the above simplest command:

```bash
docker run --net=host -P -d joinbase/joinbase
```

This command will start a JoinBase server wiht the default conf in a detached container by exposing all ports to your host.

But **NOTE** that JoinBase has no `default user` concept, you should setup a user before going ahead by the following command:

```bash
docker run --net=host --entrypoint /joinbase/base_admin -it joinbase/joinbase create_user abc
```

Just check the server by pinging with curl, like:
```bash
curl -v -s -H 'X-JoinBase-User: abc' -H 'X-JoinBase-Key: abc' -X GET 'http://127.0.0.1:8080/ping'
```

Finally, note that all data and change are inside of the container for above quick commands. They may disappear when that container ternimated. For production use, you should customize JoinBase's conf to use dedicated directories. A sample conf file named "base.conf" is provided with every release. Just dowload and customize it yourself.

## Prerequisites

* Operation system

Currently, JoinBase only supports Linux distributions with modern kernels, example, [latest Ubuntu 20.04.4+ LTS](https://releases.ubuntu.com/20.04/). Feel free to ask for help if you have problems on the running operation system. We are good at running latest kernels on several-dollar SBCs. ([Windows WSL2 with latest kernel](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) also works greatly.)

* Storage

For storage, there is no hard requirement. But if you want to achieve the leading performance, the SSD disk is recommended.

* Processor

Mainstream 64bit CPU architectures are supported(X86-64, ARM, RISC-V), and scaled from $6 ARMv8 SBC to AWS 384-core(z-series) instance.

Currently, the x86-64v3 (AVX2+) version is available for public downloading. More other arch version downloads will come soon. We are also happy to provide kinds of optimized versions for any interesting processors and hardwares when users [request](/request).