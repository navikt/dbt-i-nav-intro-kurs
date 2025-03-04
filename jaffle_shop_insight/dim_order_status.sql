-- Husk å sette riktig database og schema før du kjører denne spørringen

drop view if exists dim_order_status_tmp
;

create view dim_order_status_tmp as (
    select
        -- ids
        id as order_id,
        order_id as customer_id,

        -- strings
        status as order_status,

        -- dates
        order_date,
        -- TODO: replace with actual created and updated dates when snapshot of source
        -- table is created
        order_date as created_date,
        cast(_etl_loaded_at as date) as updated_date

    from jaffle_shop.orders
)
;

drop view if exists dim_order_status
;

alter view dim_order_status_tmp rename to dim_order_status
;
