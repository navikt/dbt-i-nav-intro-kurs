select id as customer_id, concat(first_name || ' ' || last_name) as name
from jaffle_shop.customers
