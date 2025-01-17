
CREATE TABLE orders AS SELECT * FROM read_csv_auto('/workspaces/dbt-i-nav-intro-kurs/intro_kurs/data/orders.csv');

CREATE TABLE payments AS SELECT * FROM read_csv_auto('/workspaces/dbt-i-nav-intro-kurs/intro_kurs/data/payments.csv');

CREATE TABLE customers AS SELECT * FROM read_csv_auto('/workspaces/dbt-i-nav-intro-kurs/intro_kurs/data/customers.csv');

select * from orders;

drop view stg_customers;
COMMIT;

