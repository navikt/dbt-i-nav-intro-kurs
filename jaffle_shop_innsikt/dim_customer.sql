-- Husk å sette riktig database og schema før du kjører denne spørringen

drop table if exists dim_customer_tmp
;

create table dim_customer_tmp as

with

    customers as (select customer_id, first_name as name from jaffle_shop.customers),
    orders as (
        select id as order_id, user_id as customer_id, order_date as ordered_at
        from jaffle_shop.orders
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

select *
from final
;

drop table if exists dim_customer
;

alter table dim_customer_tmp rename to dim_customer
;
