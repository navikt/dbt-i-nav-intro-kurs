with
    orders as (
        select *stg_jaffle_shop__orders
    ),

    payments as (
        select
            orderid as order_id,
            paymentmethod as payment_method,
            status as transaction_status,
            amount as amount_in_cents,
            created as payment_date
        from stripe.payments
    ),

    completed_payments_by_orders as (
        select
            order_id,
            payment_method,
            sum(amount_in_cents) as total_amount_in_cents,
            payment_date
        from payments
        where transaction_status = 'success'
        group by all
    ),

    orders_joined_payments as (
        select
            -- ids
            orders.order_id,
            orders.customer_id,

            -- strings
            completed_payments_by_orders.payment_method,

            -- numerics
            completed_payments_by_orders.total_amount_in_cents,

            -- dates
            orders.order_date,
            completed_payments_by_orders.payment_date
        from orders
        left join
            completed_payments_by_orders
            on orders.order_id = completed_payments_by_orders.order_id
    )

select *
from orders_joined_payments
left join dim_customer on orders_joined_payments.customer_id = dim_customer.customer_id
left join
    dim_order_status on orders_joined_payments.order_id = dim_order_status.order_id
