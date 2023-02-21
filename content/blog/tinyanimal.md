+++
title = "TinyAnimal: Animal Recognition Practices on Grove Vision AI"
description = ""
date = 2023-02-20T12:00:00+00:00
updated = 2023-02-20T12:00:00+00:00
draft = false
template = "blog/page.html"

[taxonomies]
contact = ["joinbase0"]

[extra]
lead = "In the TinyAnimal project, I will present the practices of EdgeML on the real-world cheap edge AI hardware."
+++

<div class="text-center">
<img src="/imgs/blog/tinyanimal/tinyanimal.jpg" alt="tinyanimal" class="img-fluid">
<p align="center">The wild without a reliable internet connection<p/>
</div>

# Things used in this project
### Hardware components
[Seeed Studio SenseCAP K1100 - The Sensor Prototype Kit with LoRa® and AI](https://www.hackster.io/seeed/products/sensecap-k1100-the-sensor-prototype-kit-with-lora-and-ai1?ref=project-7fe497)
### Software apps and online services
JoinBase
# Story
### Problem
There are many projects focus on the hardware of edge AI/ML. However, in real scenarios, there is no significant practice of learning details in software side on top of products to show, and this paper makes up for this deficiency.

At the same time, **this project provides a complete and reproducible work flow of EdgeML/TinyML for animal recognition on one cheap edge AI hardware**, which is rare in existing projects as known.
### Hardware

<div class="text-center">
<img src="/imgs/blog/tinyanimal/hardware.jpg" alt="hardware" class="img-fluid">
<p align="center">Wio terminal and Grove AI Module in SenseCAP K1100 kit<p/>
</div>

The project's hardware is the Grove Vision AI Module in Seeed [SenseCAP K1100/A1100](https://www.seeedstudio.com/Seeed-Studio-LoRaWAN-Dev-Kit-p-5370.html). There is standalone version of [Grove Vision AI Module](https://wiki.seeedstudio.com/Grove-Vision-AI-Module/) in the official store.

The Vision AI Module has a chip: Himax HX6537-A. The mcu on the chip is based on the [ARC](https://en.wikipedia.org/wiki/ARC_(processor)) arch which is unfamiliar to consumers. The main frequence is 400Mhz which is also not high. But the most interesting that the HX6537-A, has fast [XY SDRAM memory architecture to accelerate](https://www.synopsys.com/designware-ip/technical-bulletin/performance-coding-advantages.html) the TinyML, like tensorflow lite model inferenece. We will see the performance of this chip later.
### Workflow

<div class="text-center">
<img src="/imgs/blog/tinyanimal/workflow.jpg" alt="workflow" class="img-fluid">
<p align="center">Workflow for TinyAnimal<p/>
</div>

The above workflow is common and clear. We only discuss some interesting requirements:

1. The dataset is the public dataset with 9.6GB images.

This avoids the common problem of too few samples or insufficient representativeness.

2. The training is completed locally.

This avoids the common problem of too few samples or insufficient representativeness.

3. The data collection and realtime analysis is done via an edge database [JoinBase](https://joinbase.io/).

Unlike the common databases like PostgreSQL or TimescaleDB, the JoinBase accept the MQTT message directly. Unlike the cloud service, the JoinBase support run in the edge which can be used in an environment without a network. Finally, the JoinBase is free for the commerical use which is also nice for further development of the edge platform.
### Prepare Dataset

<div class="text-center">
<img src="/imgs/blog/tinyanimal/dataset.jpg" alt="dataset" class="img-fluid">
<p align="center">Overall of "animials-80" dataset<p/>
</div>

At present, there is not much public research on the workedge AI for wildlifes or animals. One of the few publicly available animal datasets - [Animals Detection Images Dataset](https://www.kaggle.com/code/majdikarim/farm-animals-detection-yolov5) from Kaggle (called "animials-80" dataset ) has been used. It contains 80 animals in 9.6GB images, and should be great enough for common animal recognition task.

### Prepare Training Data

The good thing of animals-80 dataset is that it has been labeled itself. But the original label format is not Yolov5 label format. A preparation work has been carried on it. The core part is the preprocessing function shown above. Please the later code repo for more.

### Train

Because we don't have enough resources to do a full training on full 9.6GB training. So, a picked subset of **animials-80** dataset has been choosen.

1. **15-animal Subset Training**

<div class="text-center">
<img src="/imgs/blog/tinyanimal/15train.jpg" alt="15train" class="img-fluid">
<p align="center">15-animal subset training<p/>
</div>

We use a 24c/48T Xeon Platinum 8260 Processor to do the training using above the commands got from offical example.

```tom
python3 train.py --img 192 --batch 32 --epochs 200 --data data/animal.yaml --cfg yolov5n6-xiao.yaml --weights yolov5n6-xiao.pt --name animals --cache --project runs/train2
```

However, after two hours (Yes, it proves again that **Don't use CPU to train** even it is a top Xeon SP), the final recognition effect is found to be very poor.

>The main metrics are very low: the precision is 0.6, the recall and mAP_0.5 are just around 0.3.

In fact, this result is close to not working.

2. **4-animal Subset Training**

Let's reduce the types of recognized animals to four: spider, duck, magpie and butterfly, which of course are the most common animals in a suburban wild area.

Note, to re-run the preparing script to generate correct data/animal.yaml.

<div class="text-center">
<img src="/imgs/blog/tinyanimal/4train.jpg" alt="4train" class="img-fluid">
<p align="center">4-animal subset training<p/>
</div>

>The main metrics become better: the precision is ~0.81, the recall and mAP_0.5 are around 0.6.

We will review the performance of this model in the late inference trials and evalutions. It is possible to do only a binary categorization: one animal and no animal. But in this project, I look forward to evaluating the recognition effect in more complex scenes.

3. **4-animal Subset Training by YoLov5Official Pretrain Model**

The above trainings are done by the [Seeed's official document's recommend](https://wiki.seeedstudio.com/Train-Deploy-AI-Model-A1101-Grove-Vision-AI/). The pretrained model is yolov5n6-xiao which may lack good generalization ability. In this project, we try a YoLOv5 official smallest pretrained model yolov5n6 to see whether there is some difference.

<div class="text-center">
<img src="/imgs/blog/tinyanimal/yolov5n6.jpg" alt="yolov5n6" class="img-fluid">
<p align="center">4-animal subset training with offical yolov5n6 model<p/>
</div>

The above result is obtained from the official yolov5n6 model with epochs=150. The result is great. Because,

>The main metrics: the precision, the recall and mAP_0, 5 are all larger than 0.9. In the ML, the difference in mAP_0.5 between 0.6 and 0.9 is huge and huge in real-world detection.

Unfortunately, the final model trained based on the official yolov5n6 is close to 4MB, while the Grove AI module has the constraint model size no more than 1MB. So, we can not make use of any such bigger models (tried). ***Some suggestions will be discussed in the final section.Inference***

<div class="text-center">
<img src="/imgs/blog/tinyanimal/3animals.jpg" alt="3animals" class="img-fluid">
<p align="center">Three examples of detections in the simulation<p/>
</div>

After the above traning, we do a picture based simulation to preliminarily evalute the effect of the model. Let's see examples.

The above is the output of Grove AI module. The index of classification is in the middle and the confidence is around the side. The animal name of coressponding index can be seen in above training figures.

The first and second detection are right in a nice confidence and the third detection is wrong. The third picture shows a magpie fly in the sky and the inference result is the butterfly. We just see the impact of this classification model in the later real-wprld evalution.

### Real-world Evaluation

Inferencing in real world is more challenging than inferencing in laboratory. Because the environment or the status of the tester or the tested object under the test can all have a big impact on the results. That is why we are planning in the workflow section.

We have done a real-world evaluation via a country park wildlife survey in the [project TinyWild](https://www.hackster.io/surfeit/tinywild-make-wild-iot-in-your-hand-729732). Two types of detections are carried out:

1. **Dynamic Viewport (Moving Camera) Based Detection**

<div class="text-center">
<img src="/imgs/blog/tinyanimal/result.png" alt="result" class="img-fluid">
<p align="center">Classification statistics (with confidence > 75) in the whole survey<p/>
</div>

The above figure is the classification statistics (with confidence > 75) in the whole survey. There is a large time in which the camera is moving. So, this is a dynamic viewport (moving camera) based detection. "Unkown" and empty animal which stems from the software logics has been excluded here.

The basic conclusion is that, for individual identification, it is not particularly ideal, but the qualitative information collected is effective.

>Bufferfly is relatively outstanding in the statistics but without Magpie that've seen many times in the park.

This seems the Magpie are been recongized as the bufferfly as shown in the analysis of the Inference section above. What they have in common is that, they often flys in the air. **Three real-world factors: moving camera, moving objects and low resolution, have a great impact on the recognition results.**

2. **Static Viewport (Static Camera) Based Detection**

To reduce impact of moving factors, a dedicated wild duck (mallard) observation in the lakeide has been carried out as well.

<div class="text-center">
<img src="/imgs/blog/tinyanimal/duck_detection.gif" alt="duck_detection" class="img-fluid">
<p align="center">Primary process of the static wild duck observation<p/>
</div>

In the above first of captures, the count of duck in our frontend UI (one of interesting in this is that the dynamic table in UI is driven by a SQL query, please see our more infos in future projects) is 10. Suddenly, two ducks swims into the scope of camera. The count of duck has been increased to 13. Considering the orignal duck is counted, the 13 is the exacting count at that moment. It is found that **the Grove AI works greatly for nearby animal detection** like we done in lakeside: we got three counts when suddenly three ducks swims into the scope of camera in a relative static positioning. (note: in the TinyWild project, we said there are four counts, but it should be corrected to three counts according to our recordings.)

### Ideas

Based on the above pratices, we give out the following suggestions for EdgeML or TinyML on a cheap edge AI hardware:

1. **Try to observe statically**

i.e. observers do not make large movements.

2. **Detect as few objects as possible**

For example, only do the binary categorization: people or nobody, monkey or no monkey, bird or no bird.

3. **Make main metrics of model as large as possible**

For example, the precision > 0.8, the recall and mAP_0.5 > 0.6.

4. **Improve recognition accuracy as possible (like, longer training time)**

The cheap edge ML hardware usally has the limited resources, for example, Grove AI module has the constraint model size no more than 1MB, which falls below the model size trained from the yolov5's official yolov5n pre-trained network. The smaller model is found to significantly affect the model's primary metrics.

### Code
[**TinyAnimal 's modified yolov5-swift repo**](https://github.com/open-joinbase/yolov5-swift)

[**TinyAnimal 's modified Wio Terminal firmware and related**](https://github.com/open-joinbase/tinywild)
