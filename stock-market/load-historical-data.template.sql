--
-- do a global-replace on <parent path>
--
DROP TABLE IF EXISTS TEMP_STOCK_HISTORICAL_DATA;
CREATE TEMPORARY TABLE TEMP_STOCK_HISTORICAL_DATA (
  "date" date,
  open NUMERIC(10, 2),
  high NUMERIC(10, 2),
  low NUMERIC(10, 2),
  close NUMERIC(10, 2),
  volume BIGINT
);

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/aapl.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'AAPL'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/amd.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'AMD'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/amzn.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'AMZN'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/baba.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'BABA'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/cost.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'COST'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/dpz.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'DPZ'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;
--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/fb.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'FB'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;
--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/goog.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'GOOG'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/intc.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'INTC'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/ko.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'KO'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/msft.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'MSFT'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/nflx.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'NFLX'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/nke.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'NKE'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/nvda.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'NVDA'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/pep.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'PEP'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/wfm.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'WFM'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;

--
TRUNCATE TABLE TEMP_STOCK_HISTORICAL_DATA;

COPY TEMP_STOCK_HISTORICAL_DATA
FROM '<parent_path>/historical-data-csv/wmt.csv'
WITH DELIMITER ',' CSV HEADER;

INSERT INTO stock.historical_data(ticker, date, open, high, low, close, volume)
      SELECT t.id AS ticker, h.date, h.open, h.high, h.low, h.close, h.volume
              FROM
              stock.ticker t
                INNER JOIN
              (
                SELECT
                  'WMT'::VARCHAR(16) AS ticker,
                  *
                FROM
                  TEMP_STOCK_HISTORICAL_DATA
              ) h ON t.symbol=h.ticker
;
