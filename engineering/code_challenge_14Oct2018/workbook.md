
### Question 1
Write an SQL statement to find the total number of user sessions each page has each day.
(A user session is defined as continuous activity on a site where each activity is within 10 mins of each
other.)

```scala
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
    from df
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