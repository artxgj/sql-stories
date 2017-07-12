# Amazon's Acquisition of  Whole Foods
On June 16, 2017, Bloomberg [reported](https://www.bloomberg.com/news/articles/2017-06-16/amazon-to-acquire-whole-foods-in-13-7-billion-bet-on-groceries) that Amazon is acquiring Whole Foods.

This practice set builds on the document [Highs, Lows, Averages, Moving Averages, Etc. ](https://github.com/artxgj/sql-stories/blob/master/stock-market/highs-lows-averages-windows-sql-tutorial.md) and  covers:

* INTERVAL function
* cast function
* row window function
* lag window function


## Amazon's Stock Performance One Week Leading To June 16 And The Day After ##


Use the **INTERVAL** function to calculate these two dates.
```sql
SELECT '2017-06-16'::DATE - INTERVAL '7 DAYS' AS week_before,
       '2017-06-16'::DATE + INTERVAL '1 DAYS' AS day_after
;
```
|week_before|day_after|
|:---------:|:-------:|
|2017-06-09 00:00:00.000000|2017-06-17 00:00:00.000000|

The type of both dates is TIMESTAMP. If the time portion of the dates is not needed, use **cast** to remove the time.

```SQL
SELECT cast('2017-06-16'::DATE - INTERVAL '7 DAYS' AS date) AS week_before,
       cast('2017-06-16'::DATE + INTERVAL '1 DAYS' AS date) AS day_after
;
```

|week_before|day_after|
|:---------:|:-------:|
|2017-06-09|2017-06-17|


Here's the query to retrieve
```SQL
SELECT date, open, high, low, close, volume
FROM
    stock.historical_data
WHERE
  date BETWEEN '2017-06-16'::DATE - INTERVAL '7 DAYS' AND '2017-06-16'::DATE + INTERVAL '1 DAYS'
    and
  ticker = (SELECT id FROM stock.ticker WHERE symbol='AMZN')
ORDER BY date
;
```

|date|open|high|low|close|volume|
|:--:|:--:|:--:|:-:|:---:|:----:|
|2017-06-09|1012.50|1012.99|927.00|978.31|7647692|
|2017-06-12|967.00|975.95|945.00|964.91|9447233|
|2017-06-13|977.99|984.50|966.10|980.79|4580011|
|2017-06-14|988.59|990.34|966.71|976.47|3974900|
|2017-06-15|958.70|965.73|950.86|964.17|5373865|
|2017-06-16|996.00|999.75|982.00|987.71|11472662|

June 16 was a Friday. The US stock market doesn't trade on weekends and holidays. The results of the query end with June 16's stock data.

Amazon's trade volume spiked and its stock price went up by 2.44%.


The results show that Amazon's trading volume went up on the day the acquisition-deal was reported. The results also
don't include weekend-dates. The US stock market is closed on weekends.

#### The row window function ####

```SQL
SELECT row_number() OVER (ORDER BY date) AS row_id, date, close
FROM
    stock.historical_data
WHERE ticker = (SELECT id
                FROM stock.ticker
                WHERE symbol = 'AMZN')
LIMIT 3;
```
|row_id|date|open|high|low|close|volume|
|:-----:|:--:|:--:|:--:|:-:|:---:|:----:|
|1|2016-07-11|750.00|755.90|747.00|753.78|3195272
|2|2016-07-12|756.86|757.34|740.33|748.21|5623657
|3|2016-07-13|746.76|756.87|741.25|742.63|4142265

We can use the row_id window function and define a week as 5 days to query the  **stock.historical** table, and retrieve the desired Amazon stock data results.

```SQL
WITH t1 AS (
  SELECT date, open, high, low, close, volume, row_number() OVER (ORDER BY date) AS row_id
  FROM
    stock.historical_data
  WHERE ticker = (SELECT id
                  FROM stock.ticker
                  WHERE symbol = 'AMZN')
),
t2 AS (
  SELECT row_id
  FROM
    t1
  WHERE t1.date = '2017-06-16'
)

SELECT t1.date, t1.open, t1.high, t1.low, t1.close, t1.volume
FROM t1, t2
WHERE
  t1.row_id BETWEEN (t2.row_id-5) AND (t2.row_id+1)
;
```

|date|open|high|low|close|volume|
|:--:|:--:|:--:|:-:|:---:|:----:|
|2017-06-09|1012.50|1012.99|927.00|978.31|7647692|
|2017-06-12|967.00|975.95|945.00|964.91|9447233|
|2017-06-13|977.99|984.50|966.10|980.79|4580011|
|2017-06-14|988.59|990.34|966.71|976.47|3974900|
|2017-06-15|958.70|965.73|950.86|964.17|5373865|
|**2017-06-16**|996.00|999.75|982.00|987.71|11472662|
|2017-06-19|1017.00|1017.00|989.90|995.17|5043408|

The stock price went up on June 19 but the trade volume dropped! June 19th's trade volume was lower than June 15th's, the day before the Whole Foods acquisition was announced

At this point, you're probably aghast over the madness associated with these queries. You're shaking your head and saying, just write this simple query to achieve the same results:

```SQL
SELECT date, open, high, low, close, volume
FROM
  stock.historical_data
WHERE
  ticker = (SELECT id FROM stock.ticker WHERE symbol = 'AMZN') AND
  date BETWEEN '2017-06-09' AND '2017-06-19'
ORDER BY date
;
```

## How did Whole Foods, Walmart and Costco do during the same period? ##

```SQL
WITH retailers AS (
  SELECT id AS ticker, symbol
  FROM
    stock.ticker
  WHERE
    symbol IN (
      'WFM',
      'COST',
      'WMT'
    )
)
SELECT symbol, t.date, t.open, t.high, t.low, t.close, t.volume
FROM
  retailers r
    INNER JOIN
  (
    SELECT *
    FROM
      stock.historical_data
    WHERE
      date BETWEEN '2017-06-09' AND '2017-06-19'
  ) t ON r.ticker = t.ticker
ORDER BY symbol, date
```

|symbol|date|open|high|low|close|volume|
|:----:|:--:|:--:|:--:|:-:|:---:|:----:|
|COST|2017-06-09|181.71|181.93|179.92|180.38|2167587|
|COST|2017-06-12|179.58|180.87|178.79|179.64|2395166|
|COST|2017-06-13|179.90|180.79|179.03|180.51|1745411|
|COST|2017-06-14|180.83|181.96|180.23|181.67|1440439|
|COST|2017-06-15|180.39|181.33|178.37|180.06|1754352|
|COST|**2017-06-16**|170.40|170.60|165.00|167.11|24232985|
|COST|2017-06-19|167.05|167.38|162.39|164.34|13809120|
|WFM|2017-06-09|35.44|35.88|35.25|35.73|2447638|
|WFM|2017-06-12|35.69|35.97|35.30|35.32|3698236|
|WFM|2017-06-13|35.24|35.76|35.06|35.62|2568526|
|WFM|2017-06-14|35.61|35.63|35.20|35.45|1484903|
|WFM|2017-06-15|34.85|34.97|32.96|33.06|8477761|
|WFM|**2017-06-16**|42.18|43.45|41.75|42.68|128832883|
|WFM|2017-06-19|42.95|43.64|42.88|43.22|20804994|
|WMT|2017-06-09|79.03|79.56|78.72|79.42|9405124|
|WMT|2017-06-12|79.40|80.37|78.84|79.24|10410592|
|WMT|2017-06-13|79.21|79.57|78.89|79.52|5528030|
|WMT|2017-06-14|79.52|80.04|79.26|79.90|5006516|
|WMT|2017-06-15|79.18|79.30|77.76|78.91|11297169|
|WMT|**2017-06-16**|73.95|75.50|73.29|75.24|56233027|
|WMT|2017-06-19|75.38|76.01|74.52|75.50|16095073|

All three companies' trade volume went up on June 16, but Costco and Walmart's respective stock price went down on that day and on June 19.


## The lag window function ##

```SQL                                                         
SELECT date,
  lag(date, 5) OVER (PARTITION BY ticker ORDER BY date) AS five_trading_days_ago,
  lag(date, -1) OVER (PARTITION BY ticker ORDER BY date)  AS next_trading_day
FROM
  stock.historical_data
LIMIT 7;
;
```                                                        
|date|five_trading_days_ago|next_trading_day|
|:--:|:-------------------:|:--------------:|
|2016-07-11|<null>|2016-07-12|
|2016-07-12|<null>|2016-07-13|
|2016-07-13|<null>|2016-07-14|
|2016-07-14|<null>|2016-07-15|
|2016-07-15|<null>|2016-07-18|
|2016-07-18|2016-07-11|2016-07-19|
|2016-07-19|2016-07-12|2016-07-20|

The first trade date in the stock.historical_data table is July 11, 2016. Therefore the value of five_trading_days_ago for July 11, 2016 is NULL.
