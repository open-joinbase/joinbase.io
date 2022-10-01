+++
title = "Glossary"
description = ""
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 999
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "Glossary used in the website and documents."
toc = true
top = false
+++

#### End-to-end Database

The existing databases or data systems require its own clients or intermediate processing pipelines or preprocessed formats to make data correctly written into the databases. In contrast, the end-to-end IoT database, like JoinBase, supports data (a.k.a. domain messages)to be directly written to the end of data sink (a.k.a. the database) from the end of data production sources (a.k.a. devices).

An end-to-end database is proposed, by us, as an out-of-the-box database for non-professional domain users. The end-to-end database evolves through user orientated characteristics, not based on technical features.

More formally, **an end-to-end database meets the following <sup>3</sup>E standards**:

1. **End native**. For IoT domain, direct message ingestion from end devices to end databases without any intermediate components involved.
2. **End elasticity**. For IoT domain, both cloud end and edge end are deployable for main three stream CPU architectures without any functionality compromise.
3. **End friendly**. All necessary pipelines are provided for end users without any DBA required.

#### IoT Native

In JoinBase, MQTT messages becomes the first-class citizen of database. We support ten million concurrent physical connections from massive IoT (Internet of Things) devices to ingest near ten million one-by-one messages in one node. The whole database is built and optimized for unlimited IoT bigdata. 

In all databases, we know the internet of things best.

#### DevOps Free

In JoinBase, we carefully craft a dedicate database for unlimited IoT bigdata. You don't need a dedicated JoinBase administrator (a.k.a. DBA) to maintain the JoinBase. The system is designed to work in a highly fault-tolerant manner, and can automatically recover from most errors. 

#### IoT Natural ACID

[ACID](https://en.wikipedia.org/wiki/ACID) (atomicity, consistency, isolation, durability) is a set of properties of database transactions to guarantee that the data system can work properly in all situations. 

Usually databases use some specific statements to group multiple statements as a single atomic unit, a.k.a. transaction. It is obvious that， there is a significant performance cost to supporting arbitrary transactions in general data systems. 

In JoinBase, we support a subset of general ACID transaction, `IoT Natural ACID` transaction called by us: the single-row write transaction in read committed isolation level. Every single-row message written into JoinBase is taken as an implicit transaction. And JoinBase does not provide any explicit transaction control statement now. The IoT Natural ACID enables a special consistency model: causal consistency. That is, we guarantee the messages and their data effect from the same client are in the order. So, if there are causalities in all kinds of IoT events, you can still make causal inferences based on data effects.

In the IoT domain, the messages from different clients are not related. So, it doesn't make sense to provide complex composable transactions here. Although richer ACID options may be provided in the future, it is believed that IoT Natural ACID transaction as the default transaction behavior is the best choice for IoT domain users.

In JoinBase, one message may be mapped to one row or more rows by [JSON array flattening](/docs/references/mapping/#custom-mapping). But the message flattening is deterministic, so the single-row transaction model is still applied for the deterministic splitting rows.



