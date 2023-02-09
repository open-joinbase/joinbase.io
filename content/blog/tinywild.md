+++
title = "TinyWild: JoinBase Makes Wild IoT in Your Hand"
description = ""
date = 2022-10-16T12:00:00+00:00
updated = 2022-10-16T12:00:00+00:00
draft = false
template = "blog/page.html"

[taxonomies]
contact = ["joinbase0"]

[extra]
lead = "JoinBase empowers an edge IoT data stack for wildlife protection in 1/4-palm size."
+++

# Problems and Challenges in The Wild

<img src="/imgs/blog/tinywild/wildlife.jpg" alt="wildlife" class="img-fluid">
<p align="center">The wild without a reliable internet connection<p/>

Many wild ecosystems do not have good network connections, and it is difficult for data analysis systems that rely on the cloud to work well in such wildlife-rich scenarios. Furthermore, such cloud-based systems are usually so expensive that wildlife researchers or institutions cannot afford.

# IoT Devices

### Edge Dev Kit

In the data stack, a SenseCap K1100 kit is used. We use two modules from this kit:

1. Wio terminal: it can be seen as a handheld data hub with a visualization interface, which can manage various sensor modules and even display simple sensor data charts.

2. Grove AI module: it provides TinyML-based wildlife recognition in the TinyWild.

### Grove Vision AI for Animals Detection

This is a very great but challenging task. On-the-edge AI has a profound impact on the intelligence in the wild, because there is no good network in the wild to connect to cloud services with unlimited computing power.

At present, there is not much public research on the edge AI for wildlife or animals. Let us do a deep customization for this tasks:

<img src="/imgs/blog/tinywild/animal_80_dataset.jpg" alt="wildlife" class="img-fluid">
<p align="center">Animal-80 dataset<p/>

One of the few publicly available animal datasets - Animals Detection Images Dataset from Kaggle (called "animials-80" dataset ) has been used. It contains 80 animals in 9.6GB images, and should be great enough for common animal recogization task.

1. Prepare images and lables for Yolov5 training

    Thanks to the Kaggle's working, we do not need to do labeling ourself. But the original label format in the animals-80 is not Yolov5 format. A preparation work has been carried by me on it. The core part is the preprocessing function shown above. Please the later Code section for more. 

2. Training

    Unfortunately, I don't have enough resources to do a full training on full 9.6GB training. So, a picked subset of animal-80 dataset has been chosen. We use a 24-core Xeon SP to do the training using above the commands got from offical example.

    1. 15-animal-kinds training

    <img src="/imgs/blog/tinywild/results_15.jpg" alt="wildlife" class="img-fluid">
    <p align="center">Training result for 15-animal-kinds<p/>

    Firstly, we try train a model with 15 animal kinds. However, after two hours (Yes, it proves again that Don't use CPU to train even it is a top Xeon SP), the final recognition effect is found to be very poor. You can see the main metrics are very low: the precision is 0.6, the recall and mAP_0.5 are just around 0.3. In fact, this result is close to not working.

    2. 4-animal-kinds training

    <img src="/imgs/blog/tinywild/results_4.jpg" alt="wildlife" class="img-fluid">
    <p align="center">Training result for 4-animal-kinds<p/>

    Let's reduce the types of recognized animals to four: spider, duck, magpie and butterfly, which of course are the most common animals in a suburban wild area.

    Ok, the recall and mAP_0.5 are upward to around 0.6. Not too bad. We will see the result in the late TinyWild's Wildlife Survey.


# JoinBase as No-coding On-the-Edge IoT Data Stack

The core of TinyWild is, an free on-the-edge IoT data stack - JoinBase.

Nowadays, it is impossible to run MQTT broker + database + no-coding visualization at one resource constrained edge. JoinBase just comes as a game changer.

Unlike existed IoT for wild solutions, with the help of JoinBase's edge-cloud-in-one architecture, the TinyWild gives out a wildlife diversity real-time monitoring and analysis system reference implementation in low cost, high availability and great scalability, from UI to data analysis on the edge.

All done in the wild. No network connection to cloud any more needed for data analysis, even if you are in the African savannah to observe the rhinoceros. Our TinyWild system is especially suitable for real-world wildlife research.

# Pack All Being the TinyWild

<img src="/imgs/blog/tinywild/tinywild.jpg" alt="tinywild" class="img-fluid">
<p align="center">TinyWild in 1/4-palm Size<p/>

### Server Side Coding
The JoinBase data stack used by TinyWild is a all-in-one

We just write a SQL schema to create a table in the JoinBase like you do it in the your traditional database:

```sql
create table iot_into_the_wild.sensors (
  ts DateTime,
  light Int16,
  sound Int16,
  imu_x Int16,
  imu_y Int16,
  imu_z Int16,
  animal String,
  confidence Int8
)
PARTITION BY yyyymmdd(ts);
```

Then, it is enough to start to service device messagings, no more codes. More usages about JoinBase could be seen in its own website.

### Client Side Coding
In the client side, we change SenseCap's official no-coding tooling SenseCraft to make Wio termial to work with an edge data stack.

Three main contributions are done in the TinyWild development, compared to the official version of SenseCraft:

1. Dynamic sensor-join-in/out for a wide database table has been supported.

2. MQTT and Sampler thread event loop has been enhanced.

3. Properly calibrated realtime clock has been supported via RTC and rpcWiFi libray.

More details could be seen in the related repo in reference.

After main coding done, TinyWild is ready for using. Finally, let recap the size of TinyWild parts:

|Devices | Size |
|:--- |:---|
| Wio Terminal | 72mm * 57mm * 12mm |
| SBC - Rock Pi S | 42mm * 42mm |
| Solar Charger | 30.5cm * 18cm |


The total size of TinyWild is 305mm x 180mm by the largest part - solar charger, of which the size is just to that of a book.

That is why it named: Tiny. Let's go to Wild!


# Wildlife Survey in the Wetland Park

For evaluating the TinyWild, I go to the country park to complete a wildlife survey.

### Location

We start from the wetland lake in the center of park but keep on running till we're back where we started in the entrance of the park.

### Continuous Monitoring

The continuous monitoring is done by running plain SQL queries. JoinBase provides a trial free cross-platform frontend for all users to allow periodically running queries and show then as dynamic tables or charts.

The monitoring queries running in TinyWild are as following:

```sql
select count(ts) as number_of_records from iot_into_the_wild.sensors;
select animal,count(animal) as number_of_animal from iot_into_the_wild.sensors group by animal;
select count(animal) as number_of_highly_true_ducks from iot_into_the_wild.sensors where animal = 'Duck' and confidence > 70;
select count(light) as number_of_great_sunlight from iot_into_the_wild.sensors where light > 900;
select count(light) as number_of_near_lightless from iot_into_the_wild.sensors where light < 50;
```

### Static observation on Duck

<img src="/imgs/blog/tinywild/duck_2.jpg" alt="wild joinbase sql" class="img-fluid">
<p align="center">Static observation on duck in the lakeside<p/>

There are wild ducks (mallards) in the lake. To test the static recognition performance of Grove AI module, the camera is been pinned to lakeside for around half an hour via a tripod. See more results below.


# Data Analysis to the Wildlife Survey

<img src="/imgs/blog/tinywild/tinywild_2.jpg" alt="wild joinbase sql" class="img-fluid">
<p align="center">JoinBase powered TinyWild goes into the wild<p/>

It is time to evaluate the performance of Grove AI and whole TinyWild system

### Grove AI for Wildlife Recognition

In the basic conclusion of this wildlife survey, for individual identification, it is not particularly ideal. But, for survey, the qualitative information collected is effective.

let's observe the whole survey group-by (in the third picture above) query:

<img src="/imgs/blog/tinywild/wild_sql.jpg" alt="wild joinbase sql" class="img-fluid">
<p align="center">Group-by SQL query result of the whole-survey monitoring sensoring values<p/>

1. Most of animals are "Unkown"

    Because it is found hat the outputs of Grove AI have a great possiblity with the confidence 100 (100% for short) even for its own built-in (people detection) model. This is impossible. So we treat all confidence >= 100 detection as "Unkown".

2. Empty "animal" in the results

    This stems from the logics of database storage model and that of SenseCap's no-coding SenseCraft in that our TinyWild's Wio terminal codes are modified from it: the data logic will send data in a timer interval then clear the input buffer, if the buffer can not filled by sensors then for single point, you can easily ignore it but for a row of points like show in the TinyWild database table, we still need to something here.

So, change to see the records with high confidence, here > 75 in the query:

<img src="/imgs/blog/tinywild/high_confidence_wild_sql.jpg" alt="wild joinbase sql" class="img-fluid">
<p align="center">Group-by SQL query result of high confidence classification<p/>

<img src="/imgs/blog/tinywild/high_confidence_rec_res.jpg" alt="wild joinbase sql" class="img-fluid">
<p align="center">Charting of high confidence classification<p/>

Butterflies are relatively outstanding but without Magpies that have seen many times in the park.
This seems the Magpies are been recognized as the butterflies. But what they have in common is that, they often fly in the air.

Duck are observed in the lake side. In the records, we exactly found that the Grove AI works greatly for nearby animal detection like we done in lakeside: we got four counts when suddenly three ducks swims into the scope of camera in a relative static positioning.

### Continuous Collection

For the great portable and mobility of the TinyWild, let's look at another case: continuous light sensoring in the edge:

<img src="/imgs/blog/tinywild/light_changes_in_last_minutes.jpg" alt="wild joinbase sql" class="img-fluid">
<p align="center">Charting of continuous light sensoring in the whole <p/>

When I went back ( @ 17:09 ) after survey at the lakeside done, I go through a big tree road ( after 16-17mins according to the recoding ). The above figure is the plot of light sensor values at the last 22 mins of the return journey.

The TinyWild completely and accurately recorded of the entire changes of light sensors while the entire cameraman is moving all the time, many times the network is poor.

# Cost Analysis

TinyWild is tiny and wild(no cloud needed). It is also cheap:

|Devices | Size |
|:--- |:---|
| SenseCap K1100 | $0 (free give-out from Seeed) |
| SBC - Rock Pi S | $15 |
| Solar Charger | $38 |

The parts of observation endpoints like iPad or laptop are not included here. Because they are replaceable with any have-screen endpoints with the web access capability. For example, an unused phone. I have three unused phones and one unused pad...

The total cost of TinyWild is $53, and you can reduce the solar charger to a much cheaper common charger if you are not working too long in the wild.

# Outlook
1. Edge LoRaWan Gateway

    The work related to adding LoRaWan gateway to JoinBase server and TinyWild is in progress. We promise to have support for LoRa Gateways in a few weeks. 
    
    After that, JoinBase will be the world's first data stack with MQTT and LoRaWan dual-gateway supporting, and can uniquely run on $15 SBC with a 3MB binary at the same time.

2. More Accurate Edge AI

    For the recognition of a small-kinds, short-range, low-speed objects, Grove AI has shown good results. However, if let Grove AI module to interfence with 15-animal-kinds model, it is found the runtime latency is larger than 1ms. And it is alsos observed that the overheating hot loop may cause the module to hang.

So, to make better use of Grove AI module well, more community practices are needed.

# Reference

[1] [EdgeML codes in this article](https://github.com/open-joinbase/yolov5-swift)

[2] [TinyWild open-source repo](https://github.com/open-joinbase/tinywild)

[3] [Article on Hackster](https://www.hackster.io/surfeit/tinywild-make-wild-iot-in-your-hand-729732)