CREATE SCHEMA IF NOT EXISTS raw;

CREATE OR REPLACE TABLE orders AS SELECT * FROM read_csv_auto('.duckdb/data/orders.csv');

CREATE OR REPLACE TABLE payments AS SELECT * FROM read_csv_auto('.duckdb//data/payments.csv');

CREATE OR REPLACE TABLE customers AS SELECT * FROM read_csv_auto('.duckdb/data/customers.csv');
