
### Question 1
Write a SQL statement to find the total number of user sessions each page has each day.
(A user session is defined as continuous activity on a site where each activity is within 10 mins of each
other.)

```scala
val dataset = "dataset/pageview_activity_log.csv"
spark.read.options(Map("header"->"true","inferSchema"->"inferSchema")).csv(dataset).createOrReplaceTempView("pg_act_log")
spark.sql("""
with pv_log as (
    select 
        ID,
        User_ID,
        Page_ID, 
        Visit_date,
        Visit_time,
        /*Merge date and time as to timestamp type*/
        cast(cast(concat(date_format(Visit_date,'yyyy-MM-dd'),' ',Visit_time) as timestamp) as long) as visit_ts 
    from pg_act_log
),
pv_log_sess_no as (
    select 
        *,
        /*Mark first event in a session as 1*/
        case when 
            (visit_ts - lag(visit_ts,1)  over (partition by User_ID order by visit_ts))/60d <= 10 
        then 0
        else 1
        end as sess_no
    from pv_log
),
pv_log_sess_blk as (
    select 
        *,
        /*Generate session block per user*/
        sum(sess_no) over (partition by User_ID order by visit_ts) as sess_blk
    from pv_log_sess_no
),
pv_log_sess_stat as (
    select 
        *,
        /*Mark valid session as true given continuous events within 10 mins*/
        case when count(1) over (partition by User_ID,sess_blk) > 1 then true else false end as is_valid_sess
    from pv_log_sess_blk
)
select 
    Page_ID,
    date(Visit_date) as Visit_date,
    /*Number of sessions*/
    count(distinct concat(User_ID,sess_blk)) as numOfSessions,
    /*Number of valid sessions per page per day*/
    count(distinct case when is_valid_sess then concat(User_ID,sess_blk) else null end) as numOfValidSessions 
from pv_log_sess_stat 
group by 
Page_ID,
Visit_date
order by
Page_ID,
Visit_date
""").show(1000)

```
SQL Query Result:
```text
+-------+----------+-------------+------------------+
|Page_ID|Visit_date|numOfSessions|numOfValidSessions|
+-------+----------+-------------+------------------+
|     54|2018-01-01|            1|                 1|
|     54|2018-01-02|            1|                 1|
|     55|2018-01-01|            4|                 1|
|     55|2018-01-02|            2|                 1|
|     56|2018-01-02|            4|                 2|
|     57|2018-01-01|            2|                 1|
|     58|2018-01-01|            1|                 1|
+-------+----------+-------------+------------------+
```

### Question 2
Create a SQL query will show a list of products frequently purchased with the top 10 bestsellers.  
Reference:  [Quiver (QUantified Itemset discovery using a VERtical table layout) in two phases](https://pdfs.semanticscholar.org/f7b2/ae4d7ac413f50ba35a4495c16ac100666dd6.pdf)
* candidate generation and 
* support counting

```scala
val dataset2 = "dataset/SampleOrders.csv"
spark.read.options(Map("header"->"true","inferSchema"->"true")).csv(dataset2).createOrReplaceTempView("SampleOrders")

//Top 10 best sellers
spark.sql("""
with top10bestsellers as (
    select
        ProductID,
        count(1) as sell_count
    from SampleOrders
    group by ProductID
    order by sell_count desc
)
, top10bestsellers_rank as (
    select 
        *,
        dense_rank() over(order by sell_count desc) as rank 
    from top10bestsellers
)
select * from top10bestsellers_rank where rank <=10
""").show(1000)

//Association rules
```
*[To be completed]*

### Question 3
```scala
// key words we are interested in
val keyword = """"msg":"Request Number is"""
val logfile = "dataset/lighthouse-logs.log"
val rawDs = spark.read.textFile(logfile)
//Filter
val logDs = rawDF.filter(_.contains(keyword))
```
```sh
scala> logDs.take(10).foreach(println)
{"level":"info","msg":"Request Number is : 44, hence assigned to test for MS-003","time":"2018-03-14T10:48:24Z"}
{"level":"info","msg":"Request Number is : 83, hence assigned to control for MS-003","time":"2018-03-14T10:48:52Z"}
{"level":"info","msg":"Request Number is : 48, hence assigned to test for MS-002","time":"2018-03-14T10:49:25Z"}
{"level":"info","msg":"Request Number is : 79, hence assigned to control for MS-003","time":"2018-03-14T10:50:40Z"}
{"level":"info","msg":"Request Number is : 88, hence assigned to control for MS-003","time":"2018-03-14T10:51:31Z"}
{"level":"info","msg":"Request Number is : 94, hence assigned to control for MS-003","time":"2018-03-14T10:51:48Z"}
{"level":"info","msg":"Request Number is : 96, hence assigned to control for MS-003","time":"2018-03-14T10:51:49Z"}
{"level":"info","msg":"Request Number is : 28, hence assigned to test for MS-002","time":"2018-03-14T10:52:45Z"}
{"level":"info","msg":"Request Number is : 21, hence assigned to test for MS-003","time":"2018-03-14T10:52:54Z"}
{"level":"info","msg":"Request Number is : 76, hence assigned to control for MS-003","time":"2018-03-14T10:52:58Z"}
```
```scala
val logDF = spark.read.json(logDs)
logDF.createOrReplaceTempView("log")
//Using sql function extract field needed and register as a table.
spark.sql("""
    SELECT
        level,
        REGEXP_EXTRACT(msg, 'Request Number is : (\\d+),.*$', 1) as visitor,
        REGEXP_EXTRACT(msg, '.*assigned to (\\w+)\\sfor.*$', 1) as group,
        REGEXP_EXTRACT(msg, '.*for ([A-Z]+-\\d+)$', 1) as experiment,
        cast (time as timestamp) as log_dt
    FROM log
""").createOrReplaceTempView("logt")
```
```text
scala> spark.sql("select * from logt").show(5)
+-----+-------+-------+----------+-------------------+
|level|visitor|  group|experiment|             log_dt|
+-----+-------+-------+----------+-------------------+
| info|     44|   test|    MS-003|2018-03-14 18:48:24|
| info|     83|control|    MS-003|2018-03-14 18:48:52|
| info|     48|   test|    MS-002|2018-03-14 18:49:25|
| info|     79|control|    MS-003|2018-03-14 18:50:40|
| info|     88|control|    MS-003|2018-03-14 18:51:31|
+-----+-------+-------+----------+-------------------+
only showing top 5 rows
```
1. What are the total number users assigned to the “Test” and “Control” groups in each
experiment?
```scala
spark.sql("""
    select 
        experiment,
        count(distinct visitor) as users
    from logt
    group by experiment
""").show
```
```text
+----------+-----+
|experiment|users|
+----------+-----+
|    MS-003|  100|
|    MS-002|  100|
|    MS-004|   86|
+----------+-----+
```
2. Which day had the highest number of user group assignments per experiment?
```scala
spark.sql("""
with assign_all_day as(
    select 
        experiment,
        date(log_dt) as log_date,
        count(visitor) as assignments
    from logt
    group by 
    experiment,
    date(log_dt)
),
ass_with_rank as (
    select 
        *,
        dense_rank() over (partition by experiment order by assignments desc) as r
    from assign_all_day
)
select experiment,log_date,assignments from ass_with_rank where r = 1
""").show
```
```text
+----------+----------+-----------+
|experiment|  log_date|assignments|
+----------+----------+-----------+
|    MS-003|2018-03-15|       2783|
|    MS-002|2018-03-15|        304|
|    MS-004|2018-03-15|        125|
+----------+----------+-----------+
```