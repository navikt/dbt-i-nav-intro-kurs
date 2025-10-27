# ⚡ dbt Quick Reference

En hurtigreferanse for de viktigste dbt-kommandoene og konseptene.

---

## 🎯 Mest brukte kommandoer

### Kjøre modeller
```bash
# Kjør alle modeller
dbt run

# Kjør én spesifikk modell
dbt run --select dim_customer

# Kjør modell MED alle avhengigheter (upstream)
dbt run --select +dim_customer

# Kjør modell MED alt som avhenger av den (downstream)
dbt run --select dim_customer+

# Kjør modell MED alle avhengigheter i begge retninger
dbt run --select +dim_customer+

# Kjør alle modeller i en mappe
dbt run --select staging
dbt run --select marts

# Kjør modeller som har endret seg
dbt run --select state:modified
```

### Testing
```bash
# Kjør alle tester
dbt test

# Test én modell
dbt test --select dim_customer

# Test med avhengigheter
dbt test --select +dim_customer

# Test kun sources
dbt test --select source:*

# Test én spesifikk source
dbt test --select source:jaffle_alle
```

### Dokumentasjon
```bash
# Generer dokumentasjon
dbt docs generate

# Start dokumentasjonsserver (åpner i browser)
dbt docs serve

# Generer og åpne i én kommando
dbt docs generate && dbt docs serve
```

### Debugging og utforsking
```bash
# Kompiler SQL uten å kjøre
dbt compile --select dim_customer

# Vis resultatet av en modell (preview)
dbt show --select dim_customer
dbt show --select dim_customer --limit 10

# Se strukturen i prosjektet
dbt ls

# Se modeller og deres avhengigheter
dbt ls --select +dim_customer

# Sjekk konfigurasjon og tilkobling
dbt debug

# Få verbose output (debug-modus)
dbt run --select dim_customer --debug
```

### Opprydding
```bash
# Rydd i target/, dbt_packages/, etc.
dbt clean

# Installer packages (hvis brukt)
dbt deps

# Full reset
dbt clean && dbt deps && dbt run
```

### Sources
```bash
# Sjekk data-ferskhet
dbt source freshness

# Snapshot sources (SCD Type 2)
dbt snapshot
```

### Build (run + test i én kommando)
```bash
# Kjør og test alt
dbt build

# Bygg spesifikk modell med avhengigheter
dbt build --select +dim_customer
```

---

## 📝 Jinja-funksjoner

### ref() - Referer til andre modeller
```sql
-- Staging:
select * from {{ ref('stg_customers') }}

-- Med alias:
select * from {{ ref('stg_customers') }} as customers
```

### source() - Referer til rådata
```sql
-- Basic:
select * from {{ source('jaffle_alle', 'customers') }}

-- I en CTE:
with raw_customers as (
    select * from {{ source('jaffle_alle', 'customers') }}
)
select * from raw_customers
```

### config() - Konfigurer modell
```sql
-- Materialisering:
{{ config(materialized='table') }}

-- Flere konfigurasjoner:
{{ config(
    materialized='table',
    schema='marts',
    tags=['daily', 'customer']
) }}

select * from ...
```

### Conditional logic
```sql
{% if var('environment') == 'prod' %}
    select * from prod_table
{% else %}
    select * from dev_table
{% endif %}
```

---

## 📂 Prosjektstruktur

### Standard oppsett
```
dbt_project/
├── dbt_project.yml          # Prosjektkonfigurasjon
├── profiles.yml             # Database-tilkoblinger
├── models/
│   ├── staging/             # Source → Staging transformasjoner
│   │   ├── src_*.yml        # Source-definisjoner
│   │   ├── mdl_*.yml        # Modell-dokumentasjon
│   │   └── stg_*.sql        # Staging-modeller
│   ├── intermediate/        # Mellomliggende transformasjoner
│   │   └── int_*.sql
│   └── marts/               # Forretningsklare modeller
│       ├── fak_*.sql        # Fakta-tabeller
│       └── dim_*.sql        # Dimensjons-tabeller
├── tests/                   # Custom SQL tests
├── macros/                  # Gjenbrukbare SQL-funksjoner
├── snapshots/               # SCD Type 2 tracking
└── analyses/                # Ad-hoc analyser
```

### Navnekonvensjoner
```
stg_<source>_<entity>.sql     # Staging
int_<description>.sql          # Intermediate  
fak_<business_concept>.sql     # Fakta (marts)
dim_<business_concept>.sql     # Dimensjon (marts)
```

---

## 🧪 Testing

### Schema tests (i YAML)
```yaml
models:
  - name: stg_customers
    columns:
      - name: customer_id
        tests:
          - unique
          - not_null
          - relationships:
              to: ref('stg_orders')
              field: customer_id
      - name: email
        tests:
          - accepted_values:
              values: ['gmail.com', 'yahoo.com']
```

### Custom tests (SQL-filer i tests/)
```sql
-- tests/assert_positive_revenue.sql
select *
from {{ ref('fak_revenue') }}
where revenue < 0
```

### Source freshness
```yaml
sources:
  - name: jaffle_alle
    tables:
      - name: orders
        freshness:
          warn_after: {count: 12, period: hour}
          error_after: {count: 24, period: hour}
        loaded_at_field: _etl_loaded_at
```

---

## 📊 Materialiseringstyper

### View (default)
```sql
{{ config(materialized='view') }}
-- Lager en database view
-- Pros: Alltid fersk data
-- Cons: Kan være treg for komplekse queries
```

### Table
```sql
{{ config(materialized='table') }}
-- Lager en fysisk tabell
-- Pros: Rask å spørre
-- Cons: Data kun fersk etter dbt run
```

### Incremental
```sql
{{ config(materialized='incremental') }}

select * from {{ source('...', '...') }}

{% if is_incremental() %}
  where created_at > (select max(created_at) from {{ this }})
{% endif %}
-- Pros: Effektiv for store datasett
-- Cons: Mer kompleks logikk
```

### Ephemeral
```sql
{{ config(materialized='ephemeral') }}
-- Ingen fysisk tabell/view - inline som CTE
-- Pros: Mindre clutter i database
-- Cons: Kan ikke spørres direkte
```

---

## 📋 Selection Syntax

### Basic selection
```bash
--select <model_name>           # En modell
--select staging                # Alle i mappen
--select tag:daily              # Alle med tag
--select +model                 # Model + upstream
--select model+                 # Model + downstream  
--select +model+                # Model + både upstream og downstream
```

### Avansert selection
```bash
--select stg_customers orders   # Flere modeller
--select staging --exclude stg_temp  # Med unntak
--select @model                 # Model + direkte naboer
--select model1+ +model2        # Graf mellom to modeller
```

### Graph operators
```
+      upstream (avhengigheter)
-      downstream (som avhenger av)
@      direkte naboer
*      wildcard
```

---

## 🔑 YAML-struktur

### Source definition
```yaml
version: 2

sources:
  - name: source_name
    database: database_name
    schema: schema_name
    tables:
      - name: table_name
        description: "Beskrivelse"
        columns:
          - name: column_name
            description: "Beskrivelse"
            tests:
              - unique
              - not_null
```

### Model documentation
```yaml
version: 2

models:
  - name: model_name
    description: "Modell-beskrivelse"
    config:
      materialized: table
      schema: marts
    columns:
      - name: column_name
        description: "Kolonne-beskrivelse"
        tests:
          - unique
          - not_null
```

---

## 🎨 SQL Best Practices

### CTE-struktur
```sql
with

-- Import staging models
customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

-- Business logic
customer_orders as (
    select
        customer_id,
        count(*) as order_count
    from orders
    group by customer_id
),

-- Final transformation
final as (
    select
        c.customer_id,
        c.name,
        co.order_count
    from customers c
    left join customer_orders co
        on c.customer_id = co.customer_id
)

-- Simple select from final CTE
select * from final
```

### Formatering
```sql
-- ✅ GOOD:
select
    customer_id,
    first_name,
    last_name,
    email
from {{ ref('stg_customers') }}
where status = 'active'

-- ❌ AVOID:
select customer_id,first_name,last_name,email from {{ ref('stg_customers') }} where status='active'
```

---

## 🔧 Konfigurasjon

### dbt_project.yml
```yaml
name: my_project
version: '1.0.0'
config-version: 2

profile: my_project

model-paths: ["models"]
test-paths: ["tests"]
analysis-paths: ["analyses"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

models:
  my_project:
    staging:
      +materialized: view
      +schema: staging
    marts:
      +materialized: table
      +schema: marts
```

### profiles.yml
```yaml
my_project:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: './dev.duckdb'
      
    prod:
      type: duckdb
      path: './prod.duckdb'
```

---

## 🚀 Workflows

### Typisk utviklingsflyt
```bash
# 1. Lag ny modell
code models/staging/stg_new_table.sql

# 2. Kompiler og sjekk SQL
dbt compile --select stg_new_table

# 3. Kjør modellen
dbt run --select stg_new_table

# 4. Vis resultat
dbt show --select stg_new_table --limit 5

# 5. Legg til tester i YAML
code models/staging/mdl_staging.yml

# 6. Kjør tester
dbt test --select stg_new_table

# 7. Dokumenter
dbt docs generate && dbt docs serve

# 8. Commit
git add models/staging/
git commit -m "Add stg_new_table staging model"
```

### Deploy til produksjon
```bash
# Test lokalt først
dbt build

# Deploy til prod
dbt run --target prod
dbt test --target prod
```

---

## 📚 Nyttige lenker

- [dbt Documentation](https://docs.getdbt.com/)
- [dbt Discourse](https://discourse.getdbt.com/)
- [dbt Slack](https://www.getdbt.com/community/join-the-community/)
- [dbt Package Hub](https://hub.getdbt.com/)

---

## 💡 Pro-tips

1. **Alltid test tidlig og ofte** - `dbt run + dbt test` etter hver endring
2. **Bruk dbt show** for rask preview uten å bygge hele modellen
3. **Skriv SQL i CTEs** - lettere å lese og debugge
4. **Dokumenter underveis** - ikke vent til slutten
5. **Commit ofte** - små, atomiske endringer
6. **Bruk tags** for å organisere modeller
7. **Kjør dbt compile** før komplekse endringer
8. **Les compiled SQL** i `target/compiled/` når du debugger

---

**Print denne siden og ha den ved siden av deg mens du jobber! 📄**
