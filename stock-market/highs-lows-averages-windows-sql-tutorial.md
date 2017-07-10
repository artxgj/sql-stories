# Highs, Lows, Average And Other Contrived Stock-related Queries #

This is my SQL tutorial-by-examples (contrived examples). I cover subqueries, aggregation, common table expression, window functions and materialized views.

## The Arbitrary Prime Number Stock Index (APNSI) ##

```SQL
SELECT t.id as ticker_id, t.symbol AS ticker_symbol, t.exchange AS exchange_id, e.abbr AS exchange
FROM
  stock.ticker t
    INNER JOIN
  stock.exchange e ON t.exchange=e.id
ORDER BY ticker_symbol;
```
The APNSI has 17 stocks.

| ticker_id | ticker_symbol | exchange_id | exchange |
|:----------|:--------------|:------------|:---------|
| 20        | AAPL          | 2           | NASDAQ   |
| 25        | AMD           | 2           | NASDAQ   |
| 29        | AMZN          | 2           | NASDAQ   |
| 33        | BABA          | 1           | NYSE     |
| 21        | COST          | 2           | NASDAQ   |
| 26        | DPZ           | 1           | NYSE     |
| 30        | FB            | 2           | NASDAQ   |
| 34        | GOOG          | 2           | NASDAQ   |
| 22        | INTC          | 2           | NASDAQ   |
| 27        | KO            | 1           | NYSE     |
| 31        | MSFT          | 2           | NASDAQ   |
| 35        | NFLX          | 2           | NASDAQ   |
| 23        | NKE           | 1           | NYSE     |
| 28        | NVDA          | 2           | NASDAQ   |
| 32        | PEP           | 1           | NYSE     |
| 36        | WFM           | 2           | NASDAQ   |
| 24        | WMT           | 1           | NYSE     |

## June 2017 average closing price (rounded to 2 decimal places) of each   APNSI stock ##

```SQL
SELECT t.symbol, round(jun.avg_close, 2) as avg_close_201706
FROM
  stock.ticker t
    INNER JOIN
  (
    SELECT h.ticker, AVG(h.close) as avg_close
    FROM
      stock.historical_data h
    WHERE
      h.date BETWEEN '2017-06-01' AND '2017-06-30'
    GROUP BY h.ticker
  ) jun ON t.id = jun.ticker
ORDER by t.symbol;
```
| symbol | avg_close_201706 |
|:-------|:-----------------|
| AAPL   | 147.83           |
| AMD    | 12.47            |
| AMZN   | 990.44           |
| BABA   | 136.55           |
| COST   | 171.08           |
| DPZ    | 213.81           |
| FB     | 152.08           |
| GOOG   | 953.77           |
| INTC   | 35.17            |
| KO     | 45.36            |
| MSFT   | 70.52            |
| NFLX   | 156.51           |
| NKE    | 53.22            |
| NVDA   | 151.22           |
| PEP    | 116.78           |
| WFM    | 38.88            |
| WMT    | 77.55            |

## Forget APNSI, I only care about AMFANG's June 2017 average closing price ##

Apple, Microsoft, Facebook, Amazon, Netflix and Google (aka Alphabet) lets me contrive an excuse to practice writing a correlated subquery and common table expression.

```SQL
WITH amfang AS (
  SELECT id, symbol
  FROM
    stock.ticker
  WHERE symbol IN (
    'AAPL',
    'MSFT',
    'FB',
    'AMZN',
    'NFLX',
    'GOOG'
  )
)
SELECT amfang.symbol,
  (
    SELECT ROUND(AVG(h.close), 2)
    FROM
      stock.historical_data h
    WHERE
      h.date BETWEEN '2017-06-01' AND '2017-06-30' AND
      h.ticker=amfang.id
    GROUP BY h.ticker
  ) AS avg_close_201706
FROM
  amfang;
```

The **amfang** common table expression is used by the correlated subquery to calculate **avg_close_201706**.

| symbol | avg_close_201706 |
|:-------|:-----------------|
| AAPL   | 147.83           |
| AMZN   | 990.44           |
| FB     | 152.08           |
| MSFT   | 70.52            |
| GOOG   | 953.77           |
| NFLX   | 156.51           |

## The highest traded price and lowest traded price of the APNSI stocks that trade in the NYSE  ##

Instead of using a common table expression to generate the list of NYSE stocks, use a materialized view.

```SQL
CREATE MATERIALIZED VIEW stock.nyse_stock (
  ticker
) AS (
  SELECT t.id as ticker_id
  from stock.ticker t
  inner JOIN stock.exchange x on t.exchange = x.id
  where x.abbr='NYSE'
);
```
The ticker ids of nyse_stock are:

| ticker |
|:-------|
| 23     |
| 24     |
| 6      |
| 27     |
| 32     |
| 33     |

The highest traded price and lowest traded price:

```SQL
SELECT dense_rank() OVER (ORDER BY h.volume DESC) AS rank,
  h.date,
  h.volume,
  h.open,
  h.high,
  h.low,
  h.close
FROM
  stock.historical_data h
WHERE
  h.ticker = 23
LIMIT 23;

```
| symbol | highest_price | lowest_price |
|:-------|:--------------|:-------------|
| BABA   | 148.29        | 79.24        |
| DPZ    | 221.58        | 134.22       |
| KO     | 46.06         | 39.88        |
| NKE    | 60.33         | 49.01        |
| PEP    | 118.24        | 98.5         |
| WMT    | 80.48         | 65.28        |

Domino's Pizza (DPZ) is included in the APNSI index  because according to [Quartz](https://qz.com/938620/dominos-dpz-stock-has-outperformed-google-goog-facebook-fb-apple-aapl-and-amazon-amzn-this-decade/), DPZ outperformed AGAF (Apple, Google, Amazon and Facebook) this decade.

Note: The data in the stock.historical_data table span from July 11, 2016 to July 7, 2011.


## A Window To Nike's Performance ##

In this section, I practice using SQL's window function dense_rank to rank Nike's performance by trading volume and then limiting the results to 23.

In my stock.ticker table, the id of Nike happened to be 23. What's the big deal with no. 23? Aside from 23 being a prime number, retired basketball player Michael Jordan wore no. 23 (yes, he did have a short fling with no.45). To those too young to know who Michael Jordan is, he is the name behind Nike's Jordan Brand.

Here is David Rubinstein's brief and terrific [interview](https://www.bloomberg.com/news/videos/2017-06-28/the-david-rubenstein-show-phil-knight-video) with Nike CEO Phil Knight.

```SQL
SSELECT dense_rank() OVER (ORDER BY volume DESC) AS rank,
  date,
  volume,
  open,
  high,
  low,
  close
FROM
  stock.historical_data
WHERE
  ticker = 23
LIMIT 23;
```
| rank | date       | volume   | open  | high  | low   | close |
|:-----|:-----------|:---------|:------|:------|:------|:------|
| 1    | 2017-06-30 | 46552954 | 56.60 | 59.71 | 56.50 | 59.00 |
| 2    | 2017-03-22 | 37413372 | 54.76 | 55.00 | 53.76 | 53.92 |
| 3    | 2016-09-28 | 33213008 | 54.60 | 55.00 | 52.80 | 53.25 |
| 4    | 2017-06-16 | 25725453 | 51.75 | 51.84 | 50.79 | 51.10 |
| 5    | 2017-03-23 | 23848344 | 54.61 | 55.55 | 54.52 | 55.37 |
| 6    | 2016-12-21 | 23236380 | 52.90 | 53.35 | 51.55 | 52.30 |
| 7    | 2017-05-18 | 22576489 | 51.97 | 52.08 | 51.30 | 51.68 |
| 8    | 2017-05-19 | 20047766 | 51.00 | 52.11 | 50.81 | 51.77 |
| 9    | 2017-06-02 | 18511169 | 52.70 | 53.01 | 52.36 | 52.98 |
| 10   | 2017-05-17 | 18341473 | 52.39 | 52.87 | 51.80 | 51.80 |
| 11   | 2016-09-27 | 17945212 | 54.25 | 55.54 | 53.90 | 55.34 |
| 12   | 2016-10-31 | 17931262 | 50.88 | 51.15 | 50.00 | 50.18 |
| 13   | 2016-09-29 | 16993949 | 52.92 | 53.58 | 52.12 | 52.16 |
| 14   | 2017-07-05 | 16166954 | 58.24 | 58.29 | 57.51 | 57.56 |
| 15   | 2017-06-15 | 16041068 | 54.00 | 54.05 | 52.73 | 52.90 |
| 16   | 2016-08-19 | 15987096 | 57.40 | 59.14 | 57.25 | 58.90 |
| 17   | 2016-12-20 | 15984083 | 51.06 | 51.99 | 50.75 | 51.79 |
| 18   | 2017-03-21 | 15269827 | 58.78 | 59.00 | 57.72 | 58.01 |
| 19   | 2016-10-25 | 14975302 | 50.97 | 51.44 | 50.71 | 51.05 |
| 20   | 2017-02-10 | 14973383 | 55.63 | 56.47 | 55.63 | 56.22 |
| 21   | 2017-06-29 | 14801866 | 53.33 | 53.63 | 52.99 | 53.17 |
| 22   | 2017-05-16 | 14562678 | 52.37 | 53.38 | 52.12 | 52.78 |
| 23   | 2017-03-24 | 14438573 | 55.29 | 56.64 | 55.12 | 56.36 |

Since the likelihood of getting ties on Nike's trading volume seems small, I could have just used the window function **row** instead of **dense_rank** to associate each resulting row with an ordinal number. SQL has another ranking window function called **rank**.

Check out programmerinterview.com's  [blog](http://www.programmerinterview.com/index.php/database-sql/rank-versus-dense_rank/) for an  explanation  on the difference between **rank** and **dense_rank**.
