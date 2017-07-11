# Highs, Lows, Averages, Moving Averages, Etc. #

This practice set covers:
* subqueries
* aggregation functions with GROUP BY clause
* common table expressions
* dense_rank and rank window functions
* materialized view.

## The Arbitrary Prime Number Portfolio (APNP) ##

The APNP has 17 stocks.

**stock.ticker table**

| id | symbol | exchange |
|:---|:-------|:--------:|
| 20 | AAPL   |    2     |
| 21 | COST   |    2     |
| 22 | INTC   |    2     |
| 23 | NKE    |    1     |
| 24 | WMT    |    1     |
| 25 | AMD    |    2     |
| 26 | DPZ    |    1     |
| 27 | KO     |    1     |
| 28 | NVDA   |    2     |
| 29 | AMZN   |    2     |
| 30 | FB     |    2     |
| 31 | MSFT   |    2     |
| 32 | PEP    |    1     |
| 33 | BABA   |    1     |
| 34 | GOOG   |    2     |
| 35 | NFLX   |    2     |
| 36 | WFM    |    2     |

**stock.exchange table**

| id | name                                                            | abbr   | open_local_time | close_local_time |
|:---|:----------------------------------------------------------------|:-------|:---------------:|:----------------:|
| 1  | New York Stock Exchange                                         | NYSE   |    09:30:00     |     16:00:00     |
| 2  | National Association of Securities Dealers Automated Quotations | NASDAQ |    09:30:00     |     16:00:00     |
| 3  | Japan Exchange Group, Inc. 株式会社日本取引所グループ           | JPX    |    09:00:00     |     15:00:00     |
| 4  | Shenzhen Stock Exchange 深圳证券交易所                          | SZSE   |    09:30:00     |     15:00:00     |
| 5  | Shanghai Stock Exchange 上海证券交易所                          | SSE    |    09:30:00     |     15:00:00     |
| 6  | German Stock Exchange                                           | FSX    |    08:00:00     |     20:00:00     |
| 7  | Philippine Stock Exchange                                       | PSE    |    09:30:00     |     15:30:00     |

**stock.historical_data table**

It has historical data from 2016-07-11 to 2017-07-07.

| id   | ticker |    date    | open   |  high  |  low   | close  |  volume  |
|:-----|:------:|:----------:|:-------|:------:|:------:|:------:|:--------:|
| 1    |   20   | 2017-07-07 | 142.90 | 144.75 | 142.90 | 144.18 | 19201712 |
| 1005 |   21   | 2017-07-07 | 157.36 | 157.55 | 154.09 | 154.11 | 7688368  |
| 2009 |   22   | 2017-07-07 | 33.70  | 34.12  | 33.70  | 33.88  | 18304460 |
| 3013 |   23   | 2017-07-07 | 57.40  | 58.08  | 57.03  | 57.98  | 8145436  |
| 4017 |   24   | 2017-07-07 | 75.65  | 75.82  | 75.05  | 75.33  | 5307064  |
| 252  |   25   | 2017-07-07 | 13.27  | 13.74  | 13.18  | 13.36  | 88392137 |
| 1256 |   26   | 2017-07-07 | 209.23 | 213.75 | 209.23 | 212.32 |  444206  |
| 2260 |   27   | 2017-07-07 | 44.47  | 44.52  | 44.24  | 44.39  | 9566044  |
| 3264 |   28   | 2017-07-07 | 145.78 | 147.50 | 144.85 | 146.76 | 16374302 |
| 503  |   29   | 2017-07-07 | 969.55 | 980.11 | 969.14 | 978.76 | 2643387  |
| 1507 |   30   | 2017-07-07 | 149.25 | 151.99 | 149.19 | 151.44 | 13615931 |
| 2511 |   31   | 2017-07-07 | 68.70  | 69.84  | 68.70  | 69.46  | 16878317 |
| 3515 |   32   | 2017-07-07 | 115.41 | 115.66 | 114.83 | 115.51 | 3972488  |
| 754  |   33   | 2017-07-07 | 142.65 | 143.38 | 141.83 | 142.43 | 8046241  |
| 1758 |   34   | 2017-07-07 | 908.85 | 921.54 | 908.85 | 918.59 | 1637785  |
| 2762 |   35   | 2017-07-07 | 146.65 | 150.75 | 146.65 | 150.18 | 5561263  |
| 3766 |   36   | 2017-07-07 | 41.97  | 42.20  | 41.96  | 42.00  | 6227419  |


## June 2017 average closing price (rounded to 2 decimal places) of each APNP stock ##

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
|:-------|:----------------:|
| AAPL   |      147.83      |
| AMD    |      12.47       |
| AMZN   |      990.44      |
| BABA   |      136.55      |
| COST   |      171.08      |
| DPZ    |      213.81      |
| FB     |      152.08      |
| GOOG   |      953.77      |
| INTC   |      35.17       |
| KO     |      45.36       |
| MSFT   |      70.52       |
| NFLX   |      156.51      |
| NKE    |      53.22       |
| NVDA   |      151.22      |
| PEP    |      116.78      |
| WFM    |      38.88       |
| WMT    |      77.55       |

## AMFANG's June 2017 average closing price ##

Apple, Microsoft, Facebook, Amazon, Netflix and Google let me contrive an example of writing a correlated subquery with a common table expression.

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
|:-------|:----------------:|
| AAPL   |      147.83      |
| AMZN   |      990.44      |
| FB     |      152.08      |
| MSFT   |      70.52       |
| GOOG   |      953.77      |
| NFLX   |      156.51      |

## The highest-traded price and lowest-traded price of the APNP stocks that trade in the NYSE  ##

Create a materialized view to store the list of NYSE stocks in the portfolio.

```SQL
CREATE MATERIALIZED VIEW stock.nyse_stock (
  ticker
) AS (
  SELECT t.id as ticker_id
  FROM 
    stock.ticker t
      INNER JOIN 
    stock.exchange x on t.exchange = x.id
  WHERE x.abbr='NYSE'
);
```
The ticker ids of nyse_stock are:

| ticker |
|:------:|
|   23   |
|   24   |
|   6    |
|   27   |
|   32   |
|   33   |

The highest-traded price and lowest traded price are retrieved using the MAX and MIN aggregate functions:

```SQL
SELECT symbol, highest_price, lowest_price
FROM
  (
    SELECT
      ticker,
      MAX(high) AS highest_price,
      MIN(low)  AS lowest_price
    FROM
      stock.historical_data
    WHERE
      ticker IN (
        SELECT ticker
        FROM
          stock.nyse_stock
      )
    GROUP BY ticker
  ) nyse_hilo
    INNER JOIN
  stock.ticker t ON nyse_hilo.ticker = t.id
ORDER BY symbol;
```
| symbol | highest_price | lowest_price |
|:-------|:-------------:|:------------:|
| BABA   |    148.29     |    79.24     |
| DPZ    |    221.58     |    134.22    |
| KO     |     46.06     |    39.88     |
| NKE    |     60.33     |    49.01     |
| PEP    |    118.24     |     98.5     |
| WMT    |     80.48     |    65.28     |

Domino's Pizza (DPZ) is included in the APNP index  because according to [Quartz](https://qz.com/938620/dominos-dpz-stock-has-outperformed-google-goog-facebook-fb-apple-aapl-and-amazon-amzn-this-decade/), DPZ outperformed AFGA (Apple, Facebook, Google and Amazon) this decade.

## A Window To Nike's Performance ##

In this section, I practice using SQL's dense_rank window function to rank Nike's performance by trading volume and then limiting the results to 23.

In my stock.ticker table, the id of Nike happens to be 23. What's the big deal with no. 23? Aside from 23 being a prime number, retired basketball player Michael Jordan wore no. 23 (Trivia: He had a short fling with jersey no. 45). To those too young to know who Michael Jordan is, he is the name behind Nike's Jordan Brand.

My arbitrary reason for adding Nike to this tutorial's portfolio came from watching David Rubinstein's brief and terrific [interview](https://www.bloomberg.com/news/videos/2017-06-28/the-david-rubenstein-show-phil-knight-video) with Nike CEO Phil Knight.

```SQL
SELECT dense_rank() OVER (ORDER BY volume DESC) AS rank,
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
| rank |    date    |  volume  | open  | high  |  low  | close |
|:-----|:----------:|:--------:|:-----:|:-----:|:-----:|:-----:|
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


## The Difference Between dense_rank and rank ##

Whole Foods Market's five-lowest ranked closings using the dense_rank window function.

```SQL
SELECT date, close, ranking
FROM
  (SELECT
     date,
     close,
     dense_rank() OVER (ORDER BY close) AS ranking
   FROM
     stock.historical_data
   WHERE ticker = 36  -- WFM's id in the stock.ticker table --
  ) r
WHERE ranking <= 5
```
|    date    | close | ranking |
|:----------:|:-----:|:-------:|
| 2016-10-05 | 27.96 |    1    |
| 2016-09-14 | 28.00 |    2    |
| 2016-09-13 | 28.00 |    2    |
| 2016-09-29 | 28.01 |    3    |
| 2016-10-04 | 28.03 |    4    |
| 2016-10-21 | 28.08 |    5    |


Whole Foods Market's five-lowest ranked closings using the rank window function.
```SQL
SELECT date, close, ranking
FROM
  (SELECT
     date,
     close,
     rank() OVER (ORDER BY close) AS ranking
   FROM
     stock.historical_data
   WHERE ticker = 36  -- WFM's id in the stock.ticker table --
  ) r
WHERE ranking <= 5
```

| date       | close | ranking |
|:-----------|:------|:-------:|
| 2016-10-05 | 27.96 |    1    |
| 2016-09-14 | 28.00 |    2    |
| 2016-09-13 | 28.00 |    2    |
| 2016-09-29 | 28.01 |    4    |
| 2016-10-04 | 28.03 |    5    |


## The historical data of each APNP company's five lowest-ranked closing days ##

Practice using a windowing function with PARTITION.

```SQL
SELECT symbol, date, volume, open, high, low, close, ranking
FROM
  (
    SELECT
      ticker,
      date,
      volume,
      open,
      high,
      low,
      close,
      dense_rank() OVER (PARTITION BY ticker ORDER BY close) AS ranking
    FROM
      stock.historical_data
  ) AS low5_close
    INNER JOIN
  stock.ticker t ON  low5_close.ticker = t.id
WHERE ranking <= 5
ORDER BY symbol, ranking, date DESC;
```

| symbol   |    date    |  volume  |  open  |  high  |  low   |   close    | ranking |
|:---------|:----------:|:--------:|:------:|:------:|:------:|:----------:|:-------:|
| AAPL     | 2016-07-26 | 56239822 | 96.82  | 97.97  | 96.42  |   96.67    |    1    |
| AAPL     | 2016-07-13 | 25892171 | 97.41  | 97.67  | 96.84  |   96.87    |    2    |
| AAPL     | 2016-07-11 | 23794945 | 96.75  | 97.65  | 96.73  |   96.98    |    3    |
| AAPL     | 2016-07-25 | 40382921 | 98.25  | 98.84  | 96.92  |   97.34    |    4    |
| AAPL     | 2016-07-12 | 24167463 | 97.17  | 97.70  | 97.12  |   97.42    |    5    |
| AMD      | 2016-07-11 | 21027948 |  5.13  |  5.19  |  5.00  |    5.01    |    1    |
| AMD      | 2016-07-13 | 14032518 |  5.14  |  5.19  |  5.04  |    5.09    |    2    |
| **AMD**  | 2016-07-15 | 14219263 |  5.20  |  5.20  |  5.10  |  **5.14**  |  **3**  |
| **AMD**  | 2016-07-12 | 20832476 |  5.01  |  5.17  |  5.01  |  **5.14**  |  **3**  |
| AMD      | 2016-07-14 | 20050141 |  5.15  |  5.24  |  5.06  |    5.17    |    4    |
| AMD      | 2016-07-21 | 40242023 |  5.43  |  5.45  |  5.10  |    5.22    |    5    |
| AMZN     | 2016-11-14 | 7321344  | 745.51 | 746.00 | 710.10 |   719.07   |    1    |
| AMZN     | 2016-07-15 | 3121385  | 746.55 | 746.55 | 734.05 |   735.44   |    2    |
| AMZN     | 2016-07-26 | 2529692  | 742.71 | 743.13 | 732.75 |   735.59   |    3    |
| AMZN     | 2016-07-18 | 2954914  | 735.49 | 741.60 | 728.72 |   736.07   |    4    |
| AMZN     | 2016-07-27 | 2913134  | 737.97 | 740.94 | 733.86 |   736.67   |    5    |
| BABA     | 2016-07-13 | 10739182 | 81.83  | 81.88  | 80.37  |   80.57    |    1    |
| BABA     | 2016-07-15 | 8919868  | 81.78  | 82.49  | 80.96  |   81.25    |    2    |
| BABA     | 2016-07-11 | 17417457 | 79.33  | 81.90  | 79.24  |   81.46    |    3    |
| **BABA** | 2016-07-14 | 9361454  | 81.18  | 82.24  | 80.86  | **81.74**  |  **4**  |
| **BABA** | 2016-07-12 | 15294115 | 81.79  | 82.88  | 81.51  | **81.74**  |  **4**  |
| BABA     | 2016-07-29 | 8709279  | 83.37  | 83.42  | 81.94  |   82.48    |    5    |
| COST     | 2016-11-04 | 2702134  | 143.00 | 145.00 | 142.11 |   142.24   |    1    |
| COST     | 2016-11-07 | 3010110  | 143.38 | 143.66 | 142.75 |   143.54   |    2    |
| COST     | 2016-11-03 | 2168211  | 146.70 | 146.70 | 144.14 |   144.45   |    3    |
| COST     | 2016-11-08 | 3506032  | 143.89 | 146.63 | 143.80 |   146.09   |    4    |
| COST     | 2016-11-02 | 2260450  | 146.43 | 147.34 | 146.12 |   146.27   |    5    |
| DPZ      | 2016-07-13 |  582183  | 135.24 | 136.37 | 135.00 |   135.42   |    1    |
| **DPZ**  | 2016-07-19 |  743973  | 135.93 | 136.18 | 135.09 | **135.55** |  **2**  |
| **DPZ**  | 2016-07-18 |  555604  | 135.97 | 136.18 | 134.78 | **135.55** |  **2**  |
| DPZ      | 2016-07-14 |  506422  | 136.32 | 136.66 | 135.22 |   135.64   |    3    |
| DPZ      | 2016-07-12 |  641317  | 136.04 | 136.47 | 135.50 |   135.65   |    4    |
| DPZ      | 2016-07-15 |  666637  | 135.88 | 136.27 | 134.92 |   135.70   |    5    |
| FB       | 2016-12-30 | 18684106 | 116.60 | 116.83 | 114.77 |   115.05   |    1    |
| FB       | 2016-11-14 | 51377040 | 119.13 | 119.13 | 113.55 |   115.08   |    2    |
| FB       | 2016-12-01 | 43276994 | 118.38 | 118.45 | 114.00 |   115.10   |    3    |
| FB       | 2016-12-02 | 25070364 | 115.11 | 116.48 | 114.30 |   115.40   |    4    |
| FB       | 2016-11-16 | 32397947 | 114.48 | 117.88 | 114.21 |   116.34   |    5    |
| GOOG     | 2016-07-11 | 1111762  | 708.05 | 716.51 | 707.24 |   715.09   |    1    |
| GOOG     | 2016-07-13 |  935876  | 723.62 | 724.00 | 716.85 |   716.98   |    2    |
| GOOG     | 2016-07-15 | 1279339  | 725.73 | 725.74 | 719.06 |   719.85   |    3    |
| GOOG     | 2016-07-12 | 1336921  | 719.12 | 722.94 | 715.91 |   720.64   |    4    |
| GOOG     | 2016-07-14 |  950193  | 721.58 | 722.21 | 718.03 |   720.95   |    5    |
| INTC     | 2017-07-03 | 12676894 | 33.51  | 34.03  | 33.43  |   33.46    |    1    |
| INTC     | 2017-06-29 | 25215664 | 33.92  | 34.10  | 33.34  |   33.54    |    2    |
| INTC     | 2016-11-04 | 21914746 | 33.53  | 33.93  | 33.42  |   33.61    |    3    |
| INTC     | 2017-07-06 | 20733189 | 34.12  | 34.29  | 33.56  |   33.63    |    4    |
| INTC     | 2017-06-27 | 27078918 | 34.00  | 34.14  | 33.65  |   33.65    |    5    |
| KO       | 2016-12-01 | 20409864 | 40.31  | 40.39  | 39.88  |   40.17    |    1    |
| KO       | 2016-11-30 | 22410367 | 41.00  | 41.20  | 40.35  |   40.35    |    2    |
| KO       | 2016-12-02 | 11176301 | 40.30  | 40.50  | 40.19  |   40.36    |    3    |
| KO       | 2017-02-15 | 26600788 | 40.42  | 40.63  | 40.40  |   40.44    |    4    |
| KO       | 2017-02-14 | 32177836 | 40.38  | 40.60  | 40.22  |   40.53    |    5    |
| MSFT     | 2016-07-11 | 22269203 | 52.50  | 52.83  | 52.47  |   52.59    |    1    |
| MSFT     | 2016-07-19 | 53336533 | 53.71  | 53.90  | 52.93  |   53.09    |    2    |
| MSFT     | 2016-07-12 | 27317555 | 52.94  | 53.40  | 52.78  |   53.21    |    3    |
| MSFT     | 2016-07-13 | 25356841 | 53.56  | 53.86  | 53.18  |   53.51    |    4    |
| MSFT     | 2016-07-15 | 32024385 | 53.95  | 54.00  | 53.21  |   53.70    |    5    |
| NFLX     | 2016-07-19 | 55681209 | 85.43  | 86.75  | 84.50  |   85.84    |    1    |
| NFLX     | 2016-07-22 | 11363917 | 86.48  | 86.50  | 85.11  |   85.89    |    2    |
| NFLX     | 2016-07-21 | 16083996 | 88.30  | 88.38  | 85.21  |   85.99    |    3    |
| NFLX     | 2016-07-25 | 14135027 | 85.73  | 87.87  | 85.01  |   87.66    |    4    |
| NFLX     | 2016-07-20 | 23525141 | 86.67  | 88.49  | 85.82  |   87.91    |    5    |
| NKE      | 2016-11-01 | 14100431 | 50.50  | 50.51  | 49.14  |   49.62    |    1    |
| NKE      | 2016-11-02 | 10775938 | 49.24  | 50.27  | 49.01  |   49.72    |    2    |
| NKE      | 2016-11-03 | 7678690  | 49.98  | 50.00  | 49.31  |   49.73    |    3    |
| NKE      | 2016-11-04 | 9925196  | 49.80  | 50.45  | 49.76  |   49.96    |    4    |
| NKE      | 2016-11-30 | 8198418  | 50.52  | 50.81  | 50.07  |   50.07    |    5    |
| NVDA     | 2016-07-11 | 11219437 | 51.58  | 52.40  | 51.52  |   52.02    |    1    |
| NVDA     | 2016-07-15 | 10715357 | 52.64  | 52.94  | 51.84  |   52.70    |    2    |
| NVDA     | 2016-07-13 | 8115130  | 52.90  | 53.20  | 52.70  |   52.78    |    3    |
| NVDA     | 2016-07-12 | 10919045 | 52.60  | 53.28  | 51.94  |   52.80    |    4    |
| NVDA     | 2016-07-18 | 6324838  | 53.35  | 53.43  | 52.77  |   52.97    |    5    |
| PEP      | 2016-12-01 | 7123022  | 99.89  | 100.05 | 98.50  |   99.03    |    1    |
| PEP      | 2016-11-30 | 8123491  | 101.51 | 101.92 | 100.10 |   100.10   |    2    |
| PEP      | 2016-12-02 | 4594602  | 99.40  | 100.64 | 99.40  |   100.60   |    3    |
| PEP      | 2016-12-05 | 3961810  | 100.62 | 100.91 | 100.12 |   100.71   |    4    |
| PEP      | 2016-11-18 | 4919150  | 101.40 | 101.80 | 101.18 |   101.31   |    5    |
| WFM      | 2016-10-05 | 7863408  | 28.07  | 28.19  | 27.91  |   27.96    |    1    |
| **WFM**  | 2016-09-14 | 4827056  | 27.86  | 28.20  | 27.67  | **28.00**  |  **2**  |
| **WFM**  | 2016-09-13 | 5231731  | 28.23  | 28.38  | 27.81  | **28.00**  |  **2**  |
| WFM      | 2016-09-29 | 3234479  | 28.32  | 28.35  | 27.99  |   28.01    |    3    |
| WFM      | 2016-10-04 | 3714844  | 28.28  | 28.55  | 28.00  |   28.03    |    4    |
| WFM      | 2016-10-21 | 3790306  | 28.26  | 28.45  | 28.00  |   28.08    |    5    |
| WMT      | 2017-01-27 | 13433629 | 66.86  | 66.97  | 65.28  |   65.66    |    1    |
| WMT      | 2017-02-01 | 9049972  | 66.46  | 66.71  | 66.04  |   66.23    |    2    |
| WMT      | 2017-02-06 | 9097238  | 66.37  | 66.86  | 66.37  |   66.40    |    3    |
| WMT      | 2017-01-30 | 8641511  | 65.63  | 66.48  | 65.63  |   66.42    |    4    |
| WMT      | 2017-02-03 | 7625330  | 66.82  | 66.93  | 66.44  |   66.50    |    5    |



## 200-day Simple Moving Average of Stock Prices ##

To show that the query to calculate the 200-day Simple Moving Average is correct, I start with crafting a 5-day Simple Moving Average of Pepsi's stock price.

```SQL
WITH pepsi_day_ranked_historical_data AS (
    SELECT
      dense_rank() OVER (ORDER BY date) AS day_rank,
      ticker,
      date,
      open,
      high,
      low,
      close,
      volume
    FROM
      stock.historical_data
    WHERE ticker = (SELECT id FROM stock.ticker WHERE symbol = 'PEP')
)
SELECT date, volume, close,
  (
      SELECT AVG(pep2.close)
      FROM
        pepsi_day_ranked_historical_data pep2
      WHERE
        pep2.day_rank BETWEEN (pep1.day_rank - 4) and pep1.day_rank
      GROUP BY pep2.ticker
  ) AS price_rolling_average_5days,
  (
      -- this query is for verifying that the numbers used for averaging are correct
      SELECT array_agg(pep2.close)
      FROM
        pepsi_day_ranked_historical_data pep2
      WHERE
        pep2.day_rank BETWEEN (pep1.day_rank - 4) and pep1.day_rank
      GROUP BY pep2.ticker
  ) AS prices_last5_for_averaging
FROM
  pepsi_day_ranked_historical_data pep1
WHERE date BETWEEN '2017-06-28' AND '2017-07-07'
ORDER BY date desc
```  
|    date    | volume  |    close     | price_rolling_average_5days |        prices_last5_for_averaging         |
|:----------:|:-------:|:------------:|:---------------------------:|:-----------------------------------------:|
| 2017-07-07 | 3972488 | **_115.51_** |           115.374           | {**_115.49,115.44,115.3,115.13,115.51_**} |
| 2017-07-06 | 4006999 | **_115.13_** |           115.308           |    {115.18,115.49,115.44,115.3,115.13}    |
| 2017-07-05 | 4023052 | **_115.30_** |           115.558           |    {116.38,115.18,115.49,115.44,115.3}    |
| 2017-07-03 | 2250824 | **_115.44_** |           115.686           |   {115.94,116.38,115.18,115.49,115.44}    |
| 2017-06-30 | 3313250 | **_115.49_** |           116.022           |   {117.12,115.94,116.38,115.18,115.49}    |
| 2017-06-29 | 3474360 |    115.18    |           116.316           |   {116.96,117.12,115.94,116.38,115.18}    |
| 2017-06-28 | 3110592 |    116.38    |           116.51            |   {116.15,116.96,117.12,115.94,116.38}    |

The July 7th moving average is calculated using the closing prices from June 30 - July 7. The prices in Pepsi's  prices_last5_for_averaging on July 7th match the closing prices from June 30 - July 7.

Now I calculate the 200-day Simple Moving Average of the APNP stocks for the week of July 3, 2017. Costco and Intel under-performed against their respective 200-day moving average.

```SQL
WITH day_ranked_historical_data AS (
    SELECT
      dense_rank() OVER (ORDER BY date) AS day_rank,
      ticker,
      date,
      open,
      high,
      low,
      close,
      volume
    FROM
      stock.historical_data
)
SELECT symbol, date, volume, close,
  (
      SELECT AVG(dh2.close)
      FROM
        day_ranked_historical_data dh2
      WHERE
        dh2.ticker = dh1.ticker AND
        dh2.day_rank BETWEEN (dh1.day_rank - 199) and dh1.day_rank
      GROUP BY dh2.ticker
  ) AS price_rolling_average_200days
FROM
  day_ranked_historical_data dh1
    INNER JOIN
  stock.ticker t ON dh1.ticker = t.id
WHERE date BETWEEN '2017-07-03' AND '2017-07-07'
ORDER BY symbol, date desc;
```

| symbol |    date    |  volume  | close  | price_rolling_average_200days |
|:-------|:----------:|:--------:|:------:|:-----------------------------:|
| AAPL   | 2017-07-07 | 19201712 | 144.18 |           130.53495           |
| AAPL   | 2017-07-06 | 24128782 | 142.73 |           130.3819            |
| AAPL   | 2017-07-05 | 21569557 | 144.09 |           130.23615           |
| AAPL   | 2017-07-03 | 14277848 | 143.50 |           130.0903            |
| AMD    | 2017-07-07 | 88392137 | 13.36  |            10.9469            |
| AMD    | 2017-07-06 | 88927822 | 13.02  |           10.91095            |
| AMD    | 2017-07-05 | 99450235 | 13.19  |           10.87665            |
| AMD    | 2017-07-03 | 39929101 | 12.15  |           10.84095            |
| AMZN   | 2017-07-07 | 2643387  | 978.76 |           857.7065            |
| AMZN   | 2017-07-06 | 3259613  | 965.14 |           856.7138            |
| AMZN   | 2017-07-05 | 3652955  | 971.40 |           855.7636            |
| AMZN   | 2017-07-03 | 2909108  | 953.66 |           854.7992            |
| BABA   | 2017-07-07 | 8046241  | 142.43 |           107.9091            |
| BABA   | 2017-07-06 | 11934243 | 142.20 |           107.7042            |
| BABA   | 2017-07-05 | 16995802 | 144.87 |           107.50835           |
| BABA   | 2017-07-03 | 6975712  | 140.99 |           107.3072            |
| COST   | 2017-07-07 | 7688368  | 154.11 |           163.5028            |
| COST   | 2017-07-06 | 6963416  | 157.09 |           163.4931            |
| COST   | 2017-07-05 | 3770401  | 158.02 |           163.4666            |
| COST   | 2017-07-03 | 1995074  | 158.82 |           163.43825           |
| DPZ    | 2017-07-07 |  444206  | 212.32 |           179.22355           |
| DPZ    | 2017-07-06 |  624585  | 208.84 |           178.92165           |
| DPZ    | 2017-07-05 |  582591  | 208.03 |            178.635            |
| DPZ    | 2017-07-03 |  176950  | 209.92 |            178.345            |
| FB     | 2017-07-07 | 13615931 | 151.44 |           135.0926            |
| FB     | 2017-07-06 | 14951802 | 148.82 |           134.9786            |
| FB     | 2017-07-05 | 14334290 | 150.34 |           134.87775           |
| FB     | 2017-07-03 | 13862735 | 148.43 |           134.7714            |
| GOOG   | 2017-07-07 | 1637785  | 918.59 |           837.5404            |
| GOOG   | 2017-07-06 | 1424503  | 906.69 |           836.8045            |
| GOOG   | 2017-07-05 | 1813884  | 911.71 |           836.09955           |
| GOOG   | 2017-07-03 | 1710373  | 898.70 |           835.3854            |
| INTC   | 2017-07-07 | 18304460 | 33.88  |            35.9384            |
| INTC   | 2017-07-06 | 20733189 | 33.63  |            35.9547            |
| INTC   | 2017-07-05 | 30010803 | 34.34  |           35.97235            |
| INTC   | 2017-07-03 | 12676894 | 33.46  |            35.989             |
| KO     | 2017-07-07 | 9566044  | 44.39  |            42.546             |
| KO     | 2017-07-06 | 13113019 | 44.40  |           42.53575            |
| KO     | 2017-07-05 | 6853558  | 44.82  |           42.52425            |
| KO     | 2017-07-03 | 6434460  | 44.76  |           42.51085            |
| MSFT   | 2017-07-07 | 16878317 | 69.46  |            64.1181            |
| MSFT   | 2017-07-06 | 21117572 | 68.57  |           64.05485            |
| MSFT   | 2017-07-05 | 21176272 | 69.08  |           63.99665            |
| MSFT   | 2017-07-03 | 16165538 | 68.17  |            63.9375            |
| NFLX   | 2017-07-07 | 5561263  | 150.18 |           136.0926            |
| NFLX   | 2017-07-06 | 5486482  | 146.25 |           135.83295           |
| NFLX   | 2017-07-05 | 4627803  | 147.61 |            135.592            |
| NFLX   | 2017-07-03 | 3908215  | 146.17 |           135.35135           |
| NKE    | 2017-07-07 | 8145436  | 57.98  |            53.6031            |
| NKE    | 2017-07-06 | 9035661  | 57.16  |           53.58755            |
| NKE    | 2017-07-05 | 16166954 | 57.56  |            53.5765            |
| NKE    | 2017-07-03 | 9910021  | 58.65  |            53.5646            |
| NVDA   | 2017-07-07 | 16374302 | 146.76 |           104.8507            |
| NVDA   | 2017-07-06 | 18657132 | 143.48 |           104.43235           |
| NVDA   | 2017-07-05 | 20504738 | 143.05 |           104.0333            |
| NVDA   | 2017-07-03 | 17726821 | 139.33 |           103.63225           |
| PEP    | 2017-07-07 | 3972488  | 115.51 |           108.9898            |
| PEP    | 2017-07-06 | 4006999  | 115.13 |           108.94375           |
| PEP    | 2017-07-05 | 4023052  | 115.30 |           108.89645           |
| PEP    | 2017-07-03 | 2250824  | 115.44 |           108.84635           |
| WFM    | 2017-07-07 | 6227419  | 42.00  |           32.26045            |
| WFM    | 2017-07-06 | 5404325  | 42.01  |           32.19155            |
| WFM    | 2017-07-05 | 4408657  | 41.99  |            32.1244            |
| WFM    | 2017-07-03 | 1891700  | 42.04  |            32.0564            |
| WMT    | 2017-07-07 | 5307064  | 75.33  |            71.8337            |
| WMT    | 2017-07-06 | 6161845  | 75.47  |            71.8169            |
| WMT    | 2017-07-05 | 6037661  | 75.32  |             71.8              |
| WMT    | 2017-07-03 | 4848564  | 75.36  |           71.78775            |
