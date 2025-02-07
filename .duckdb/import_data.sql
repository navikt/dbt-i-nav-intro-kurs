CREATE SCHEMA IF NOT EXISTS jaffle_shop;
CREATE OR REPLACE TABLE jaffle_shop.orders AS SELECT * FROM read_csv_auto('.duckdb/data/orders.csv');
CREATE OR REPLACE TABLE jaffle_shop.customers AS SELECT * FROM read_csv_auto('.duckdb/data/customers.csv');

CREATE SCHEMA IF NOT EXISTS stripe;
CREATE OR REPLACE TABLE stripe.payments AS SELECT * FROM read_csv_auto('.duckdb//data/payments.csv');
