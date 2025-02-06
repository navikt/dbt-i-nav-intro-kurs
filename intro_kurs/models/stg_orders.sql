 {{
   config(
     materialized = 'view'
     )
 }} 
with orders as (
  select * from {{ source('jaffle_alle', 'orders') }}
)

select * from orders