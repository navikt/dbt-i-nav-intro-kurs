select
    customer_id,
    first_name,
    last_name
    
from  {{ source('jaffle_alle', 'customers') }}