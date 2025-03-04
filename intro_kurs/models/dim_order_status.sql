select
    -- ids
    id as order_id,
    user_id as customer_id,

    -- strings
    status as order_status,

    -- dates
    order_date as order_date,
    -- TODO: replace with actual created and updated dates when snapshot of source
    -- table is created
    order_date as created_date,
    cast(_etl_loaded_at as date) as updated_date

from jaffle_shop.orders
