select order_id from fct_revenue group by order_id having count(*) > 1
