--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

-- Started on 2017-07-08 06:17:33 PDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 24014)
-- Name: stock; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA stock;


--
-- TOC entry 1 (class 3079 OID 12655)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2446 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = stock, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 191 (class 1259 OID 24017)
-- Name: exchange; Type: TABLE; Schema: stock; Owner: -
--

CREATE TABLE exchange (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    abbr character varying(32),
    open_local_time time without time zone NOT NULL,
    close_local_time time without time zone NOT NULL
);


--
-- TOC entry 2447 (class 0 OID 0)
-- Dependencies: 191
-- Name: TABLE exchange; Type: COMMENT; Schema: stock; Owner: -
--

COMMENT ON TABLE exchange IS 'Stock Exchange';


--
-- TOC entry 190 (class 1259 OID 24015)
-- Name: exchange_id_seq; Type: SEQUENCE; Schema: stock; Owner: -
--

CREATE SEQUENCE exchange_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2448 (class 0 OID 0)
-- Dependencies: 190
-- Name: exchange_id_seq; Type: SEQUENCE OWNED BY; Schema: stock; Owner: -
--

ALTER SEQUENCE exchange_id_seq OWNED BY exchange.id;


--
-- TOC entry 199 (class 1259 OID 24166)
-- Name: historical_data; Type: TABLE; Schema: stock; Owner: -
--

CREATE TABLE historical_data (
    id integer NOT NULL,
    ticker integer NOT NULL,
    date date NOT NULL,
    open numeric(10,2) NOT NULL,
    high numeric(10,2),
    low numeric(10,2),
    close numeric(10,2),
    volume bigint NOT NULL
);


--
-- TOC entry 198 (class 1259 OID 24164)
-- Name: historical_data_id_seq; Type: SEQUENCE; Schema: stock; Owner: -
--

CREATE SEQUENCE historical_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2449 (class 0 OID 0)
-- Dependencies: 198
-- Name: historical_data_id_seq; Type: SEQUENCE OWNED BY; Schema: stock; Owner: -
--

ALTER SEQUENCE historical_data_id_seq OWNED BY historical_data.id;


--
-- TOC entry 193 (class 1259 OID 24065)
-- Name: ticker; Type: TABLE; Schema: stock; Owner: -
--

CREATE TABLE ticker (
    id integer NOT NULL,
    symbol character varying(16) NOT NULL,
    exchange integer NOT NULL
);


--
-- TOC entry 194 (class 1259 OID 24087)
-- Name: nasdaq_stock; Type: MATERIALIZED VIEW; Schema: stock; Owner: -
--

CREATE MATERIALIZED VIEW nasdaq_stock AS
 SELECT t.id AS ticker
   FROM (ticker t
     JOIN exchange x ON ((t.exchange = x.id)))
  WHERE ((x.abbr)::text = 'NASDAQ'::text)
  WITH NO DATA;


--
-- TOC entry 195 (class 1259 OID 24091)
-- Name: nyse_stock; Type: MATERIALIZED VIEW; Schema: stock; Owner: -
--

CREATE MATERIALIZED VIEW nyse_stock AS
 SELECT t.id AS ticker
   FROM (ticker t
     JOIN exchange x ON ((t.exchange = x.id)))
  WHERE ((x.abbr)::text = 'NYSE'::text)
  WITH NO DATA;


--
-- TOC entry 197 (class 1259 OID 24103)
-- Name: seattle; Type: MATERIALIZED VIEW; Schema: stock; Owner: -
--

CREATE MATERIALIZED VIEW seattle AS
 SELECT ticker.id AS ticker
   FROM ticker
  WHERE ((ticker.symbol)::text = ANY ((ARRAY['MSFT'::character varying, 'AMZN'::character varying, 'COST'::character varying])::text[]))
  WITH NO DATA;


--
-- TOC entry 196 (class 1259 OID 24099)
-- Name: silicon_valley; Type: MATERIALIZED VIEW; Schema: stock; Owner: -
--

CREATE MATERIALIZED VIEW silicon_valley AS
 SELECT ticker.id AS ticker
   FROM ticker
  WHERE ((ticker.symbol)::text = ANY ((ARRAY['AAPL'::character varying, 'FB'::character varying, 'GOOG'::character varying, 'NFLX'::character varying, 'AMD'::character varying, 'INTC'::character varying, 'NVDA'::character varying])::text[]))
  WITH NO DATA;


--
-- TOC entry 192 (class 1259 OID 24063)
-- Name: ticker_id_seq; Type: SEQUENCE; Schema: stock; Owner: -
--

CREATE SEQUENCE ticker_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2450 (class 0 OID 0)
-- Dependencies: 192
-- Name: ticker_id_seq; Type: SEQUENCE OWNED BY; Schema: stock; Owner: -
--

ALTER SEQUENCE ticker_id_seq OWNED BY ticker.id;


--
-- TOC entry 2300 (class 2604 OID 24020)
-- Name: exchange id; Type: DEFAULT; Schema: stock; Owner: -
--

ALTER TABLE ONLY exchange ALTER COLUMN id SET DEFAULT nextval('exchange_id_seq'::regclass);


--
-- TOC entry 2302 (class 2604 OID 24169)
-- Name: historical_data id; Type: DEFAULT; Schema: stock; Owner: -
--

ALTER TABLE ONLY historical_data ALTER COLUMN id SET DEFAULT nextval('historical_data_id_seq'::regclass);


--
-- TOC entry 2301 (class 2604 OID 24068)
-- Name: ticker id; Type: DEFAULT; Schema: stock; Owner: -
--

ALTER TABLE ONLY ticker ALTER COLUMN id SET DEFAULT nextval('ticker_id_seq'::regclass);


--
-- TOC entry 2306 (class 2606 OID 24022)
-- Name: exchange exchange_pkey; Type: CONSTRAINT; Schema: stock; Owner: -
--

ALTER TABLE ONLY exchange
    ADD CONSTRAINT exchange_pkey PRIMARY KEY (id);


--
-- TOC entry 2315 (class 2606 OID 24171)
-- Name: historical_data historical_data_pkey; Type: CONSTRAINT; Schema: stock; Owner: -
--

ALTER TABLE ONLY historical_data
    ADD CONSTRAINT historical_data_pkey PRIMARY KEY (id);


--
-- TOC entry 2309 (class 2606 OID 24070)
-- Name: ticker ticker_pkey; Type: CONSTRAINT; Schema: stock; Owner: -
--

ALTER TABLE ONLY ticker
    ADD CONSTRAINT ticker_pkey PRIMARY KEY (id);


--
-- TOC entry 2303 (class 1259 OID 24024)
-- Name: exchange_abbr_index; Type: INDEX; Schema: stock; Owner: -
--

CREATE INDEX exchange_abbr_index ON exchange USING btree (abbr);


--
-- TOC entry 2304 (class 1259 OID 24023)
-- Name: exchange_id_uindex; Type: INDEX; Schema: stock; Owner: -
--

CREATE UNIQUE INDEX exchange_id_uindex ON exchange USING btree (id);


--
-- TOC entry 2311 (class 1259 OID 24178)
-- Name: historical_data_close_index; Type: INDEX; Schema: stock; Owner: -
--

CREATE INDEX historical_data_close_index ON historical_data USING btree (close);


--
-- TOC entry 2312 (class 1259 OID 24179)
-- Name: historical_data_high_index; Type: INDEX; Schema: stock; Owner: -
--

CREATE INDEX historical_data_high_index ON historical_data USING btree (high);


--
-- TOC entry 2313 (class 1259 OID 24180)
-- Name: historical_data_low_index; Type: INDEX; Schema: stock; Owner: -
--

CREATE INDEX historical_data_low_index ON historical_data USING btree (low);


--
-- TOC entry 2316 (class 1259 OID 24177)
-- Name: historical_data_ticker_date_index; Type: INDEX; Schema: stock; Owner: -
--

CREATE INDEX historical_data_ticker_date_index ON historical_data USING btree (ticker, date);


--
-- TOC entry 2307 (class 1259 OID 24077)
-- Name: ticker_exchange_index; Type: INDEX; Schema: stock; Owner: -
--

CREATE INDEX ticker_exchange_index ON ticker USING btree (exchange);


--
-- TOC entry 2310 (class 1259 OID 24076)
-- Name: ticker_symbol_uindex; Type: INDEX; Schema: stock; Owner: -
--

CREATE UNIQUE INDEX ticker_symbol_uindex ON ticker USING btree (symbol);


--
-- TOC entry 2318 (class 2606 OID 24172)
-- Name: historical_data historical_data_ticker_id_fk; Type: FK CONSTRAINT; Schema: stock; Owner: -
--

ALTER TABLE ONLY historical_data
    ADD CONSTRAINT historical_data_ticker_id_fk FOREIGN KEY (ticker) REFERENCES ticker(id) ON DELETE CASCADE;


--
-- TOC entry 2317 (class 2606 OID 24071)
-- Name: ticker ticker_exchange_id_fk; Type: FK CONSTRAINT; Schema: stock; Owner: -
--

ALTER TABLE ONLY ticker
    ADD CONSTRAINT ticker_exchange_id_fk FOREIGN KEY (exchange) REFERENCES exchange(id) ON DELETE CASCADE;


-- Completed on 2017-07-08 06:17:34 PDT

--
-- PostgreSQL database dump complete
--

