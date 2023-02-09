+++
title = "Extensions"
description = ""
date = 2022-12-01T08:20:00+00:00
updated = 2022-12-01T08:20:00+00:00
draft = false
weight = 820
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "JoinBase has built-in extension mechanisms which empower users great customization capabilities."
toc = true
top = false
+++

There are three types of extensions in JoinBase: UDM(User Defined Mapping), UDF(User Defined Function) and UDAF(User Defined Aggregate Function).

### User Defined Mapping

The UDM enables a mechanism to support arbitrary user defined mapping logic. 

We provide a C ABI based API for UDM. Any logic in any language which can be compiled into the API-compatible dynamic library are supported.

A workable example is available in [this C based sample extension project](https://github.com/open-joinbase/extensions).

### User Defined Function

See more in the document of [advanced features](/docs/references/advanced).

### User-Defined Aggregate Functions

See more in the document of [advanced features](/docs/references/advanced).