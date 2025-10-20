# 🚀 dbt Selvstudie - Lær ved å oppdage!

## Hvordan bruke denne guiden

Dette er ikke en vanlig instruksjonsmanual. Du kommer til å **oppdage** dbt-konseptene ved å:
- 🔍 Utforske eksisterende kode
- 🤔 Stille deg spørsmål underveis  
- 🧪 Eksperimentere med endringer
- ✅ Besvare kontrollspørsmål

## 📚 Læringsløypen

> **💡 Pro-tips for effektiv læring:**
> - Ta pauser mellom moduler for å la konseptene synke inn
> - Eksperimenter fritt - du kan alltid starte på nytt
> - Skriv ned refleksjoner og "aha-øyeblikk"
> - Diskuter med kolleger hvis mulig

### Oversikt over modulene
```
Modul 1: Utforsk prosjektet (15 min) ──┐
                                        │
Modul 2: Første modell (20 min) ───────┤
                                        ├─→ Grunnleggende dbt
Modul 3: Staging (25 min) ─────────────┤
                                        │
Modul 4: Sources (20 min) ─────────────┘

Modul 5: Ref-funksjonen (20 min) ──────┐
                                        ├─→ Avansert dbt
Modul 6: Testing (15 min) ─────────────┘
```

---

### Modul 1: Utforsk dbt-prosjektet
**Tid: 15 minutter**

#### 🔍 Oppdagelsesoppgave
Før du begynner, utforsk repositoriet:

**Refleksjonsspørsmål:**
- [ ] Hvilke mapper ser du i `intro_kurs/`?
- [ ] Hva tror du `dbt_project.yml` inneholder?
- [ ] Hvilke typer filer finner du i `models/`?

#### 💡 Mini-utfordring
Åpne terminalen og naviger til `intro_kurs`. Kjør:
```bash
dbt --help
```
**Spørsmål:** Hvilke kommandoer ser mest nyttige ut for deg?

---

### Modul 2: Din første modell - Oppdage mønsteret
**Tid: 20 minutter**

#### 🎯 Læringsmål
Du skal oppdage hvordan dbt transformerer data ved å bygge din første modell.

#### 🔍 Start med utforsking
1. Se på data i kildetabellene først:
```sql
-- Kjør dette i duckdb eller din database
SELECT * FROM jaffle_shop.customers LIMIT 5;
SELECT * FROM jaffle_shop.orders LIMIT 5;
```

**Refleksjonsspørsmål:**
- [ ] Hvilke felter ser du i hver tabell?
- [ ] Hvordan kan disse tabellene kobles sammen?
- [ ] Hva slags informasjon mangler for å få et komplett kundebilde?

#### 🧪 Bygg og eksperimenter

**Steg 1: Forstå strukturen**
Før du skriver koden, tenk over:
- Hva er en CTE (Common Table Expression)?
- Hvorfor dele opp SQL i flere `with`-blokker?
- Hva er fordelen med `final` CTE?

**Steg 2: Lag filen**
Opprett `models/dim_customer.sql` med denne koden:

```sql
with customers as
(
    select
        id as customer_id,
        first_name as name
    from jaffle_shop.customers
),
orders as (
    select
        id as order_id,
        user_id as customer_id,
        order_date as ordered_at
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

select * from final
```

**Steg 3: Kjør modellen**
```bash
cd intro_kurs
dbt run --select dim_customer
```

#### ❓ Kontrollspørsmål
Etter at du har kjørt `dbt run --select dim_customer`:

**Utforsk resultatet:**
```bash
dbt show -s dim_customer
```

**Reflekter:**
1. **Hvor mange rader fikk du?** ___ (Tips: Skal matche antall kunder)
2. **Finn kunden med flest bestillinger** - Hvilke verdier ser du?
3. **Hva skjer med kunder som aldri har bestilt?** (Se på `number_of_orders`)
4. **Hvorfor bruker vi `coalesce()` funksjonen?**

**Verifiser i databasen:**
```bash
# I VS Code terminal eller DuckDB CLI
duckdb dev.duckdb
# Kjør:
SELECT * FROM main.dim_customer ORDER BY number_of_orders DESC LIMIT 5;
```

#### 🏆 Utfordring
Kan du legge til et felt som viser hvor mange dager det er siden siste bestilling?

---

### Modul 3: Staging - Oppdage kildeabstraksjon
**Tid: 25 minutter**

#### 🤔 Reflekter først
Se på `dim_customer.sql` du nettopp laget. 

**Spørsmål:**
- Hva hvis tabellnavnet `jaffle_shop.customers` endres?
- Hva hvis du vil dokumentere hvor dataene kommer fra?
- Hvordan kan du gjøre koden mer gjenbrukbar?

#### 🔍 Oppdag staging-mønsteret
Les dette sitatet fra dbt-dokumentasjonen:
> "Staging models are the foundation of your project"

**Før du lager staging-modeller, tenk:**
- [ ] Hva er forskjellen på "rå data" og "klargjort data"?
- [ ] Hvilke transformasjoner bør skje tidlig vs sent i prosessen?

#### 🧪 Lag dine første staging-modeller

**Oppgave 1: Staging for customers**

Opprett filen `models/staging/stg_customers.sql`:

```sql
with customers_stg as (
    select 
        id as customer_id,
        first_name,
        last_name,
        first_name || ' ' || last_name as name
    from jaffle_shop.customers
)

select * from customers_stg
```

Kjør modellen:
```bash
dbt run --select stg_customers
```

**Oppgave 2: Staging for orders**

Opprett filen `models/staging/stg_orders.sql`:

```sql
with orders_stg as (
    select 
        id as order_id,
        user_id as customer_id,
        order_date as ordered_at,
        _etl_loaded_at
    from jaffle_shop.orders
)

select * from orders_stg
```

Kjør modellen:
```bash
dbt run --select stg_orders
```

#### 💡 Oppdagelsesmoment
Etter du har laget begge staging-modellene, kjør:
```bash
dbt run --select staging
```

**Reflekter:**
- [ ] Hvor mange modeller ble bygget?
- [ ] I hvilken rekkefølge ble de bygget?
- [ ] Hvordan ser dataene ut nå sammenlignet med rådata?

---

### Modul 4: Sources - Oppdage kildeabstraksjon
**Tid: 20 minutter**

#### 🎯 Problemløsning
Du har sikkert lagt merke til at du hardkoder tabellnavn. Hva om:
- Databasen heter noe annet i prod?
- Du vil teste datakvalitet på kildene?
- Du vil dokumentere hvor data kommer fra?

#### 🔍 Utforsk source-konseptet
Før du implementerer, se på denne koden:
```sql
from {{ source('jaffle_alle', 'customers') }}
```

**Gjett:**
- [ ] Hva tror du `jaffle_alle` refererer til?
- [ ] Hvor tror du denne informasjonen defineres?
- [ ] Hvilke fordeler gir denne tilnærmingen?

#### 🧪 Implementer sources

**Steg 1: Definer sources**

Lag filen `models/staging/src_jaffle_shop.yml`:

```yaml
sources:
  - name: jaffle_alle
    description: Treningsdatabase DuckDB
    database: dev
    schema: jaffle_shop
    tables:
      - name: orders
        description: Alle ordrene
        freshness:
          warn_after:
            count: 1
            period: day
        loaded_at_field: "CAST(order_date AS TIMESTAMP)"
      - name: customers
        description: Kundene våre
        columns:
          - name: id
            description: Primary key
            tests:
              - unique
              - not_null
  - name: stripe
    database: dev
    schema: stripe
    tables:
      - name: payment
        description: Betalinger utført
```

**Steg 2: Oppdater staging-modeller til å bruke sources**

Endre `stg_customers.sql` til:

```sql
with customers_stg as (
    select 
        id as customer_id,
        first_name,
        last_name,
        first_name || ' ' || last_name as name
    from {{ source('jaffle_alle', 'customers') }}
)

select * from customers_stg
```

Endre `stg_orders.sql` til:

```sql
with orders_stg as (
    select 
        id as order_id,
        user_id as customer_id,
        order_date as ordered_at,
        _etl_loaded_at
    from {{ source('jaffle_alle', 'orders') }}
)

select * from orders_stg
```

**Steg 3: Test det!**

```bash
# Kjør modellene på nytt
dbt run --select staging

# Kjør source-tester
dbt test --select source:jaffle_alle

# Sjekk data-ferskhet
dbt source freshness
```

#### ❓ Eksperimenter og lær
1. Oppdater `stg_customers.sql` til å bruke `{{ source() }}`
2. Kjør `dbt run --select stg_customers`
3. Kjør `dbt test` - hva skjer?

**Refleksjonsspørsmål:**
- [ ] Hvorfor feilet noen tester?
- [ ] Hvordan kan du fikse dem?
- [ ] Hva er verdien av å teste på kildenivå?

---

### Modul 5: Ref-funksjonen - Oppdage avhengigheter
**Tid: 20 minutter**

#### 🔄 Refaktorer dim_customer
Nå skal du oppdage kraften i `{{ ref() }}` funksjonen.

**Før du starter:**
- [ ] Hvordan kan `dim_customer` bruke staging-modellene du laget?
- [ ] Hva skjer hvis du endrer en staging-modell?
- [ ] Hvordan vet dbt hvilke modeller som må kjøres først?

#### 🧪 Oppdater fak_customer_orders.sql
```sql
-- Sammenlign disse to tilnærmingene:

-- Gammel måte:
-- from jaffle_shop.customers

-- Ny måte:  
-- from {{ ref('stg_customers') }}

-- Din oppgave: Oppdater hele modellen til å bruke ref()
```

#### 💡 Test avhengigheter
Kjør disse kommandoene og observer:
```bash
dbt run --select +fak_customer_orders  # Hva betyr + ?
dbt run --select fak_customer_orders+  # Hva betyr + her?
dbt run --select +fak_customer_orders+ # Og her?
```

**Oppdagelsesnotat:**
- [ ] I hvilken rekkefølge kjørte modellene?
- [ ] Hva skjedde med staging-modellene?

---

### Modul 6: Testing og dokumentasjon
**Tid: 15 minutter**

#### 🤔 Kvalitetsspørsmål
- Hvordan vet du at dataene dine er korrekte?
- Hva hvis det kommer duplikater i kildedataene?
- Hvordan dokumenterer du hva modellene gjør?

#### 🧪 Lag `mdl_jaffle_shop.yml`

**Utfordringsoppgave:**
Se på dine modeller og tenk:
1. Hvilke felter ALDRI kan være null?
2. Hvilke felter ALLTID skal være unike?
3. Hvilke forretningsregler skal alltid holde?

```yaml
version: 2

models:
  - name: stg_customers
    description: # TODO: Beskriv hva modellen gjør
    columns:
      - name: customer_id
        description: # TODO
        tests:
          # TODO: Hvilke tester er relevante?
```

#### ❓ Test og lær
```bash
dbt test --select +fak_customer_orders
```

**Hvis tester feiler:**
- [ ] Hva forteller feilmeldingen deg?
- [ ] Hvordan kan du fikse det?
- [ ] Er det data-problemet eller test-problemet?

---

## 🎉 Avslutning og refleksjon

### Hva har du oppdaget?
- [ ] Hvilke dbt-konsepter var mest overraskende?
- [ ] Hvordan vil du strukturere et dbt-prosjekt fra scratch?
- [ ] Hvilke spørsmål har du fortsatt?

### Neste steg
- Utforsk dbt dokumentasjon: `dbt docs generate && dbt docs serve`
- Eksperimenter med egne data
- Bli med i dbt community!

---

## 📝 Notater og refleksjoner
*Bruk dette området til å skrive ned tanker underveis...*
