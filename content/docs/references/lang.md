+++
title = "Language"
description = ""
date = 2021-05-01T08:20:00+00:00
updated = 2021-05-01T08:20:00+00:00
draft = false
weight = 500
sort_by = "weight"
template = "docs/page.html"

[extra]
lead = "For the current JoinBase's query language, an ANSI SQL compatible syntax has been implemented."
toc = true
top = false
+++

We also try to learn the great part of PostgreSQL/TimescaleDB, MySQL et. al. in the language side. If you feel that there are good representations, functions and designs in these dialects, don't hesitate to come to the community to give your suggestions.

Here, we mainly show the differences and extensions to the ANSI SQL syntax which needing attention. Feel free to ask help from us and the community. 

Finally, JoinBase is evolving rapidly. This language document is continuing to be improved based on the latest progress.

# Syntax
-------------------------

### Data Types

| Data Types  | Description | Support Status | 
| :----------- | :----------- | :--------------: | 
| Int8/Int16/Int32/Int64  | Integer  |✅|
| UInt8/UInt16/UInt32  | Unsigned integer  |✅| 
| Float32/Float64 | IEEE 754 float point number |✅|
| String| Variable-length UTF8 string |✅|
| Blob| Variable-length binary data block |✅|
| Date | 32-bit date, days since UNIX epoch 1970-01-01 |✅|
| DateTime | timestamp with an optional timezone, measured as a Unix epoch. The time zone is a string indicating the name of a time zone, either a time zone offset form "+XX:XX" or "-XX:XX", such as +07:30, or "Region/City" such as "America/New_York". If timezone is not provided, the server timezone (configurable via JoinBase conf file) will be used.|✅|
| Decimal | Signed fixed-point big numbers with precision and scale. For division least significant digits are discarded (not rounded). |✅|
|Boolean| boolean true or false |✅|
|FixedString| Fixed-length string of N bytes. |✅|
|Enum8<br/>Enum16| Dictionary type, by manually mapping a low cardinality type to another type. <br/> It is highly recommended to use this to boost the query performance if you have low cardinality String columns. |✅|

### Typed Literals

Literals for primary types like integer or string is well established. For advanced types, like datetime, the traditional implicit pure string representations are subtle and error-prone.

To avoid ambiguity and enhance the maintainability of the language, not like some SQL dialects, single quoted string literal in the JoinBase is just for the String type. On the contrary, we favor `typed literals` for advanced literal, that is: `type prefix + string representation of that type`.

| DateTime Types  | Example | 
| :-------------- | :----------- |
| DateTime | form#1: `datetime'2001-01-01 01:01:01'`<br/>(this form will use server defined time zone) <br/>form#2: `datetime'2001-01-01 01:01:01+08:00'`<br/>(this form use the time zone defined in the literal) <br/> <br/> `datetime` prefix can be reduced to `dt`, like `dt'2001-01-01 01:01:01'` for short. |
| Date | `date'2001-01-01'` <br/> for short, `d'2001-01-01'` |
| Time | `time'01:01:01'` <br/> for short, `t'01:01:01'` |
| FixedString | `fs(10)'abc123'`<br/> There the type prefix has a parameter for specifying the byte width of FixedString type. Because the FixedString data has a fixed length. The width parameter is used for padding its string representation. <br/> If the byte width is not provided, the length of its string representation will be used. That is, `fs'abc123'` is the short form of `fs(6)'abc123'`. See [more in the note](/docs/references/lang#note_fixedstring) below. |

Note 
* Not like Postgresql, JoinBase only have one timezone-wared DateTime type. It is recommended that you use the default timezone of JoinBase, which is the time zone of the JoinBase server. But you can specify the time zone in anywhere needed.
* Date and Time type are not related the time zones, it just plain date and time. If you need timezone wared behavior, you just use DateTime type.
* <a id="note_fixedstring"></a>FixedString data in the JoinBase is fixed length. For the shorter string representation, it is necessary to pad the representation to the fixed length (with zero). For the longer string representation, the excess trailing will be truncated away. To enhance the ergonomics, for the representation which you can not need to pad, you can omit the width parameter, like `fs'abc123'`. 


### Data Definition, Manipulation and Management
* create database 
```sql
CREATE DATABASE IF NOT EXISTS db_name
```
* <a id="create_table"></a>create table
```sql
CREATE TABLE IF NOT EXISTS [db_name.]table_name
(
    a Nullable(UInt32),
    b Int64
)
PARTITION BY toYYYYMM(ts)
```
| Item | Note |
| :----------- | :----------- |
|`Nullable` | A nullable column is explicitly defined with `Nullable` container type.|
|`PARTITION BY` | `PARTITION BY` clause is used to specify the partition key and partition expression of this table. Currently, only one column can be used as the `partition key` and only the specific functions can be used for the `partition expression`. All specific functions are listed below. It is planed to extend this feature to allow the complex expression combinations in the future. |

Allowed specific partition functions:

| Function Name | Description | Num of Arguments |
| :----------- | :----------- | :-----------     |
| | no function, a.k.a. just one raw column. | 1 |
|yyyy| get the year from a `Date` or `DateTime` value as 4-digit integer |1 |
|yyyymm| get the year, month from a `Date` or `DateTime` value as 6-digit integer |1 |
|yyyymmdd| get the year, month and day from a `Date` or `DateTime` value as 8-digit integer |1 |
|yyyymmdd10/yyyymmdd7/yyyymmdd3| variant of yyyymmdd with `DateTime` type, but the interval gap is 10/7/3-day |1 |
|ymdh| get the year, month, day, hour from a `DateTime` value as 10-digit integer |1 |
|ymdh2/ymdh4/ymdh6/ymdh12| variant of ymdh with `DateTime` type, but the interval gap is 2/4/6/12-hour |1|
|rem| reminder of an Int-like types|1|

NOTE

For more performance-ergonomic, all no-nullable types (this is the default case) in the `CREATE TABLE` statement has a default value: empty string for String, 0 for int-like and float-like, false for boolean, and unix epoch timestamp 0 (ISO 8601: 1970-01-01T00:00:00Z) for Date and DateTime. It is allow to use `default` constraint to change the default value if necessary. See more for [performance tunning](/docs/references/performance#Data_Type).

* show databases
```sql
SHOW DATABASES
```
* show tables
```sql
SHOW TABLES IN db_name
```
* show create table
```sql
SHOW CREATE TABLE [db_name.]table_name
```
* desc table
```sql
DESC TABLE [db_name.]table_name
```
* drop database 
```sql
DROP DATABASE IF EXISTS db_name
```
* drop table
```sql
DROP TABLE IF EXISTS [db_name.]table_name
```
* truncate table 
```sql
TRUNCATE TABLE IF EXISTS [db_name.]table_name
```
* insert into
```sql
INSERT INTO [db_name.]table VALUES (v11, v12, v13), (v21, v22, v23), ...
```
* use database
```sql
USE db_name
```

### Query

* general form
``` sql
SELECT expr_list
[FROM [db.]table]
[WHERE PARTS range_list/last_subclause]
[WHERE expr]
[GROUP BY expr_list]
[ORDER BY expr_list]
[LIMIT n]
```
| Item | Note |
| :----------- | :----------- |
|WHERE PARTS clause | This clause is an unique JoinBase extension to the standard SQL, related to the core concept of JoinBase - [`Partition`](/docs/references/concept#partition). <br/> <br/> This clause allows the user to explicitly specify the query partitions to reduce scanning dataset and accelerate query. *|
| Select clause | `select count(1) from table` is not currently supported. You can use `select count(some_column) from table` as the workaround. |

* Currently, WHERE PARTS supports two subclause forms:
    1. `range_list`. The `range_list` consists of one or more comma separated `range`s. A `range` is one of as follow:
    
        >  one number, like 123;

        >  half open number interval, start..end, start..end contains all values with start <= x < end, like 123..456;
        
        >  close number interval, start..=end, start..=end contains all values with start <= x <= end, like 123..=456;


    2. `last_subclause`. The `last_subclause` is used to specify the last number of partitions which you can query against without providing latest partition key because it is varying with time, like `last` or `last 10`. This form is very useful for querying latest data in the time based partitions. Note, `last` is just a short form to `last 1`.

# Function Reference
-------------------------

### Aggregation

| Item  |  Detail  | 
| :----------- | :----------- | 
| Function Name | count, max, min, avg, sum, all, any |
| Description | aggregation functions |
| Type  | aggregation |

### Math
| Item  |  Detail  | 
| :----------- | :----------- | 
| Function Name | abs, power, floor, ceil, ln, log10, log2, cos, acos, sin, asin, tan, atan |
| Description | math related functions |
| Type  | scalar |

### Primitive

| Item  |  Detail  | 
| :----------- | :----------- | 
| Function Name | int32, int64, uint32, uint64, float32, float64 |
| Description | explicit prompt other compatible types into this type |
| Type  | scalar |

### String
| Item  |  Detail  | 
| :----------- | :----------- | 
| Function Name | utf8_is_alpha, utf8_is_decimal, utf8_is_digit, utf8_is_lower, utf8_is_upper, utf8_is_numeric, utf8_is_space, string_is_ascii |
| Description | testing functions for String |
| Type  | scalar |


| Item  |  Detail  | 
| :----------- | :----------- | 
| Function Name | utf8_length, utf8_capitalize, utf8_lower, utf8_upper, utf8_reverse, utf8_ltrim, utf8_rtrim, utf8_trim, starts_with, ends_with, find_substring, count_substring |
| Description | String related functions |
| Type  | scalar |

### Blob(Binary)

| Item  |  Detail  | 
| :----------- | :----------- | 
| Function Name | binary_length, find_substring |
| Description |  Blob(Binary) related functions |
| Type  | scalar |

### DateTime 

| Item  |  Detail  | 
| :----------- | :----------- | 
| Function Name | day,day_of_week,day_of_year,hour,minute,month,quarter,second,week,year |
| Description |  DateTime related functions |
| Type  | scalar |

### Other Test

| Item  |  Detail  | 
| :----------- | :----------- | 
| Function Name | is_finite, is_inf, is_nan | |
| Description | test functions for Floats |
| Type  | scalar |

