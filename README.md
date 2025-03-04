# Intro til dbt

## Ditt første bygg av prosjektet

Gå inn i prosjektmappen.

### Øvelse 1:  - Bygge modeller

Kopier filen *dim_order_status.sql* fra mappen *jaffle_shop_innsikt* til mappen *intro_kurs/model*. Prøv å kjør `dbt build` i terminalen fra mappen *intro_kurs*
```shell
cd intro_kurs
```

Bygg prosjektet.

```shell
dbt build
```

### Feilende tester

Filen *intro_kurs/models/dim_order_status.sql* skal se slik ut når du er ferdig:

```sql
select
    -- ids
    id as order_id,

    -- strings
    status as order_status,

    -- dates
    order_date,
    -- TODO: replace with actual created and updated dates when snapshot of source
    -- table is created
    order_date as created_date,
    cast(_etl_loaded_at as date) as updated_date

from jaffle_shop.orders

```

Nå kan vi prøve å bygge på nytt med `dbt build`.

Gjenta stegene for filen *jaffle_shop_innsikt/fct_revenue.sql*

### Øvelse 2:  - Lage gjenbrukbare komponenter

I modellene *dim_order_status* og i *fct_revenue* gjør vi i dag en del
navneendringer for å følge navnestandaren. Det kan fort bli uoversiktlig når
slike navneendringer gjentas flere steder. Vi har tidligere gjentatt koden
for å slippe å tenke på hvem rekkefølge vi må kjøre SQL-scriptene i. dbt tar
hånd om rekkefølgen for oss og ønsker derfor å flytte navneendringene til en
egen modell som vi kan gjenbruke. Dette kaller vi for "staging-modeller" og en
staging-modell skal som regel ha et 1-1 forhold med en kilde-tabell.

Bytt navn på filen *intro_kurs/models/dim_order_status.sql* til *stg_jaffle_shop__orders.sql*.

Opprett en ny fil med navn *intro_kurs/models/dim_order_status.sql* med følgende innhold:

```sql
select * from stg_jaffle_shop__orders
```

Bytt ut inneholde i modellen *intro_kurs/models/fct_revenue.sql* sin CTE *orders* med det samme.
```sql
with
    orders as (
        select * from stg_jaffle_shop__orders
    ),
...
```

Nå kan vi prøve å bygge på nytt med `dbt build`

Å nei! Det feiler igjen! TODO! Så langt jeg rakk...
