+++
title = "Quick Review for Free Database Cloud Services on Real World IoT Dataset"
description = ""
date = 2022-06-27T12:00:00+00:00
updated = 2022-06-27T12:00:00+00:00
draft = false
template = "blog/page.html"

[taxonomies]
contact = ["joinbase0"]

[extra]
lead = "Databases companies are gradually starting to offer cloud services, or cloud demos. On a whim, we carry out a quick experiment to do a quick qualitative performance review on possible database cloud services or demos."
+++

## Prerequisites

Here are a few prerequisites for this quick review:

1. The cloud service or demo should be **free**. Common users have no budget to provide a credit card to complete any review. On the other hand, only databases with excellent performance can afford permanently free tiers in cloud services or demos.
2. The database must support the **SQL compatible** syntax. The cost of learning a new paradigm for the common user is very high. Every paradigm has pitfall, but adhoc paradigm goes into no help when a pitfall happens.
3. **Easy enough**. We are database experts. Hence, we propose a `15-minute rule`: we stop reviewing at one database cloud service/demo If the exploration process exceeds 15 minutes after registering.

## Experiment

In this experiment, we try the follow six databases:

| Database     | Service or Demo |  Pricing      |  Dataset Size   | Register Site or Docs |
| :----------- | :-------------- |  :----------- |  :------------- | :------------- |
| JoinBase |   full service with write + read  |    free tier forever   |    nyct big + nyct lite    | [register](https://cloud.joinbase.io/signup) |
| Timescale |   full service with write + read  |    free 30-day trial   |    nyct lite    | [register](https://www.timescale.com/timescale-signup) |
| ClickHouse |  demo with read only  |    n/a       |    nyct big     | [docs](https://clickhouse.com/docs/en/getting-started/playground/) |
| ?DB |  demo with read only  |    n/a       |    nyct big     | n/a |
| InfluxDB |  demo with read only  |    n/a       |    n/a     | [register](https://cloud2.influxdata.com/signup) |
| CockroachDB |  full service in serverless  |    free tier forever |    n/a | [register](https://www.cockroachlabs.com/lp/serverless/) |


<p align="center"> Tab.1 Tried Database Cloud Services or Demos <p/>

Some notes on Tab.1:

1. Only four cloud services or demos are reviewed in the end: JoinBase, Timescale, ClickHouse, and ?DB.
2. Only one result of ?DB is shown below. ?DB claims that it is "the fastest open source time series database" but the tests on its own demo server show the opposite. In fact, almost all slightly non-trivial SQL queries for its 1.6-billion-row trips time out. To avoid disputes, we do not display the name of this database. Here, the suggestion for all users is, "Talk is cheap. Benchmark yourself."
3. Both InfluxDB Cloud and CockroachDB Cloud Serverless are tried. But we don't succeed in finding a way to review them within the above planned time. For InfluxDB, it has its own adhoc schema way. We have not enough time (and interest) to learn. For CockroachDB, there is no simple way to ingest a csv in my local fs to remote serverless db server.
4. More about kinds of nyct dataset could be seen [in this article](https://joinbase.io/benchmark/#benchmark-model).

| Database Services | Setup |  
| :----------- | :-------------- |  
| JoinBase Cloud Preview |  32 ~ 96 vCPUs (not guaranteed)  | 
| Timescale Cloud        |  32 vCPUs, 128GB RAM             |
| ClickHouse Playground  |  96 vCPUs (guessed)              |  

<p align="center"> Tab.2 Setup of Reviewed Databases<p/>

Some notes on Tab.2:
1. The setup of ClickHouse's playground server is not public, and so does JoinBase. Our JoinBase cloud service is powered by the multi-tenant version of JoinBase, which is also set up on a single instance now. We will adjust vCPUs  according to the number of active users. 
2. Timescale cloud's biggest instance for free trial is 32 vCPUs, 128GB RAM.
3. Again, this quick review just does a quantitative analysis.

According to our 15-minute rule, only three database services or demos are reviewed.

<!-- ![Review for Three Database Cloud Services or Demos](/imgs/blog/clouds_quick_review/review.gif) -->
<img src="/imgs/blog/clouds_quick_review/review.gif" alt="review of three cloud services" class="img-fluid">
<br/>
<p align="center"> Fig.1 Reviewing Three Database Cloud Services or Demos<p/>

<img src="/imgs/blog/clouds_quick_review/xdb.png" alt="review of three cloud services" class="img-fluid">

<p align="center"> Fig.2 ?DB shows ridiculous run times for trivial conditions<p/>


## Results

We divide the comparisons into two groups. Because ClickHouse Playground is read only, and 1-billion-row nyct_strip dataset is too big to import into Timescale Cloud for its slow writing performance. We can not use a single dataset for all services or demos. But smart readers can reason their own conclusions if the database query performance can be scaled with the size of the data.  

1. JoinBase Cloud Preview vs Timescale Cloud on nyct_lite dataset (the elapsed time is in the unit of milliseconds)

| Database Service | Q1 | Q2 | Dataset Size (rows) | 
| :----------- | :-------------- | :-------------- | :-------------- | 
| JoinBase Cloud Preview | 0.78 |  4.45   | 10M  |
| Timescale Cloud | 650.739  | 840.430 | 10M  |
| Timescale:JoinBase Ratio | 834      |   189   | 1:1  | 

<p align="center"> Tab.3 JoinBase Cloud Preview vs Timescale Cloud<p/>

2. JoinBase Cloud Preview vs ClickHouse Playground on nyct_strip dataset (the elapsed time is in the unit of second)

| Database Service | Q1 |  Q2 | Q3 | Q4 | Dataset Size (rows) |  | 
| :----------- | :-------------- | :-------------- | :-------------- | :-------------- |:-------------- |:-------------- |
| JoinBase Cloud Preview    | 0.168  | 0.259 | 0.355 |  1.126  | 1 billion    | 
| ClickHouse Playground | 1.664  | 1.659 | 1.714  | 2.431  | 3.46 billion | 
| ClickHouse:JoinBase Ratio | 9.9    | 6.4   | 4.8    | 2.16   |   3.46 |

<p align="center"> Tab.4 JoinBase Cloud Preview vs ClickHouse Playground<p/>

Obviously, JoinBase surpasses other services in the performance of the tested queries. 

Here, the Q4 query for JoinBase and ClickHouse, in fact, is not "apple-to-apple". JoinBase uses String type for vendor_id, cab_type and passenger_count three columns but ClickHouse uses Enum8, which has the obvious optimization to speedup. JoinBase, indeed, has Enum like type. But here, we would like to emphasize our generality and the unique superiority of the engine algorithm. JoinBase is implemented so fast that you can use it without caring performance downgrade.

More queries and notes are seen in [here](https://github.com/open-joinbase/review_free_cloud_services).

## Conclusion

Let's do a quick rating: from 0 to 5, 5 is the best, and 0 is the worst:

| Database Service | Ease of Use |  Completeness of <br/>Service   | Analytical Query Performance  |  Built-in IoT Domain Capability | 
| :----------- | :-------------- | :-------------- | :-------------- | :-------------- |
| JoinBase Cloud Preview    | 5  | Full |   5  | 5  |
| Timescale Cloud           | 3  | Full |   1  | 1  |
| ClickHouse Playground     | 4  | Demo |   5  | 1  |
| ?DB Demo          | 5  | Demo |   0  | 1  |
| InfluxDB Cloud    | 1  | Full |  n/a | 1  |
| CockroachDB Cloud | 1  | Full |  n/a | 1  |

<p align="center"> Tab.5 Final Ratings for Reviewed Database Services<p/>

1. For Timescale cloud, in fact, the first user experience is a little tricky: the service password was wanted in notes, but we found nothing till the service created (or we miss something?). Finally, we found a workaround that the password could be changed in the service settings.
2. For `Ease of Use`, JoinBase is the cloud service shipped with SQL workbench. You can experience JoinBase immediately after registering without any installation. Timescale cloud and ClickHouse demo are headless so that you need install consoles for going on.
3. Built-in IoT domain capability is the unique features of JoinBase now. So nothing is done in this review. Feel free to [explore these features](/docs/getting-started/introduction/) in our free JoinBase Cloud Preview.

This experiments is great: it is much much easier to review a cloud service or demo than a formal benchmark with many codes and setups. 

Finally, all reviews or benchmarks are biased. It is suggested that users should reproduce yourself. Welcome to [register our free JoinBase Cloud Preview](https://cloud.joinbase.io/signup) for reproducing!


