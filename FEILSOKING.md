# 🚨 Vanlige feil og løsninger

## Feilsøkingsguide for dbt-nybegynnere

Denne guiden dekker de vanligste feilene du vil møte i kurset, og hvordan du løser dem.

---

## Databasetilkobling

### ❌ Feil: "Could not set lock on file"

```
Runtime Error
  IO Error: Could not set lock on file "/workspaces/dbt-i-nav-intro-kurs/dev.duckdb": Conflicting lock is held in /usr/local/python/3.12.1/bin/python3.12 (PID 60361). See also https://duckdb.org/docs/connect/concurrency
```

**Årsak:**

Du har en åpen databasetilkobling. Husk å koble fra databasen. Se [Duckcli Quick Reference](DUCKCLI_REFERENCE.md#koble-på-databasen) for mer info.

**Løsning:**

Finn den åpne databasetilkoblingen å lukk den.

```
exit
```

## 📁 Filplassering og struktur

### ❌ Feil: "Model not found"
```
Compilation Error: Model 'stg_customers' depends on a node named 'stg_customers' which was not found
```

**Årsaker:**
1. Filen er plassert feil sted
2. Filnavnet stemmer ikke med modellnavnet
3. Filen har feil filtype

**Løsning:**
```bash
# Sjekk at filen ligger riktig:
ls models/staging/stg_customers.sql

# Filnavnet UTEN .sql må matche ref():
# Fil: stg_customers.sql
# Ref: {{ ref('stg_customers') }}  ✅

# IKKE: {{ ref('stg_customers.sql') }}  ❌
```

---

### ❌ Feil: "Source not found"
```
Compilation Error: Source 'jaffle_alle.customers' was not found
```

**Årsaker:**
1. Source YAML-filen ligger feil sted
2. Source-navnet er feilstavet
3. YAML-filen har feil struktur

**Løsning:**
```bash
# Sjekk at source-filen ligger i models/ (eller undermappe)
ls models/staging/src_jaffle_shop.yml

# Sjekk YAML-strukturen:
```

```yaml
sources:
  - name: jaffle_alle  # Dette navnet brukes i source()
    tables:
      - name: customers  # Dette navnet brukes i source()
```

```sql
-- I SQL-filen:
from {{ source('jaffle_alle', 'customers') }}
--            ^^^^^^^^^^^^    ^^^^^^^^^
--            source name     table name
```

---

## 🔧 SQL og Jinja-feil

### ❌ Feil: "Compilation Error: unexpected end of template"
```
Compilation Error in model dim_customer (models/dim_customer.sql)
  unexpected end of template
```

**Årsaker:**
1. Manglende `}}` eller `%}` i Jinja
2. Feil i ref() eller source() syntaks

**Løsning:**
```sql
-- ❌ FEIL:
from {{ ref('stg_customers')

-- ✅ RIKTIG:
from {{ ref('stg_customers') }}

-- ❌ FEIL:
{% if is_incremental() %
  where ...
{% endif %}

-- ✅ RIKTIG:
{% if is_incremental() %}
  where ...
{% endif %}
```

---

### ❌ Feil: SQL syntax error
```
Database Error in model dim_customer (models/dim_customer.sql)
  syntax error at or near "from"
```

**Vanlige årsaker:**

**1. Manglende komma i SELECT:**
```sql
-- ❌ FEIL:
select
    customer_id
    name,  -- Mangler komma på forrige linje!
    email

-- ✅ RIKTIG:
select
    customer_id,
    name,
    email
```

**2. Ekstra komma på slutten:**
```sql
-- ❌ FEIL:
select
    customer_id,
    name,  -- Ekstra komma!
from customers

-- ✅ RIKTIG:
select
    customer_id,
    name
from customers
```

**3. CTE (WITH) syntax:**
```sql
-- ❌ FEIL:
with customers as (
    select * from {{ ref('stg_customers') }}
)
with orders as (  -- Kan ikke ha flere 'with'!
    select * from {{ ref('stg_orders') }}
)

-- ✅ RIKTIG:
with customers as (
    select * from {{ ref('stg_customers') }}
),  -- Komma mellom CTEs!
orders as (
    select * from {{ ref('stg_orders') }}
)
select * from customers
```

---

## 🧪 Test-feil

### ❌ Feil: "FAIL unique test"
```
Failure in test unique_stg_customers_customer_id
  Got 2 results, configured to fail if != 0
```

**Årsak:** Du har duplikater i kolonnen.

**Feilsøking:**
```sql
-- Finn duplikatene:
select 
    customer_id, 
    count(*) as cnt
from {{ ref('stg_customers') }}
group by customer_id
having count(*) > 1;
```

**Løsninger:**
1. **Fiks dataene** - fjern duplikater i source eller staging
2. **Legg til DISTINCT** hvis duplikater er OK
3. **Fjern testen** hvis unique ikke er et krav

```sql
-- Eksempel: Fjern duplikater
with deduped as (
    select distinct
        customer_id,
        name,
        email
    from raw_data
)
select * from deduped
```

---

### ❌ Feil: "FAIL not_null test"
```
Failure in test not_null_stg_customers_name
  Got 5 results, configured to fail if != 0
```

**Årsak:** Du har NULL-verdier i kolonnen.

**Feilsøking:**
```sql
-- Finn NULL-verdiene:
select *
from {{ ref('stg_customers') }}
where name is null;
```

**Løsninger:**

```sql
-- 1. Filter ut NULL-verdier:
select *
from raw_data
where name is not null

-- 2. Erstatt NULL med default-verdi:
select
    customer_id,
    coalesce(name, 'Unknown') as name
from raw_data

-- 3. Fjern testen hvis NULL er OK
```

---

## 🗂️ Konfigurasjonsfeil

### ❌ Feil: "Could not find profile named 'intro_kurs'"
```
Runtime Error
  Could not find profile named 'intro_kurs'
```

**Årsak:** `profiles.yml` mangler eller er feil konfigurert.

**Løsning:**

```bash
# Sjekk at profiles.yml finnes:
ls ~/.dbt/profiles.yml

# ELLER i prosjektmappen (intro_kurs/profiles.yml)
```

**Verifiser at `dbt_project.yml` og `profiles.yml` matcher:**

```yaml
# dbt_project.yml
name: intro_kurs
profile: intro_kurs  # Dette navnet...

# profiles.yml
intro_kurs:  # ...må matche dette!
  outputs:
    dev:
      type: duckdb
      path: ../dev.duckdb
```

---

### ❌ Feil: "Database 'dev' does not exist"
```
Database Error
  Catalog Error: Database "dev" does not exist!
```

**Årsak:** DuckDB-databasen finnes ikke eller path er feil.

**Løsning:**

```bash
# Sjekk at dev.duckdb finnes:
ls dev.duckdb

# Sjekk at path i profiles.yml stemmer:
# Hvis profiles.yml er i intro_kurs/:
path: ../dev.duckdb  # Går opp ett nivå

# Hvis profiles.yml er i ~/.dbt/:
path: /full/path/to/dev.duckdb
```

---

## 🔄 Kjørefeil

### ❌ Feil: "This operation cannot be used on a VIEW"
```
Database Error
  This operation cannot be performed on a VIEW
```

**Årsak:** Du prøver å kjøre incremental eller andre operasjoner på en view.

**Løsning:**

```sql
-- Sett materialisering til table:
{{ config(materialized='table') }}

select * from ...
```

---

### ❌ Feil: Sirkulære avhengigheter
```
Compilation Error
  Found a cycle: stg_customers -> dim_customer -> stg_customers
```

**Årsak:** Modeller refererer til hverandre i en sirkel.

**Løsning:**
- Gjennomgå ref() i begge modeller
- Data må flyte i én retning: sources → staging → intermediate → marts
- Tegn et diagram av avhengighetene

```
✅ RIKTIG:
source → stg_customers → dim_customer

❌ FEIL:
stg_customers ⟷ dim_customer
```

---

## 📦 YAML-feil

### ❌ Feil: "YAML parsing error"
```
Runtime Error
  Error reading intro_kurs/models/staging/src_jaffle_shop.yml - Runtime Error
    Syntax error near line 5
```

**Vanlige YAML-feil:**

**1. Feil innrykk:**
```yaml
# ❌ FEIL:
sources:
- name: jaffle_alle  # Mangler innrykk!
  tables:
  - name: customers

# ✅ RIKTIG:
sources:
  - name: jaffle_alle  # 2 spaces
    tables:
      - name: customers  # 4 spaces under tables
```

**2. Manglende kolon:**
```yaml
# ❌ FEIL:
sources
  - name: jaffle_alle

# ✅ RIKTIG:
sources:
  - name: jaffle_alle
```

**3. Feil quotes:**
```yaml
# ❌ FEIL:
description: "En beskrivelse med "quotes" inni"

# ✅ RIKTIG:
description: "En beskrivelse med 'quotes' inni"
# ELLER:
description: 'En beskrivelse med "quotes" inni'
# ELLER:
description: En beskrivelse uten quotes
```

---

## 🔍 Debugging-strategi

### Steg-for-steg feilsøking:

**1. Les feilmeldingen nøye**
```
Where: models/marts/fak_customer_orders.sql
What: Compilation Error
Why: Model 'stg_customers' was not found
```

**2. Kjør dbt compile for å se generated SQL**
```bash
dbt compile --select fak_customer_orders

# Sjekk compiled SQL:
cat target/compiled/intro_kurs/models/marts/fak_customer_orders.sql
```

**3. Test SQL direkte i database**
```bash
duckdb dev.duckdb

# Copy-paste den compiled SQL og kjør
```

**4. Bruk debug-modus**
```bash
dbt run --select dim_customer --debug
```

**5. Sjekk avhengigheter**
```bash
# Se hva modellen avhenger av:
dbt ls --select +dim_customer

# Se hva som avhenger av modellen:
dbt ls --select dim_customer+
```

---

## 💡 Pro-tips for å unngå feil

### ✅ Best practices:

**1. Konsistent navngiving:**
```
stg_<source>_<entity>.sql     # staging
int_<description>.sql          # intermediate
fak_<business_concept>.sql     # marts/facts
dim_<business_concept>.sql     # marts/dimensions
```

**2. Test tidlig og ofte:**
```bash
# Etter hver endring:
dbt run --select <model>
dbt test --select <model>
```

**3. Bruk dbt compile først:**
```bash
# Se generated SQL før du kjører:
dbt compile --select <model>
```

**4. Start enkelt, bygg kompleksitet:**
```sql
-- Start med:
select * from {{ source('...', '...') }}

-- Legg til transformasjoner gradvis:
select 
    id as customer_id,
    name
from {{ source('...', '...') }}
```

**5. Versjonskontroll:**
```bash
# Commit ofte, med gode meldinger:
git add models/staging/stg_customers.sql
git commit -m "Add stg_customers staging model"
```

---

## 🆘 Når alt annet feiler

**1. Rydd opp og start på nytt:**
```bash
git restore ../dev.duckdb
dbt clean
dbt deps
dbt run
```

**2. Sjekk at miljøet fungerer:**
```bash
dbt debug
```

**3. Se på eksempelkode:**
- Sammenlign med Kursdoc.md
- Sjekk dbt dokumentasjon
- Se på working examples i andre prosjekter

**4. Spør om hjelp:**
- Legg ved feilmelding (full output)
- Del relevant kode
- Forklar hva du har prøvd

---

## 📚 Ressurser

- [dbt Error Messages](https://docs.getdbt.com/guides/best-practices/debugging-errors)
- [dbt Troubleshooting](https://docs.getdbt.com/docs/build/build-errors)
- [dbt Discourse](https://discourse.getdbt.com/) - Community forum
