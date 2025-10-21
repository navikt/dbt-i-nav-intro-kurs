with customers_stg as (
    select 
        id as customer_id,
        first_name,
        last_name,
        first_name || ' ' || last_name as name
    from jaffle_shop.customers
)

select * from customers_stg