## Tools Used ##

1. Postgres 9.6
2. DataGrip 2 (30-day Free Trial)

## Stock Data

The 1-year historical stock data of 17 (prime number!) public companies were downloaded from Google Finance on July 8, 2017.

## Database
1. Schema name: stock
2. Three tables
  * stock.exchange
  * stock.ticker
  * stock.historical_data
3. Four materialized views
  * nasdaq_stock
  * nyse_stock
  * silicon_valley
  * seattle
