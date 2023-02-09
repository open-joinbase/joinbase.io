+++
title = "USAL: A New Source Available License"
description = ""
date = 2022-11-22T12:00:00+00:00
updated = 2022-11-22T12:00:00+00:00
draft = false
template = "blog/page.html"

[taxonomies]
contact = ["joinbase0"]

[extra]
lead = "A new source available license, <b>USAL (User Source Available License)</b>, has been proposed."
+++

(*Author 1: The USAL is new, and is one of our attempt to balance a healthy business cycle and open source. We will continue to update the license and explore ways to benefit this era.*)

(*Author 2: the word `open source` in this article refers to [OSI(Open Source Initiative)](https://opensource.org/) defined open source unless bolded and quoted "open source"*)


# Open Source Dilemma

As a long-term open source participant and a founder of tech company, I think around a question over and over again: **how a startup can be built successfully with both open source and business?**

+ Is MongoDB successful? 

However, MongoDB, four years ago [changed its license](https://techcrunch.com/2018/10/16/mongodb-switches-up-its-open-source-license/) to the [Server Side Public License (SSPL)](https://www.mongodb.com/licensing/server-side-public-license), which is not an OSI approved open-source license.

+ Is the company Databricks behind Apache Spark successful? 

This company has reached [$38 billion post-money valuation](https://www.databricks.com/company/newsroom/press-releases/databricks-raises-1-6-billion-series-h-investment-at-38-billion-valuation) after the H series of Databricks. However, the company's core native query engine - [Photon](https://www.databricks.com/product/photon) is not open sourced. Its open-source project under Apache License has a long time not to compete with its data analysis competitors in the performance, like ClickHouse.

It is obvious that, no matter how these startups say they are **"open source"**, the true interesting sources are not available for the business organizations. In fact,

#### Open source is an anti-pattern to the business

Source codes are the core asset of a software company, no matter you are open source or closed source. Open-source means that you share the ownership of that asset to the world. Open core means you you share the ownership of that core asset to the world. 

When the open source antis its business competitors, it antis itself in business as well.

#### Apache License is dead for infra startups

[CockroachDB](https://www.cockroachlabs.com/blog/oss-relicensing-cockroachdb/), [TimescaleDB](https://www.timescale.com/blog/building-open-source-business-in-cloud-era-v2/), [Redis](https://redis.com/legal/licenses/), and [Confluent](https://www.confluent.io/blog/license-changes-confluent-platform/) all changed their license for all or some parts of their platform from open source to source-available.

Two months ago, Akka, which is an old and well-known actor library used in many important Java/Scala infras, [changed from the open-source Apache License to the source-available Business Source License (BSL)](https://www.lightbend.com/blog/why-we-are-changing-the-license-for-akka). If one open-source project can't establish a good business in 13 years, it is really hard to expect more.

One week ago, the author of Mold linker, which is a low-level high performance linker tool, expressed his thoughts on [changing the license](https://docs.google.com/document/d/1kiW9qmNlJ9oQZM6r5o4_N54sX5F8_ccwCy0zpGh3MXk/edit#).

Obviously, the world enjoys such Apache License like permissive licenses, but not give deserved returns to the developers behind these licenses.

Apache License is truly dead for infra startups.

#### Cloud is not the savior

Firstly, cloud vendors host open source based services is the direct reason of above companies change their licenses.

Secondly, to enable cloud native service does not change any above open source anti-pattern to the business. Everyone can host the cloud service with the source, not mentioned that they can change the source to make the service better.

Perhaps, the big tech giants are encouraged to continue to open source their infrastructures under the Apache License in that they have a responsibility to give back to the society.

For current open source startups, they surely has encountered the business dilemma. 

# USAL (User Source Available License)

Not only by encouraging technological innovation of infra startups, but also benefiting all individuals and commercial organizations in this era, I believe that **"open source"** need to adapt itself to the business better. 

[User Source Available License (USAL)](/usal) is proposed to address this problem.

## Core of the USAL

#### User centric

Only **users** of the product are granted with the right of the product's source codes. 

#### Commercial-friendly

Unlike the [BSL](https://mariadb.com/bsl11/) which limits the production use, the USAL explicitly allows production use. It is more like the Apache License without (re)distribution right. 

#### Compatible with all kinds of other licenses

You can change to a more permissive license if you think you can control all the ecosystem, or provide a commercial license when big giants want to use it.

## Workflow of the USAL licensing

The USAL licensing can be done with a workflow rather than the one-time licensing. 

<div class="text-center">
<img src="/imgs/blog/usal/usal_workflow.png" alt="Workflow of the USAL" class="img-fluid">
<p align="center"> The Common Workflow of the USAL <p/>
</div>

One great common workflow is like this: 

1. The people or organizations to request and evaluate the free product firstly. 
2. The people or organizations become **users** when they decide the product fits for them.
3. The **users** request the USAL licensed sources for further interests or concerns.
4. The licensor distributes the USAL licensed sources to the **users**.
5. The **users** do customizing, contributing or any other USAL license allowed things.

## Benefits of the USAL

#### Strong operability

The `change date` concept of BSL seemly makes a good trade-off, but one real-world big project may have millions of commits. In practice, it is impossible to judge the exact change date for a particular piece of sources.

**The license is clear that you can anything to the licensed sources except the (re)distribution.**

#### Strong objective and business scalability  

The USAL is user centric. You only distribute the licensed sources to your users. These users are strongly targeted. After making sure that they are users of your product, you grant the right of sourcing to users in their business without any copycat. 

**With USAL, the advantages of Apache License are inherited, while the disadvantages of Apache License are avoided.**

#### Strong contributions to the times

All the people and business in this era still freely get and adapt the sources to their business under the permissive USAL. The biggest contribution of current permissive open source licenses for business innovations in this era is kept. 

**BSL breaks the greatest feat of open source, USAL fixes it.**

# Source available should be the part of Open Source

The OSI(Open Source Initiative)'s [Open Source Definition](https://en.wikipedia.org/wiki/The_Open_Source_Definition) has been out of the pace of the times. 

> "Absolute power corrupts absolutely"   - Lord Acton

Here, for open source, **absolute open may go to its opposite as well**.

Let's use the USAL to pave a new path for the business of **"open source"**.