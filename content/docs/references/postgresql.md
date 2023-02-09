+++
title = "PostgreSQL Interface"
description = ""
date = 2021-09-01T08:20:00+00:00
updated = 2021-12-01T08:20:00+00:00
draft = false
weight = 720
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "JoinBase supports the PostgreSQL wire protocol."
toc = true
top = false
+++

Any PostgreSQL client or language can talk with JoinBase in the capability. However, we think that the syntax of PostgreSQL, as a SQL dialect, it shows some inconsistent and confusing in the usage. For example, to show databases' information, you should use a exotic symbolic `\l`, rather than a plain SQL like statement.

JoinBase, as brand-new end-to-end IoT database, based on 20 year database experience, via learning from different dialects - PostgreSQL, MySQL, ClickHouse et. al., we want to provide a **simple, neat, consistent and extendable** ansi-SQL compatible language for users, rather than being a clone of any existing dialect.

The JoinBase language specification could be seen in the [`Language`](/docs/references/lang/).

In the following list, we continue to track the compatibility of main PostgreSQL clients and drivers.

## Client Compatibility

| Client Name  | Description  | Tested | 
| :----------- | :----------- | :--------------: | 
|  [psql](https://www.postgresql.org/docs/current/app-psql.html) | PostgreSQL official terminal  |✅|

## Driver Compatibility

| Language | Tested | 
| :----------- | :--------------: | 
|  Go  |✅|
|  Python  |✅|
|  Java  |✅|
|  C  |✅|
|  C++  |✅|
|  Rust  |✅|
|  Javascript  |✅|

## Language Driver Examples

### Go

sample mod:
```go
module hello

go 1.17

require (
	github.com/eclipse/paho.mqtt.golang v1.3.5 // indirect
	github.com/gorilla/websocket v1.4.2 // indirect
	github.com/lib/pq v1.10.4 // indirect
	golang.org/x/net v0.0.0-20200425230154-ff2c4b7c35a0 // indirect
)
```

sample program:
```go
package main

import (
	"database/sql"
	"log"
	"fmt"
	"time"
	mqtt "github.com/eclipse/paho.mqtt.golang"
	_ "github.com/lib/pq"
)

func main() {
	connStr := "user=abc password=abc dbname=abc sslmode=disable host=127.0.0.1 port=5433"
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	test(db)
	test0(db)
	test1(db)
	test2(db)
	test3(db)
	test4(db)
	test5(db)
}

var connectHandler mqtt.OnConnectHandler = func(client mqtt.Client) {
	log.Println("Connected")
}

var connectLostHandler mqtt.ConnectionLostHandler = func(client mqtt.Client, err error) {
    log.Printf("Connect lost: %v", err)
}

func newMQTTClient() mqtt.Client {
	var broker = "127.0.0.1"
	var port = 1883

	opts := mqtt.NewClientOptions()
	opts.AddBroker(fmt.Sprintf("tcp://%s:%d", broker, port))
	opts.SetClientID("go_mqtt_client")
	opts.SetUsername("abc")
	opts.SetPassword("abc")
	// opts.OnConnect = connectHandler
	// opts.OnConnectionLost = connectLostHandler
	client := mqtt.NewClient(opts)
	if token := client.Connect(); token.Wait() && token.Error() != nil {
		panic(token.Error())
	}

	return client
}

func publish(client mqtt.Client) {
    num := 10
    for i := 0; i < num; i++ {
        text := fmt.Sprintf("{\"x\": %d}", i)
        token := client.Publish("/abc/test", 0, false, text)
        token.Wait()
    }
}

func test(db *sql.DB) {
	db.Query("drop table if exists test;")
	db.Query("create table if not exists test (x UInt16);")
	
	client := newMQTTClient()

	publish(client)

        time.Sleep(time.Second)

	rows, err := db.Query("select x from test;")

	if err != nil {
		log.Fatal(err)
	}

	for rows.Next() {
		var (
			x uint16;
		)

		if err := rows.Scan(&x); err != nil {
			log.Fatal(err)
		}
		log.Printf("test: x %d", x)
	}		
	
}

func test0(db *sql.DB) {
	db.Query("drop table if exists test0;")
	db.Query("create table if not exists test0 (x UInt64, y Int64);")
	db.Query("insert into test0 values(1, 2),(2, 3);")

	rows, err := db.Query("select x, y from test0;")

	if err != nil {
		log.Fatal(err)
	}

	for rows.Next() {
		var (
			x uint64;
			y int64
		)

		if err := rows.Scan(&x, &y); err != nil {
			log.Fatal(err)
		}
		log.Printf("test0: x %d y %d", x, y)
	}	
}

func test1(db *sql.DB) {
	db.Query("drop table if exists test1;")
	db.Query("create table if not exists test1 (x String); ")
	db.Query("insert into test1 values('Hello, World'),('你好, 世界');")
	
	rows, err := db.Query("select x from test1;")

	if err != nil {
		log.Fatal(err)
	}

	for rows.Next() {
		var (
			x string
		)

		if err := rows.Scan(&x); err != nil {
			log.Fatal(err)
		}
		log.Printf("test1: x %s", x)
	}
		
}

func test2(db *sql.DB) {
	db.Query("drop table if exists test2;")
	db.Query("create table if not exists test2 (x DateTime); ")
	db.Query("insert into test2 values('2021-01-01 00:00:00'),('2021-02-01 00:00:00');")

	rows, err := db.Query("select x from test2;")

	if err != nil {
		log.Fatal(err)
	}

	for rows.Next() {
		var (
			x string
		)

		if err := rows.Scan(&x); err != nil {
			log.Fatal(err)
		}
		log.Printf("test2: x %s", x)
	}
			
}

func test3(db *sql.DB) {
	db.Query("drop table if exists test3;")
	db.Query("create table if not exists test3 (x FixedString(20)); ")
	db.Query("insert into test3 values('Hello, World'),('你好, 世界');")	

	rows, err := db.Query("select x from test3;")

	if err != nil {
		log.Fatal(err)
	}

	for rows.Next() {
		var (
			x string
		)

		if err := rows.Scan(&x); err != nil {
			log.Fatal(err)
		}
		log.Printf("test3: x %s", x)
	}
			
}

func test4(db *sql.DB) {
	db.Query("create type if not exists ColorEnum8 as Enum8('blue', 'red', 'gray', 'black');")
	db.Query("create type if not exists ColorEnum16 as Enum16('blue', 'red', 'gray', 'black');")
	db.Query("drop table if exists test4;")
	db.Query("create table if not exists test4 (x ColorEnum8, y ColorEnum16); ")
	db.Query("insert into test4 values('blue', 'blue'),('gray', 'gray'), ('red', 'red'), ('black', 'black');")	

	rows, err := db.Query("select x, y from test4;")

	if err != nil {
		log.Fatal(err)
	}

	for rows.Next() {
		var (
			x string;
			y string;
		)

		if err := rows.Scan(&x, &y); err != nil {
			log.Fatal(err)
		}
		log.Printf("test4: x %s, y %s", x, y)
	}
		
}


func test5(db *sql.DB) {
	db.Query("drop table if exists test5;")
	db.Query("create table if not exists test5 (x UInt64, y String, z DateTime) partition by (x, y, toYYYY(z));")

	db.Query("insert into test5 values(1, 'Hello, World', '2020-01-01 00:00:00'),(2, '你好, 世界', '2021-01-01 00:00:00');")

	time.Sleep(time.Second)

	rows, err := db.Query("select x, y, z from test5;")

	if err != nil {
		log.Fatal(err)
	}

	for rows.Next() {
		var (
			x uint64;
			y string;
			z string;
		)

		if err := rows.Scan(&x, &y, &z); err != nil {
			log.Fatal(err)
		}
		log.Printf("test5: x %d, y %s, z %s", x, y, z)
	}	
}
```

### Python

sample program:
```python
import psycopg2
import paho.mqtt.client as mqtt
import time

client = mqtt.Client(client_id="",
                     clean_session=True,
                     userdata=None,
                     protocol=mqtt.MQTTv311,
                     transport="tcp")

client.username_pw_set(username="abc", password="abc")

client.connect("localhost", port=1883, keepalive=60)

try:

    connection = psycopg2.connect(user="abc",
                                  password="abc",
                                  host="localhost",
                                  port="5433",
                                  database="abc")

    # if you don't set this, the driver will assume that you are using a
    # detached transaction and put the BEGIN at the begining of the query
    connection.set_session(autocommit=True)

    cursor = connection.cursor()

    cursor.execute("select 1;")
    record = cursor.fetchone()
    print(record)

    cursor.execute("drop table if exists test;")
    cursor.execute("create table if not exists test (x UInt16)")
    client.publish("/abc/test", payload="{\"x\": 1}", qos=0, retain=False)
    time.sleep(1)
    cursor.execute("select x from test;")
    print([r for r in cursor])

    cursor.execute("drop table if exists test0;")
    cursor.execute("create table if not exists test0 (x UInt32, y Int64);")
    cursor.execute("insert into test0 values(1, 2),(2, 3);")
    time.sleep(1)
    cursor.execute("select x,y from test0;")
    print([r for r in cursor])

    cursor.execute("drop table if exists test1;")
    cursor.execute("create table if not exists test1 (x String);")
    cursor.execute("insert into test1 values('Hello, World'),('你好, 世界');")
    time.sleep(1)
    cursor.execute("select x from test1;")
    print([r for r in cursor])

    cursor.execute("drop table if exists test2;")
    cursor.execute("create table if not exists test2 (x DateTime);")
    cursor.execute(
        "insert into test2 values('2021-01-01 00:00:00'),('2021-02-01 00:00:00');"
    )
    time.sleep(1)
    cursor.execute("select x from test2;")
    print([r for r in cursor])

    cursor.execute(
        "create type if not exists ColorEnum8 as Enum8('blue', 'red', 'gray', 'black');"
    )
    cursor.execute(
        "create type if not exists ColorEnum16 as Enum16('blue', 'red', 'gray', 'black');"
    )
    cursor.execute("drop table if exists test4;")
    cursor.execute(
        "create table if not exists test4 (x ColorEnum8, y ColorEnum16);")
    cursor.execute(
        "insert into test4 values('blue', 'blue'),('gray', 'gray'), ('red', 'red'), ('black', 'black');"
    )
    time.sleep(1)
    cursor.execute("select x,y from test4;")
    print([r for r in cursor])

    cursor.execute("drop table if exists test5;")
    cursor.execute(
        "create table if not exists test5 (x Int32, y String, z DateTime) partition by toYYYY(z);"
    )
    cursor.execute(
        "insert into test5 values(1, 'Hello, World', '2020-01-01 00:00:00'),(2, '你好, 世界', '2021-01-01 00:00:00');"
    )
    time.sleep(1)
    cursor.execute("select x,y,z from test5;")
    print([r for r in cursor])

except (Exception, psycopg2.Error) as error:
    print(error)
    connection = None

finally:
    if (connection is not None):
        cursor.close()
        connection.close()
        print("PostgreSQL connection is now closed")
```

### C

sample program:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "MQTTClient.h"
#include <libpq-fe.h>

#define ADDRESS     "tcp://localhost:1883"
#define CLIENTID    "ExampleClientPub"
#define QOS         0
#define TIMEOUT     10000L

void do_exit(PGconn *conn, PGresult *res);
void send_msg(MQTTClient client, char* topic, char* msg);


void do_exit(PGconn *conn, PGresult *res) {

    fprintf(stderr, "%s\n", PQerrorMessage(conn));

    PQclear(res);
    PQfinish(conn);

    exit(1);
}

void send_msg(MQTTClient client, char* topic, char* msg) {
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_deliveryToken token;

    pubmsg.payload = (void *)msg;
    pubmsg.payloadlen = strlen(msg);
    pubmsg.qos = QOS;
    pubmsg.retained = 0;
    MQTTClient_publishMessage(client, topic, &pubmsg, &token);
    MQTTClient_waitForCompletion(client, token, TIMEOUT);
    sleep(1);
}

void send_query(PGconn *conn, char* query, int cols) {
    PGresult *res = PQexec(conn, query);

    if (PQresultStatus(res) == PGRES_TUPLES_OK) {
	int rows = PQntuples(res);

	for(int i=0; i<rows; i++) {

	    for (int j=0; j<cols; j++) {
		printf("%s ", PQgetvalue(res, i, j));
	    }

	    printf("\n");
	}
    }

    PQclear(res);
}

int main(int argc, char* argv[])
{
    int lib_ver = PQlibVersion();
    printf("Version of libpq: %d\n", lib_ver);

    PGconn *conn = PQconnectdb("host=localhost port=5433 user=abc dbname=abc password=abc");

    if (PQstatus(conn) == CONNECTION_BAD) {

        fprintf(stderr, "Connection to database failed: %s\n",
		PQerrorMessage(conn));
	PQfinish(conn);
	exit(1);
    }
    int ver = PQserverVersion(conn);
    printf("Server version: %d\n", ver);

    MQTTClient client;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_deliveryToken token;
    int rc;
    MQTTClient_create(client, ADDRESS, CLIENTID,
        MQTTCLIENT_PERSISTENCE_NONE, NULL);
    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 1;
    conn_opts.username = "abc";
    conn_opts.password = "abc";
    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to connect, return code %d\n", rc);
        exit(EXIT_FAILURE);
    }

    send_query(conn, "drop table if exists test", 0);
    send_query(conn, "create table if not exists test (x UInt16)", 0);
    send_msg(client, "/abc/test", "{\"x\": 1}");
    send_query(conn, "select x from test", 1);

    send_query(conn, "drop table if exists test0", 0);
    send_query(conn, "create table if not exists test0 (x UInt32, y Int64)", 0);
    send_query(conn, "insert into test0 values(1, 2),(2, 3);", 0);
    sleep(1);
    send_query(conn, "select x,y from test0", 2);


    send_query(conn, "drop table if exists test1", 0);
    send_query(conn, "create table if not exists test1 (x String)", 0);
    send_query(conn, "insert into test1 values('Hello, World'),('你好, 世界')", 0);
    sleep(1);
    send_query(conn, "select x from test1", 1);

    send_query(conn, "drop table if exists test2", 0);
    send_query(conn, "create table if not exists test2 (x DateTime)", 0);
    send_query(conn, "insert into test2 values('2021-01-01 00:00:00'),('2021-02-01 00:00:00')", 0);
    sleep(1);
    send_query(conn, "select x from test2", 1);


    send_query(conn, "create type if not exists ColorEnum8 as Enum8('blue', 'red', 'gray', 'black');", 0);
    send_query(conn, "create type if not exists ColorEnum16 as Enum16('blue', 'red', 'gray', 'black');", 0);
    send_query(conn, "drop table if exists test4", 0);
    send_query(conn, "create table if not exists test4 (x ColorEnum8, y ColorEnum16)", 0);
    send_query(conn, "insert into test4 values('blue', 'blue'),('gray', 'gray'), ('red', 'red'), ('black', 'black')", 0);
    sleep(1);
    send_query(conn, "select x,y from test4", 2);

    send_query(conn, "drop table if exists test5", 0);
    send_query(conn, "create table if not exists test5 (x Int32, y String, z DateTime) partition by toYYYY(z)", 0);
    send_query(conn, "insert into test5 values(1, 'Hello, World', '2020-01-01 00:00:00'),(2, '你好, 世界', '2021-01-01 00:00:00')", 0);
    sleep(1);
    send_query(conn, "select x,y,z from test5", 3);


    PQfinish(conn);
    MQTTClient_disconnect(client, 10000);
    MQTTClient_destroy(&client);
    return rc;
}
```

### C++

sample program:
```cpp
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "MQTTClient.h"
#include <libpq-fe.h>
#include <chrono>
#include <thread>

#define ADDRESS     "tcp://localhost:1883"
#define CLIENTID    "ExampleClientPub"
#define QOS         0
#define TIMEOUT     10000L

void sleep(int secs);
void do_exit(PGconn *conn, PGresult *res);
void send_msg(MQTTClient client, const char* topic, const char* msg);
void send_query(PGconn *conn, const char* query, const int cols);

void sleep(int secs) {
    std::this_thread::sleep_for(std::chrono::milliseconds(1000*secs));
}

void do_exit(PGconn *conn, PGresult *res) {

    fprintf(stderr, "%s\n", PQerrorMessage(conn));

    PQclear(res);
    PQfinish(conn);

    exit(1);
}

void send_msg(MQTTClient client, const char* topic, const char* msg) {
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_deliveryToken token;

    pubmsg.payload = (void *)msg;
    pubmsg.payloadlen = strlen(msg);
    pubmsg.qos = QOS;
    pubmsg.retained = 0;
    MQTTClient_publishMessage(client, topic, &pubmsg, &token);
    MQTTClient_waitForCompletion(client, token, TIMEOUT);
    sleep(1);
}

void send_query(PGconn *conn, const char* query, const int cols) {
    PGresult *res = PQexec(conn, query);

    if (PQresultStatus(res) == PGRES_TUPLES_OK) {
	int rows = PQntuples(res);

	for(int i=0; i<rows; i++) {

	    for (int j=0; j<cols; j++) {
		printf("%s ", PQgetvalue(res, i, j));
	    }

	    printf("\n");
	}
    }

    PQclear(res);
}

int main(int argc, char* argv[])
{
    int lib_ver = PQlibVersion();
    printf("Version of libpq: %d\n", lib_ver);

    PGconn *conn = PQconnectdb("host=localhost port=5433 user=abc dbname=abc password=abc");

    if (PQstatus(conn) == CONNECTION_BAD) {

        fprintf(stderr, "Connection to database failed: %s\n",
		PQerrorMessage(conn));
	PQfinish(conn);
	exit(1);
    }
    int ver = PQserverVersion(conn);
    printf("Server version: %d\n", ver);

    MQTTClient client;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_deliveryToken token;
    int rc;
    MQTTClient_create(&client, ADDRESS, CLIENTID,
        MQTTCLIENT_PERSISTENCE_NONE, NULL);
    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 1;
    conn_opts.username = "abc";
    conn_opts.password = "abc";
    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to connect, return code %d\n", rc);
        exit(EXIT_FAILURE);
    }

    send_query(conn, "drop table if exists test", 0);
    send_query(conn, "create table if not exists test (x UInt16)", 0);
    send_msg(client, "/abc/test", "{\"x\": 1}");
    send_query(conn, "select x from test", 1);

    send_query(conn, "drop table if exists test0", 0);
    send_query(conn, "create table if not exists test0 (x UInt32, y Int64)", 0);
    send_query(conn, "insert into test0 values(1, 2),(2, 3);", 0);
    sleep(1);
    send_query(conn, "select x,y from test0", 2);


    send_query(conn, "drop table if exists test1", 0);
    send_query(conn, "create table if not exists test1 (x String)", 0);
    send_query(conn, "insert into test1 values('Hello, World'),('你好, 世界')", 0);
    sleep(1);
    send_query(conn, "select x from test1", 1);

    send_query(conn, "drop table if exists test2", 0);
    send_query(conn, "create table if not exists test2 (x DateTime)", 0);
    send_query(conn, "insert into test2 values('2021-01-01 00:00:00'),('2021-02-01 00:00:00')", 0);
    sleep(1);
    send_query(conn, "select x from test2", 1);


    send_query(conn, "create type if not exists ColorEnum8 as Enum8('blue', 'red', 'gray', 'black');", 0);
    send_query(conn, "create type if not exists ColorEnum16 as Enum16('blue', 'red', 'gray', 'black');", 0);
    send_query(conn, "drop table if exists test4", 0);
    send_query(conn, "create table if not exists test4 (x ColorEnum8, y ColorEnum16)", 0);
    send_query(conn, "insert into test4 values('blue', 'blue'),('gray', 'gray'), ('red', 'red'), ('black', 'black')", 0);
    sleep(1);
    send_query(conn, "select x,y from test4", 2);

    send_query(conn, "drop table if exists test5", 0);
    send_query(conn, "create table if not exists test5 (x Int32, y String, z DateTime) partition by toYYYY(z)", 0);
    send_query(conn, "insert into test5 values(1, 'Hello, World', '2020-01-01 00:00:00'),(2, '你好, 世界', '2021-01-01 00:00:00')", 0);
    sleep(1);
    send_query(conn, "select x,y,z from test5", 3);


    PQfinish(conn);
    MQTTClient_disconnect(client, 10000);
    MQTTClient_destroy(&client);
    return rc;
}
```

### Rust

Sample program could be in our [OIDBS project](https://github.com/open-JoinBase/oidbs).


### Javascript

sample program:
```javascript
const { Pool, Client } = require('pg');
const  mqtt = require('async-mqtt');

const host = 'localhost';
const port = '1883';
const clientId = `mqtt_${Math.random().toString(16).slice(3)}`;

const connectUrl = `mqtt://${host}:${port}`;

const pool = new Pool({
    user: 'abc',
    host: 'localhost',
    database: 'abc',
    password: 'abc',
    port: 5433,
});

async function sendQuery(client, query) {
    let res = await client.query(query, []);
    if (res.rows.length != 0) {
	console.log(res);
	console.log(res.rows);
    }
}

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

(async () => {

    const pg_client = await pool.connect();
    const mqtt_client = await mqtt.connectAsync(connectUrl, {
	clientId,
	clean: true,
	connectTimeout: 4000,
	username: 'abc',
	password: 'abc',
	reconnectPeriod: 1000,
    });

    try {
	await sendQuery(pg_client, "select 1");

	await sendQuery(pg_client, "drop table if exists test;");
	await sendQuery(pg_client, "create table if not exists test (x UInt16);");
	await mqtt_client.publish("/abc/test", "{\"x\": 1}");
	await sleep(1000);
	await sendQuery(pg_client, "select x from test;");

	await sendQuery(pg_client, "drop table if exists test0;");
	await sendQuery(pg_client, "create table if not exists test0 (x UInt32, y Int64);");
	await sendQuery(pg_client, "insert into test0 values(1, 2),(2, 3);");
	await sleep(1000);
	await sendQuery(pg_client, "select x, y from test0;");

	await sendQuery(pg_client, "drop table if exists test1;");
	await sendQuery(pg_client, "create table if not exists test1 (x String);");
	await sendQuery(pg_client, "insert into test1 values('Hello, World'),('你好, 世界');");
	await sleep(1000);
	await sendQuery(pg_client, "select x from test1;");

	await sendQuery(pg_client, "drop table if exists test2;");
	await sendQuery(pg_client, "create table if not exists test2 (x DateTime);");
	await sendQuery(pg_client, "insert into test2 values('2021-01-01 00:00:00'),('2021-02-01 00:00:00');");
	await sleep(1000);
	await sendQuery(pg_client, "select x from test2;");

	await sendQuery(pg_client, "create type if not exists ColorEnum8 as Enum8('blue', 'red', 'gray', 'black');");
	await sendQuery(pg_client,"create type if not exists ColorEnum16 as Enum16('blue', 'red', 'gray', 'black');");
	await sendQuery(pg_client, "drop table if exists test4;");
	await sendQuery(pg_client, "create table if not exists test4 (x ColorEnum8, y ColorEnum16);");
	await sendQuery(pg_client, "insert into test4 values('blue', 'blue'),('gray', 'gray'), ('red', 'red'), ('black', 'black');");
	await sleep(1000);
	await sendQuery(pg_client, "select x,y from test4;");



	await sendQuery(pg_client, "drop table if exists test5;");
	await sendQuery(pg_client, "create table if not exists test5 (x Int32, y String, z DateTime) partition by toYYYY(z);");
	await sendQuery(pg_client, "insert into test5 values(1, 'Hello, World', '2020-01-01 00:00:00'),(2, '你好, 世界', '2021-01-01 00:00:00');");
	await sleep(1000);
	await sendQuery(pg_client, "select x,y,z from test5;");

    } finally {
	pg_client.release();
	pool.end();
	mqtt_client.end();
  }
})().catch(err => console.log(err.stack));
```
