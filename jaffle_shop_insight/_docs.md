# Jaffle shop insight

Insight sulution for tracking our revenue and customers buying habits

## Sources

The source systems use for getting this insight

### Jaffle shop

This is our internal customer and order tracking system. These table are extracted and loaded nightly.

Schema: jaffle_shop

#### Tables

**customers**

Full nightly Snapshot of the customer-table. It contains all tracked information about the customer.

| name       | type   | description                             |
|------------|--------|-----------------------------------------|
| id         | int    | Unique identifier of a customer         |
| first_name | string | First name of the customer              |
| last_name  | string | The initial of the customer's last name |

**orders**

Full nightly snapshot of the orders-table. It contains all tracked information about all placed orders of sandwiches.

| name       | type   | description                             |
|------------|--------|-----------------------------------------|
| id         | int    | Unique identifier of a order |
| user_id | int | Identifier of a customer that ordered a sandwich. Corelates with id in customers |
| order_date  | date | The date an order was placed |
| status | string | An enum of what the state of the order is. The availeble states are: placed, shipped, returned, completed, return_pending |

## Mart

These dimmensions and facts are prepared to to do analytics on

### dim_customers

A dimmension with customer information

#### Lineage

jaffle_shop.customers -> main.dim_customers

### dim_order_status

A dimmension with information about changes of the status for a given order. Soon to be historicised with a daylie granularity.

#### Lineage

jaffle_shop.orders -> main.dim_order_status

### fct_revenue

A fact-table to be used to give insight into the incoming revenue of the sandwich sales. It also contains information about what customer ordered the sandwich.

#### Lineage

<pre>
stripe.payments >-------> main.fct_revenue
jaffle_shop.orders >-´
</pre>

#### Tests

**Assert total amount is over 0**

Will give a result if some order has the cost of 0. Should be run daylie to check of something is wrong.

**Assert order id is unique**

Will give a result if *order_id* is not unique. Should be run at least whenever you do a change to catch if the granularity is correct.
