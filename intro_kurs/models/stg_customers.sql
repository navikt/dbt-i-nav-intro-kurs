 {{
   config(
     materialized = 'view'
     )
 }} 
with customers_stg as (
  select * from {{ source('jaffle_alle', 'customers') }}
)

select * from customers_stg