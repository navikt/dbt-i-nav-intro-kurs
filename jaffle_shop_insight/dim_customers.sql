-- Husk å sette riktig database og schema før du kjører denne spørringen

drop view if exists dim_customers_tmp
;

create view dim_customers_tmp as (
    select id as customer_id, concat(first_name || ' ' || last_name) as name
    from jaffle_shop.customers
)
;

drop view if exists dim_customers
;

alter view dim_customers_tmp rename to dim_customers
;
