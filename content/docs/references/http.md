+++
title = "HTTP Interface"
description = ""
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 700
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "The HTTP interface lets you use JoinBase on any platform from any programming language in a form of REST API. "
toc = true
top = false
+++

> 🔍
>
> All TCP based interfaces supports two modes: plain or TLS, plain is ok for . But, generally, the TLS interface is recommended for production.

## Primary

1. Query (Data Reading)
```http
GET / or /?param1=a&param2=2... 
[body: select/show/desc statement]
```

The path of a query must be "/". The parameters are optional. Now we support the following parameters:
database, output_layout and output_format, username, password.

|    Parameters             |         MQTT Message             |
| :------------------- | :------------------------ | 
| database      | the name of database.<br/> default value: default, <br/> allowed values: n/a |
| output_layout | the memory layout of output.<br/> default value: rowwise <br/> allowed values:rowwise,columnwise |
| output_format | the memory layout of output.<br/> default value: rowwise <br/> allowed values:json,csv |
| username/password | the username/password for authentication.<br/> (We do not recommend using this method as the parameter might be logged by web proxy and cached in the browser) |

2. Data ingestion (Data Writing)
```http
POST /database/table
[body: csv or json payload]
```

The path of a query must be a valid topic or topic alias. 

3. DDL(Data Definition Language)/Schema Change

See more in the document of [advanced features](/docs/references/advanced).

4. Authentication

The two simple authentication methods in the HTTP interface are supported:

a. Using ‘X-JoinBase-User’ and ‘X-JoinBase-Key’ headers. Example:

b. In the ‘user’ and ‘password’ URL parameters. (We do not recommend using this method as the parameter might be logged by web proxy and cached in the browser).

> 🔍
>
> The security philosophy of JoinBase is whitelist-based. So the authentication is the must in any interface.

## Examples

1. Query

```bash
curl -s -H 'X-JoinBase-User: abc' -H 'X-JoinBase-Key: abc' -X GET 'http://127.0.0.1:8080/' -d 'select 123'|json_pp
```

2. Desc table

```bash
curl -s -H 'X-JoinBase-User: abc' -H 'X-JoinBase-Key: abc' -X GET 'http://127.0.0.1:8080/?database=abc' -d 'desc table t'|json_pp
```

3. Ingest data

```bash
curl -s -H 'X-JoinBase-User: abc' -H 'X-JoinBase-Key: abc'  -X POST 'http://127.0.0.1:8080/abc/t' -d '3,4
5,6'
```

## Predefined Query

See more in the document of [advanced features](/docs/references/advanced).
