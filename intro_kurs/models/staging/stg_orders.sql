with orders_stg as (
    select 
        id as order_id,
        user_id as customer_id,
        order_date as ordered_at,
        _etl_loaded_at
    from {{ source('jaffle_alle', 'orders') }}
)

select * from orders_stg