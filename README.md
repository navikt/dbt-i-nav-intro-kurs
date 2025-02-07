# dbt grunnleggende konsepter - kurs med øvinger

## Forutsettinger
1. Må ha en github konto og den må være koblet til organisasjon NAV-IKT
2. Må ha egen laptop
3. Bør helst deltatt på kurset "hva er dbt"

## Oppgaver

### Øvelse 1:  - bygg din første modell

Kopier filen *dim_customer.sql* fra mappen *jaffle_shop_innsikt* til mappen *intro_kurs/model*. Prøv å kjør `dbt build` fra terminalen fra mappen *intro_kurs*
```shell
cd intro_kurs
```

```shell
dbt build
```

Å nei, det feiler! Det er fordi dbt tar hånd om all "boilerplate" slik at vi kun trenger å tenke på select-spørrigen. Fjern all DDL inkludert semikollon så kun select-spørringen er igjen.

Filen *intro_kurs/models/dim_customers.sql* skal se slik ut når du er ferdig:

```sql
with

    customers as (select customer_id, first_name as name from jaffle_shop.customers),
    orders as (
        select id as order_id, user_id as customer_id, order_date as ordered_at
        from jaffle_shop.orders
    ),

    customer_orders as (
        select
            customer_id,
            min(ordered_at) as first_order_date,
            max(ordered_at) as most_recent_order_date,
            count(order_id) as number_of_orders
        from orders
        group by customer_id
    ),

    final as (
        select
            customers.customer_id,
            customers.name,
            customer_orders.first_order_date,
            customer_orders.most_recent_order_date,
            coalesce(customer_orders.number_of_orders, 0) as number_of_orders
        from customers
        left join customer_orders on customers.customer_id = customer_orders.customer_id
    )

select *
from final

```

Nå kan vi prøve å bygge på nytt med `dbt build` eller bruke *dbt power user*

### Øvelse 2:  - lage staging modell av Customers og Orders

Lag en file i *staging* mappen som heter *stg_customers.sql*
```sql
 {{
   config(
     materialized = 'view'
     )
 }}
with customers_stg as (
  select * from dev.customers
)

select * from customers_stg
```
Deretter kjører du dette med følgende kommando:
`dbt run --select stg_customers`

Vi lager også *stg_orders.sql* ved å legge inn følgende kode:

```sql
 {{
   config(
     materialized = 'view'
     )
 }}
with orders_stg as (
  select * from dev.orders
)
select * from orders_stg
```

Deretter kjører du dette med følgende kommando:
`dbt run --select stg_orders`

Kontroller i databasen at stg_orders og stg_customers er opperettet, sjekk også dataene.

**Gratulerer du har når laget dine 2 første staging komponenter i dbt.**


### Øvelse 3:  - legge inn sources i en yml file, kjør stg_customers

Lag en file i *staging* mappen som heter *src_jaffle_shop.yml*

```yaml
sources:
  - name: jaffle_alle
    description: treningdatabase duckdb
    database: dev
    schema: main
    tables:
      - name: orders
        description: alle ordrene
      - name: customers
        description: kundene våre
        columns:
        - name: customer_id
          description: Primary key
          tests:
            - unique
            - not_null
      - name: payment
        description: betalinger utført
      - name: Person
        description: Alle personen som kjøper
```
Endre filen *stg_customers* til:

```sql
{{
   config(
     materialized = 'view'
     )
 }}
with customers_stg as (
  select * from {{ source('jaffle_alle', 'customers') }}
)

select * from customers_stg

```
Kjør på nytt for å se at viewet blir lagret, sjekk gjerne i databasen.

Deretter kjører du dette med følgende kommando:
`dbt run --select stg_customers`

Vi gjør det samme for *stg_orders.sql* vi endrer til følgende:

```sql
 {{
   config(
     materialized = 'view'
     )
 }}
with orders as (
  select * from {{ source('jaffle_alle', 'orders') }}
)

select * from orders
```

Deretter kjører du dette med følgende kommando:
`dbt run --select stg_orders`

Sjekk gjerne i databasen eller bruk PowerUser.

Hurra - du ha nå brukt source som funksjon for å lage stg_orders komponent.


### Øvelse 4:  - legge inn source freshness test av kildene

Her skal vi legge inn freshness test av kildene, vi legger inn følgende  i filen *src_jaffle_shop.yml*.
Vi skal sørge for at det kommer inn data hvert døgn i Orders tabellen.

```yaml
sources:
  - name: jaffle_alle
    description: treningdatabase duckdb
    database: dev
    schema: main
    tables:
      - name: orders
        description: alle ordrene
        freshness:
          warn_after:
            count: 1
            period: day
        loaded_at_field: "CAST(order_date AS TIMESTAMP)"
      - name: customers
        description: kundene våre
        columns:
        - name: customer_id
          description: Primary key
          tests:
            - unique
            - not_null
      - name: payment
        description: betalinger utført
      - name: Person
        description: Alle personen som kjøper
```

Kjør dbt kommandoen `dbt source freshness`. Du skal nå få en warn melding,siden det er mere en en dag gamle data, når du kjører dette.


### Øvelse 5:  - bygg en fakt_modell som bruker ref-funksjonen

Lag en file *fak_customer_orders.sql* i *model/marts* folderen. Følgende SQL skal ligge der

```sql
{{
  config(
    materialized = 'view'
    )
}}

with customers as
(
    select
        customer_id,
        first_name as name
    from {{ref('stg_customers')}}
),
orders as (
    select
        id as order_id,
        user_id as customer_id,
        order_date as ordered_at
    from {{ref('stg_orders')}}
),
customer_orders as (
    select
        customer_id,
        min(ordered_at) as first_order_date,
        max(ordered_at) as most_recent_order_date,
        count(order_id) as number_of_orders
    from orders
    group by customer_id

),

final as (

    select
        customers.customer_id,
        customers.name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders
    from customers
    left join customer_orders on customers.customer_id = customer_orders.customer_id
)

select * from final

```

Deretter kjører du dette med følgende kommando: `dbt run --select +fak_customer_orders`

### Øvelse 6:  - legge inn tester og dokumenterer modellen og noen felter

Lag en yml file *mdl_jaffle_shop.yml* i øverste folder ( samme som sources yml filen). Følgende skal ligger der:

```yaml
version: 2

models:
  - name: stg_orders
    description: "her er alle ordrene"
    columns:
      - name: ID
        description: " Ordre id som er unik og kan ikke være null"
        tests:
          - unique
          - not_null
  - name: stg_customers
    description: "Alle kundene som bestiller varer"
    columns:
      - name: NAME
        description: "ID kan ikke være null og må være unik"
        tests:
          - unique
          - not_null
```

Deretter kjører du testene  med følgende kommando: `dbt test -s +fak_customer_orders`, sjekk at det ikke gikk feil. Hva kan være feil i en av testene?  Korriger dette og kjør på nytt.
