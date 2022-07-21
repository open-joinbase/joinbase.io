+++
title = "Quick Start for Cloud"
description = "Quick Start"
date = 2021-05-01T08:20:00+00:00
updated = 2021-05-01T08:20:00+00:00
draft = false
weight = 300
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "Yeah, joinbase Cloud Preview works for non-coder!"
toc = true
top = false
+++

JoinBase Cloud Preview is modified from [Redash](https://github.com/getredash/redash), and we really appreciated for Redash's great frontend works. Thanks to the excellently intuitive UI, we only give the guidance on main points. Recommend to [sign up](https://cloud.joinbase.io) and explore yourself.

<p align="center">Dashboard<p/>
<img src="/imgs/docs/joinbase_cloud_1.png" alt="JoinBase cloud" class="img-fluid">

1. Side bar for quick navigation.
2. Settings for more infos about message writing.
3. Request link for applying for JoinBase Enterprise.
4. Current quota usage.

<p align="center">Query<p/>
<img src="/imgs/docs/joinbase_cloud_2.png" alt="JoinBase cloud" class="img-fluid">

1. Databases list which you can connect with. The current Preview only support tow databases: your owned in the name of account name and default.
2. Fresh the current database (maybe some bug happens for delayed freshing)
3. Schema infos for current database. You can click the right arrow of table name for detail columns listing.
4. SQL editor.
5. Result set showing and visualizing.
6. Runtime for current query. Because Redash uses a process based worker pool for querying, this increase the end-to-end latency of a single query. Note, you may observe longer delay between sending and result showing, it is from scheduling queries in pool. This delay has been removed from the runtime value largely. But this timing is not exact yet. Sometimes, we observe 2x slowness in this timing. We put this timing here is for showing a qualitative performance information for users.

<p align="center">Settings<p/>
<img src="/imgs/docs/joinbase_cloud_3.png" alt="JoinBase cloud" class="img-fluid">

1. MQTT endpoint uri. This uir provide the info connect to JoinBase Cloud Preview MQTT server per account.
2. Tips lists an ready-to-run example against the JoinBase Cloud Preview. Try yourself!

------------------------
In order to avoid resources misuse, some functionalities have be restricted to a certain extent, but due to time constraints, we may not update it at the first time. You can [apply the JoinBase Enterprise for your own evaluation](https://cloud.joinbase.io/req).

Finally, although we have made some restrictions, to make users to experience a general system, we still open the general query of the [10-billion-row `nyct_strip` dataset](/benchmark/#benchmark-model). It is hoped that users do a fair use of resources. If you have any questions, welcome to [the community](https://github.com/open-joinbase/joinbase) to ask questions.