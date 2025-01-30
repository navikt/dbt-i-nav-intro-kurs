{{
  config(
    materialized = 'view'
    )
}}

with customers as 
( 
    select
        customer_id,
        first_name as name
    from {{ref('stg_customers')}}
),
orders as (
    select
        order_id,
        customer_id,
        ordered_at
    from {{ref('stg_orders')}}
),
customer_orders as (
    select
        customer_id,
        min(ordered_at) as first_order_date,
        max(ordered_at) as most_recent_order_date,
        count(order_id) as number_of_orders
    from orders
    group by customer_id

),

final as (

    select
        customers.customer_id,
        customers.name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders
    from customers
    left join customer_orders on customers.customer_id = customer_orders.customer_id
)

select * from final
