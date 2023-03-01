+++
title = "JoinBase Tips Series #2: Using HTTP Interface in JoinBase"
description = ""
date = 2023-02-23T12:00:00+00:00
updated = 2023-02-23T12:00:00+00:00
draft = false
template = "blog/page.html"

[taxonomies]
contact = ["joinbase0"]

[extra]
lead = "In JoinBase 2022.12, we introduced the HTTP interface, making JoinBase a general-purpose multi-protocol time series data service platform."

+++

Among the existing databases, there are very few databases that can natively support the HTTP interface. This brings up a problem: If users want to provide REST services based on these databases, they need to combine other HTTP services on top of the existing databases. 

# Basic knowledge

### HTTP API

First introduce the concept of API, Application Programming Interface (application programming interface) is its full name. The simple understanding is that API is an interface. So what kind of interface is it? Now we often regard it as an HTTP interface, that is, HTTP API. That is to say, this interface has to be called through HTTP.

Say we have an application that allows us to view, create, edit and delete widgets, we can create HTTP APIs that allow us to perform these functions.

But what's the inconvenience of doing this? This way of writing the API has a disadvantage, that is, there is no unified style, which will cause other people who use our interface to have to refer to the API to know how it works.

Don't worry, REST will solve this problem for us.

### What is REST?

With the above introduction, you may also have an intuitive understanding. To put it bluntly, **REST is a style!**

The role of REST is to directly map the view (view), create (create), edit (edit) and delete (delete) we mentioned above to the **GET, POST, PUT and DELETE** methods that have been implemented in HTTP.

After this change, the API becomes unified, and we only need to change the request method to complete related operations, which greatly simplifies the difficulty of understanding our interface and becomes easy to call.

**That's what REST is all about!**

# Preparation

The HTTP interface is JoinBase's effort to facilitate the user's end-to-end experience.

First, refer to our quick start tutorial, create a JoinBase account, and complete the operations in the article.

After you follow the above steps, simple data is inserted into JoinBase.

Also don't forget to execute the following command to install curl, which is a prerequisite for us to use the HTTP interface.

```
sudo snap install curl
```

# Use the HTTP interface

At this point, let's experience the HTTP interface. This section will demonstrate a simple REST-based process for reading and writing.

Enter the above command to see our previous table creation

<div class="text-center">
<img src="/imgs/blog/tips_2/table.png" alt="table" class="img-fluid">
<p align="center"><p/>
</div>

Let's change the way and enter the following command to view the previously created table using the HTTP interface

```
curl -s -H 'X-JoinBase-User: tips' -H 'X-JoinBase-Key: 123456' -X GET 'http://127.0.0.1:8080/?database=jb_tips' -d 'desc table t'|json_pp;
```

got the answer:

<div class="text-center">
<img src="/imgs/blog/tips_2/HTTP_table.png" alt="HTTP_table" class="img-fluid">
<p align="center"><p/>
</div>

Similarly, enter the following commands to use the HTTP interface to insert data into the database.

Now, we insert the data "3,4":

```
curl -s -H 'X-JoinBase-User: tips' -H 'X-JoinBase-Key: 123456'  -X POST 'http://127.0.0.1:8080/jb_tips/t' -d '3,4
```

Next, let's try query operations.

Execute the following commands to query.

```
curl -s -H 'X-JoinBase-User: tips' -H 'X-JoinBase-Key: 123456' -X GET 'http://127.0.0.1:8080/?database=jb_tips' -d 'select * from jb_tips.t'|json_pp;
```

note: "|json_pp" at the end of this command can help us **see the query results more intuitively** in the format of the json file . If not used, the query results will be presented in this form:

```
[{"a":1,"b":2},{"a":3,"b":4}]
```

As you can see, the result of such a query is not intuitive.

Therefore, we should pay attention to adding when we want to see the query results; in addition, I believe some friends have also noticed that it is not used in the command to insert data, because we do not need to view it when inserting data.

After executing the previous command, the query result will be displayed in the following figure:

<div class="text-center">
<img src="/imgs/blog/tips_2/result.png" alt="result" class="img-fluid">
<p align="center"><p/>
</div>

Obviously, compared with the other results, this query result is very clear and easy for beginners to understand.

Congratulations, you have a preliminary understanding of the basic operations of the HTTP interface in JoinBase!

# And one more thing

JoinBase provides a lot of value beyond the peers of this era. We sincerely invite more users to join our community. JoinBase can help you!

Download JoinBase: [Download](https://joinbase.io/products/) the full-featured version of JoinBase and SmartBase for free now , so that your AIoT digital capabilities will be one step ahead.

JoinBase Global Community: [Github Global Community](https://github.com/open-joinbase/joinbase)

JoinBase Chinese Community: [WeChat Group](https://joinbase.io/community/)

JoinBase Discord Server: [Discord](https://discord.com/invite/sqX6vfnURj)
