+++
title = "SmartBase: A Free Low-code Platform for AIoT"
description = ""
date = 2022-11-23T12:00:00+00:00
updated = 2022-11-23T12:00:00+00:00
draft = false
template = "blog/page.html"

[taxonomies]
contact = ["joinbase0"]

[extra]
lead = "We are proud to announce to the world that, SmartBase, a free modern AIoT low-code platform, is available for free requesting of everyone."
+++

# Why Yet Another IoT Dashboard

<div class="text-center">
<img src="/imgs/blog/smartbase/dashboard.jpg" alt="dashboard" class="img-fluid">
<p align="center"> Where the dashboard will take us? <p/>
</div>

Because we want IoT users to have more and better choices.

Currently there are existed IoT dashboards, like [ThingsBoard](https://github.com/thingsboard/thingsboard) and [Datacake](https://datacake.co/). Different products are developed by different people with different goals in their minds. Some are open source, but they may be started from the feature oriented engineering and lack enough performance for the real world. Others are source closed, you can pay for the service but there is a cost burden for small business units, and you can not do customization.

ThingsBoard is the builtin but pluggable frontend of JoinBase, which is a free all-in-one data stack built around our unique and innovative database technologies. We are committed to simplifying the IoT data pipeline while delivering the highest production efficiency. By lowering the consumption threshold of IoT data, we believe that JoinBase can benefit every organization and individual in this era.

# Comparison

| Item  | SmartBase w/ JoinBase | ThingsBoard |  Datacake | 
| :----------- | :----------- | :----------- |:----------- |
|Private deployment | <i class="las la-check-circle" style="color:green; font-size: 32px"></i> | <i class="las la-check-circle" style="color:green; font-size: 32px"></i> | <i class="las la-times-circle" style="color:red; font-size: 32px"></i> |
|Cloud service |coming soon| have | only cloud |
|Easy to use | 38 seconds to <br/>setup the JoinBase <br/>and 2 minutes to <br/>create an interactive<br/> dashboard in SmartBase as below | complex<br/> (try it yourself) | ? |
|Free to use | <i class="las la-check-circle" style="color:green; font-size: 32px"></i> | <i class="las la-check-circle" style="color:green; font-size: 32px"></i> | free 2 devices |
|Source available for customization | <i class="las la-check-circle" style="color:green; font-size: 32px"></i> |<i class="las la-check-circle" style="color:green; font-size: 32px"></i> |<i class="las la-times-circle" style="color:red; font-size: 32px"></i> |
|Numbers of connected devices | unlimited (hardware limited)  | ? | 2 devices for free |
|Builtin free MQTT broker for large-scale production |<i class="las la-check-circle" style="color:green; font-size: 32px"></i> | <i class="las la-times-circle" style="color:red; font-size: 32px"></i> | <i class="las la-times-circle" style="color:red; font-size: 32px"></i> |
|Builtin free database with full bigdata analysis| <i class="las la-check-circle" style="color:green; font-size: 32px"></i> |<i class="las la-times-circle" style="color:red; font-size: 32px"></i> |<i class="las la-times-circle" style="color:red; font-size: 32px"></i> |
|Mixed SQL + MQTT style interactive dashboard | <i class="las la-check-circle" style="color:green; font-size: 32px"></i> |<i class="las la-times-circle" style="color:red; font-size: 32px"></i> |<i class="las la-times-circle" style="color:red; font-size: 32px"></i> |

<p align="center">Comparison between SmartBase w/ JoinBase and some other IoT dashboards<p/>

Let's just highlight unique points of SmartBase:

1. Not limited to connect the JoinBase, SmartBase is open to connect to other data sources, like PostgreSQL (and all its wired), MySQL (and all its wired), MQTT endpoints and more. 

Of course, the support to JoinBase with PostgreSQL and MQTT technologies is best and guaranteed.

2. SmartBase is source available under the [USAL(User Source Available License)](/blog/usal).

Become our users and request the sources for your business customization freely!


# Show Case

To demonstrate the great power of the SmartBase, just see a simple show case for SmartBase. 

The data model can be simply described as the following SQL:

```sql
create table myhouse.mysensors
(
    hour UInt8,
    temp1 Float32,
    temp2 Float32
)
```

here, `hour` stands for the hour part of current sensor sampling, `temp1` for room #1 's temperature, `temp2` for room #1 's temperature. This may be naive, but it is simple enough. Just [request free SmartBase](/request) for all tries.

Then inject some random sensor data as like: 

```sql
insert into mysensors values (0,21.3,22.2);
insert into mysensors values (1,21.1,22.1);
insert into mysensors values (2,20.9,22.1);
insert into mysensors values (3,21.0,22.2);
insert into mysensors values (4,21.2,22.2);
insert into mysensors values (5,21.3,22.3);
insert into mysensors values (6,21.6,22.2);
insert into mysensors values (7,21.9,22.2);
insert into mysensors values (8,22.5,22.3);
insert into mysensors values (9,22.9,22.2);
insert into mysensors values (10,23.2,22.2);
insert into mysensors values (11,23.6,22.3);
```

Let's just start to create an interactive dashboard for my smart house!

<div class="text-center">
<a href="https://youtu.be/Sq5SzEeeg88">
<img src="/imgs/blog/smartbase/smartbase_showcase.webp" alt="create a dashboard by SmartBase" class="img-fluid">
</a>
<p align="center">Create an interactive dashboard in two minutes<p/>
</div>

A fully detailed record video is [put on here](https://youtu.be/Sq5SzEeeg88).

Recap for the show case:

1. General build blocks or widgets for common AIoT are available.
2. Overlaying to any image with any widget is easy.
3. Any SQL query on arbitrary history is easy with JoinBase, which is not available to a common MQTT dashboard.
4. After-query data processing logic is easy.
5. After-query widget presentation hooking is easy.
6. Interaction is easy by the event handling of widgets.

In a word, the common AIoT interactive dashboarding has been well supported by the first SmartBase release. We are honored if you would like to give us more suggestions.

# More Links

Get your AIoT one step ahead with free SmartBase and JoinBase by [request here](/request).

Talk with SmartBase and JoinBase developers in [the Discord server](https://discord.gg/sqX6vfnURj).

Watch or submit your ideas [in the community](https://github.com/open-joinbase/joinbase).