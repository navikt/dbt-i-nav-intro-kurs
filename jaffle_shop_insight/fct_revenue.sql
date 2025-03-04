-- Husk å sette riktig database og schema før du kjører denne spørringen

drop view if exists fct_revenue_tmp
;

create view fct_revenue_tmp as (
    with
        orders as (
            select id as order_id, user_id as customer_id, order_date
            from jaffle_shop.orders
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

                -- numbers
                completed_payments_by_orders.total_amount_in_cents,

                -- text
                completed_payments_by_orders.payment_method,
                orders.order_date,

                -- dates
                completed_payments_by_orders.payment_date
            from orders
            left join
                completed_payments_by_orders
                on orders.order_id = completed_payments_by_orders.order_id
        )

    select *
    from orders_joined_payments
)
;

drop view if exists fct_revenue
;

alter view fct_revenue_tmp rename to fct_revenue
;
