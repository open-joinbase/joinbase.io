+++
title = "JoinBase's 2023: Revolutionizing AIoT Data Services for the World"
description = ""
date = 2023-02-08T12:00:00+00:00
updated = 2023-02-06T12:00:00+00:00
draft = false
template = "blog/page.html"

[taxonomies]
contact = ["joinbase0"]

[extra]
lead = "From now on, JoinBase, an innovative single-binary AIoT-first data-service platform, is available for download."
+++

### Tech Review 2022

We are proud of all the innovations we have made for this era in 2022: We are significantly ahead of our competitors in the performance of implemented SQL primitives, particularly in only 4MB binary size. In 2023, we are adding new and more exciting AI infra into JoinBase. This makes the final binary size increased by 80% to 8MB.

##### Most lightweight and fastest data platform for AIoT

Recently, we have re-run our [benchmark](/benchmark) against the latest ClickHouse's stable version 22.9.7.34 (which is the last stable version in 2022). The primitive benchmark results have not changed (but some details should be added or tweaked). This is a true story that 8MB binary beats 410MB ClickHouse binary in large-scale time-series. It's a triumph of modern performance engineering.

Let's recap JoinBase's power:

| Comparison   | JoinBase 2023.1 | ClickHouse 22.9.7.34 |  References |
| :----------- | :----------- | :----------- |:----------- |
| main binary size | ～8MB  | ～410 MB  | [Products Download](/products) |
| basic SQL analytics | average 3.5x - 3.75x faster | 1x baseline  | [Benchmark](/benchmark) |
| IoT protocol interface | <i class="las la-check-circle" style="color:green; font-size: 32px"></i> | <i class="las la-times-circle" style="color:red; font-size: 32px"></i> | [Blog: Multi-protocol Interfaces](/blog/http-interface/) <br/> [Doc: MQTT Interface](/docs/references/mqtt/) |
| IoT gateway |<i class="las la-check-circle" style="color:green; font-size: 32px"></i> | <i class="las la-times-circle" style="color:red; font-size: 32px"></i> | [JoinBase As MQTT Broker](/blog/joinbase-as-mqtt-broker/) <br/> [Doc: MQTT Interface](/docs/references/mqtt/) |
| HTTP interface concurrent <br/>read throughput | ~100x higher (402k/s) | 1x baseline (4.3k/s) | [Blog: Multi-protocol Interfaces](/blog/http-interface/) |
| PG interface concurrent <br/>read throughput | ~130x higher (34k/s) | 1x baseline (245) | [Benchmark](/benchmark) |
| sustained one-by-one MQTT message <br/>write throughput | 7 million msg/s | <i class="las la-times-circle" style="color:red; font-size: 32px"></i> | [Benchmark](/benchmark) |
| sustained batch MQTT message <br/>write throughput | 25 million msg/s <br/> (NVME write bandwidth saturated!) |  <i class="las la-times-circle" style="color:red; font-size: 32px"></i> | [Benchmark](/benchmark) |
| sustained one-by-one and batch HTTP message <br/>write throughput | on par with MQTT interface | low | internally tested, to be demonstrated |
| dedicated support to low-code | <i class="las la-check-circle" style="color:green; font-size: 32px"></i> | <i class="las la-times-circle" style="color:red; font-size: 32px"></i> | [Blog: SmartBase](/blog/smartbase/) |
| end-to-end platform | <i class="las la-check-circle" style="color:green; font-size: 32px"></i> | <i class="las la-times-circle" style="color:red; font-size: 32px"></i> | [Blog: SmartBase](/blog/smartbase/) |

<p align="center">Why you should use JoinBase<p/>

Of course, as a general analytical data warehouse, ClickHouse provides many functions that JoinBase does not have.  However, for AIoT, most of these functions are not must-have. JoinBase provides AIoT and time-series domain with new simple but efficient real-time paradigms through innovative designs, like auto views. (Watch [issue#8](https://github.com/open-joinbase/JoinBase/issues/8)).

### Achievement 2022

In addition to above technological progresses, we have also made great achievements in products and users. 

Since the global launch of JoinBase in October 2022, we have received overwhelming requests from totally 33 users applied our free distribution [on the website](/request). We're thrilled to see that some of these users are from big giants and give us much positive feedbacks. Some of them told me that they are using JoinBase in the daily development and even in production!

Because of these achievements, we decided to open the download from now on, to make the interaction flywheel between the product and the community faster. 

### Roadmap 2023

We have already laid out our roadmap for the year (Watch [issue#9](https://github.com/open-joinbase/JoinBase/issues/9)):

##### More supports to the community

JoinBase 2023 has added more supports to the community, making it easier for users to find the information and help they need. The platform has a strong community of AIoT engineers, database developers, and high-performance experts who are always on hand to assist users with their needs.

Like [issue#11](https://github.com/open-joinbase/JoinBase/issues/11).

##### More diverse analytics infrastructure

JoinBase plans to add even more analysis functions in 2023 to enhance its offerings to customers. These new functions will make it easier to extract insights from your AIoT data and make real-time decisions. For example, sampling support.

Like [issue#16](https://github.com/open-joinbase/JoinBase/issues/16).

##### Fewer concepts to use it

JoinBase has re-designed the workflow with simplicity in its core, requiring fewer concepts for users to fully utilize its capabilities. This makes it easy for users of all levels to access and use the platform's data services, without the need for extensive training or technical know-how. 

Nowadays, in order to maximize performance, you need to understand the concept of partitioning. For most distributed databases, even single-node databases, you need to learn this concept if you want to achieve good performance. But as a new data platform, we think this can actually be improved. We plan to hide this concept for users recent 2023, and still provide top performance. This is just the issue about auto-partitioning.

Like [issue#7](https://github.com/open-joinbase/JoinBase/issues/7). 

##### Brand new AI infrastructure

Recently, the popularity of ChatGPT has shown the impact of AI-based evolution on the world. JoinBase also wants to showcase our thoughts and works about AI. That is the <b>"A"</b> of AIoT stands for! More information is expected to be available in Q1 and Q2 of 2023.

Like [issue#6](https://github.com/open-joinbase/JoinBase/issues/6).


### Wish to Open-source

At JoinBase, we come from one open-source database/data-warehouse community where we have done amazing works. However, balancing business and open-source is a tough nut to crack, as the resources needed to maintain an open-source project in today's world are substantial, and competition between communities is no longer based on technical innovation but on community engineering. As a start-up and believers in technical innovation, we can't take it. 

However, our dedication to the technical progress of the world remains unchanged. In the time of download opening, I make a wish here: gradually open source the core of JoinBase within 2 years, if the company goes well. It is our sincere wish that the JoinBase community grows and flourishes along with us, and together, we can make this dream a reality.

Start to [download](/products) and experience the power of JoinBase, right now!

