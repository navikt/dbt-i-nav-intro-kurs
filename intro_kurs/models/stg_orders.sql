with
    source as (select * from jaffle_shop.orders),
    renamed as (
        select id as order_id, user_id as customer_id, order_date as ordered_at
        from source
    )
select *
from renamed
