+++
title = "JoinBase Tips Series #3: Importing CSV Datasets into JoinBase"
description = ""
date = 2023-03-06T12:00:00+00:00
updated = 2023-03-06T12:00:00+00:00
draft = false
template = "blog/page.html"

[taxonomies]
contact = ["jblchen"]

[extra]
lead = "In JoinBase 2023.03, we have added a high-performance local data import feature to the binary. The new importing feature is so fast that the csv files of 450-GB or 1-billion-record NYC taxi dataset can be imported into JoinBase in 2 minutes!"

+++

Before reading this article, it is recommended to read our previous Tips series to help you better understand:

[JoinBase Tips Series #1: Quick Start JoinBase](https://joinbase.io/blog/tips-1/)\
[JoinBase Tips Series #2: Using HTTP Interface in JoinBase](https://joinbase.io/blog/tips-2/)

# Basic knowledge

### What is CSV?

The full name of csv is Comma-Separated Values, which is a comma-separated value file format, also known as character-separated value, and is a plain text file used to store data. The csv file is composed of any number of records, one row is a row of the data table, and the fields of the generated data table are separated by half-width commas, and the file stores the tabular data (numbers and texts) in plain text. Plain text means that the file is a sequence of characters and contains no data that must be interpreted like binary numbers .

# Import CSV dataset

First, we prepare the CSV data file. In this test, the author manually created 2 CSV files (see the figure below), and friends can also choose to import different CSV data sets.

<div class="text-center">
<img src="/imgs/blog/tips_csv/test1.png" alt="test1" class="img-fluid">
<p align="center"><p/>
</div>

<div class="text-center">
<img src="/imgs/blog/tips_csv/test2.png" alt="test2" class="img-fluid">
<p align="center"><p/>
</div>

After preparing the CSV file, put the file into an empty folder so that JoinBase can read the data.

Next, we follow the teaching of the previous article, log in the user, create a database, and create a table.

<div class="text-center">
<img src="/imgs/blog/tips_csv/psql.png" alt="psql" class="img-fluid">
<p align="center"><p/>
</div>

<div class="text-center">
<img src="/imgs/blog/tips_csv/create.png" alt="create" class="img-fluid">
<p align="center"><p/>
</div>

Query table t and find that there is no data in the table.

<div class="text-center">
<img src="/imgs/blog/tips_csv/select.png" alt="select" class="img-fluid">
<p align="center"><p/>
</div>

Now start importing CSV data, press Ctrl+D to exit, use base import to import, and enter the following command to see how to use it:

```
./base data import --help
```

<div class="text-center">
<img src="/imgs/blog/tips_csv/help.png" alt="help" class="img-fluid">
<p align="center"><p/>
</div>

You can see that the parameters that must be entered in the command are:

1. The directory where the CSV file is locatedsurfaceuser
2. table
3. user

Other parameters will have default values. For example, the database defaults to default. If you want to modify other parameters, you can add them to the command.

Enter the command to import the CSV dataset.

```
base data import --input-url <INPUT_URL> --table <TABLE> --username <USERNAME>
```
<div class="text-center">
<img src="/imgs/blog/tips_csv/import.png" alt="import" class="img-fluid">
<p align="center"><p/>
</div>

When you see the results shown in the figure, it proves that the import was successful.

Finally, let's see the effect of importing CSV into JoinBase, logging in users, and querying table t.

<div class="text-center">
<img src="/imgs/blog/tips_csv/result.png" alt="result" class="img-fluid">
<p align="center"><p/>
</div>
As you can see, the CSV dataset was successfully imported into JoinBase!

# And one more thing

The CSV import feature of this article was introduced in JoinBase 2023.03, but at the time of writing, we have not officially released JoinBase 2023.03. In order to encourage more interested users to participate in the community, we provide the weekly integration release in the [kinds of communities](/community). Join us!

JoinBase provides a lot of value beyond the peers of this era. We sincerely invite more users to join our community. JoinBase can help you!

Download JoinBase: [Download](https://joinbase.io/products/) the full-featured version of JoinBase and SmartBase for free now , so that your AIoT digital capabilities will be one step ahead.

JoinBase Global Community: [Github Global Community](https://joinbase.io/community/)

JoinBase Chinese Community: [WeChat Group](https://joinbase.io/community/)

JoinBase Discord Server: [Discord Server](https://discord.com/invite/sqX6vfnURj)