+++
title = "Performance Tips"
description = ""
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 888
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "If you understand principles and knowledge about the system, you can take the unprecedented power of joinbase."
toc = true
top = false
+++

#### Reasonable Partition

You have understood the concept of [`Partition`](/docs/references/concept#partition) why it is a key to the bigdata and joinbase.

Therefore, a good shaped partition is the key to the query performance. The basic principle is： 
* keep the size of partition between tens of thousand rows and tens of million rows as possible;
* for time series data, partitioning using natural time units (day, hour, minute) is a good practice;
* use `WHERE PARTITIONS/PARTS` clause to narrow down your query dataset as possible to accelerate your queries speed directly and effectively unless your full table size is small


#### Denormalization

[Denormalization](https://en.wikipedia.org/wiki/Denormalization) is a good practice to keep if you are working on the big data. The speed of single-table query and multi-table join may differ by hundreds or even tens of thousands of times.

* as possible mapping json to wide-row table schema rather than using the opaque String or container types.
* as possible use Enum type for long String fields when data redundancy and denormalization used.
* as possible trade space for time because the modern storage is cheap. For example, assumed that you have a frequently-used expression in the queries, it is good to derive a new column with this expression and use this column in the queries directly.

#### Data Type

Choosing the right data type may greatly improve your storage and query efficiency.

* use Enum and Dict type rather than String type if your String like column has a small variance in its contents (a.k.a., low cardinality).
* use No-nullable types with default values (such as '', 0, etc) rather than Nullable types (with null) as possible. Because the null value handling is tricky in some cases and the query with no-nullable type is faster than that of nullable type (although the magnitude of the benefits is related to the scenario).

#### Hardware

joinbase is forged for modern hardware. With joinbase in a modern box, you can sleep while handling with the global device data torrent. Therefore, don't hesitate to use the latest hardware against the joinbase. 

Today's SSDs(Solid State Drives) are already very cheap. And because the joinbase has a built-in unique reliability design, it is highly recommended to all users to use SSDs for the storage.