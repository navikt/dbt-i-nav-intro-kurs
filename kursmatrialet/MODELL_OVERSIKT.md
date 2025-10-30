# 📊 dbt Modell-oversikt

## 🏗️ Prosjektstruktur du skal bygge

```
intro_kurs/
├── models/
│   ├── staging/
│   │   ├── src_jaffle_shop.yml       # Source-definisjoner
│   │   ├── mdl_jaffle_shop.yml       # Modell-dokumentasjon og tester
│   │   ├── stg_customers.sql         # Klargjøring av kundedata
│   │   └── stg_orders.sql            # Klargjøring av ordredata
│   │
│   └── marts/
│       └── fak_customer_orders.sql   # Forretningslogikk - kunde-ordrestatistikk
│
└── dbt_project.yml                   # Prosjektkonfigurasjon
```

## 🔄 Dataflyt-diagram

```
┌─────────────────────────────────────────────────────────────┐
│  RAW DATA (DuckDB)                                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  jaffle_shop.customers          jaffle_shop.orders          │
│  ┌──────────────┐               ┌──────────────┐            │
│  │ id           │               │ id           │            │
│  │ first_name   │               │ user_id      │            │
│  │ last_name    │               │ order_date   │            │
│  └──────────────┘               └──────────────┘            │
│                                                             │
└──────────────────────┬───────────────────┬──────────────────┘
                       │                   │
                       │ {{ source() }}    │
                       ▼                   ▼
┌─────────────────────────────────────────────────────────────┐
│  STAGING LAYER - Klargjøring                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  stg_customers                 stg_orders                   │
│  ┌──────────────────┐          ┌──────────────────┐         │
│  │ customer_id      │          │ order_id         │         │
│  │ first_name       │          │ customer_id      │         │
│  │ last_name        │          │ ordered_at       │         │
│  │ name (computed)  │          │ _etl_loaded_at   │         │
│  └──────────────────┘          └──────────────────┘         │
│                                                             │
│  🎯 Hensikt: Standardisering, navneendring, basic cleanup   │
│                                                             │
└──────────────────────┬─────────────────┬─────────────-──────┘
                       │                 │
                       │  {{ ref() }}    │
                       ▼                 ▼
┌─────────────────────────────────────────────────────────────┐
│  MARTS LAYER - Forretningslogikk                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  fak_customer_orders                                        │
│  ┌──────────────────────────────────┐                       │
│  │ customer_id                      │                       │
│  │ name                             │                       │
│  │ first_order_date                 │                       │
│  │ most_recent_order_date           │                       │
│  │ number_of_orders                 │                       │
│  └──────────────────────────────────┘                       │
│                                                             │
│  🎯 Hensikt: Beregninger, aggregeringer, business logic     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                       │
                       ▼
                   BI TOOLS
             (Tableau, Power BI, etc.)
```

## 📋 Modell-detaljer

### Staging Layer

#### stg_customers
**Formål:** Klargjør kundedata for videre bruk

**Transformasjoner:**
- Omdøp `id` → `customer_id` (konsistent naming)
- Kombiner `first_name + last_name` → `name`
- Velg bare relevante kolonner

**Tester:**
- `customer_id` må være unique og not_null
- `name` må være not_null

**Brukes av:**
- `fak_customer_orders`

---

#### stg_orders
**Formål:** Klargjør ordredata for videre bruk

**Transformasjoner:**
- Omdøp `id` → `order_id`
- Omdøp `user_id` → `customer_id`
- Omdøp `order_date` → `ordered_at`
- Behold metadata (`_etl_loaded_at`)

**Tester:**
- `order_id` må være unique og not_null
- `customer_id` må være not_null

**Brukes av:**
- `fak_customer_orders`

---

### Marts Layer

#### fak_customer_orders
**Formål:** Kombinerer kunde- og ordredata til forretningsklar innsikt

**Forretningslogikk:**
- Beregn antall bestillinger per kunde
- Finn første og siste bestillingsdato
- Håndter kunder uten bestillinger (LEFT JOIN + COALESCE)

**Avhengigheter:**
- `stg_customers`
- `stg_orders`

**Output:** En rad per kunde med ordre-statistikk

---

## 🧪 Test-strategi

### Source-nivå tester
```yaml
# I src_jaffle_shop.yml
- unique og not_null på customers.id
- freshness-sjekk på orders (data ikke eldre enn 1 dag)
```

### Staging-nivå tester
```yaml
# I mdl_jaffle_shop.yml
stg_customers:
  - customer_id: unique, not_null
  - name: not_null

stg_orders:
  - order_id: unique, not_null
  - customer_id: not_null
```

### Marts-nivå tester
```yaml
# Kan legges til senere
fak_customer_orders:
  - customer_id: unique, not_null
  - number_of_orders: >= 0
  - first_order_date <= most_recent_order_date
```

---

## 🎯 Design-prinsipper

### Staging Layer
✅ **GÅR:**
- Velge og omdøpe kolonner
- Enkle datatype-konverteringer
- Filtrere ut ugyldige rader
- Standardisere formater (datoer, tekst)

❌ **IKKE GÅR:**
- JOIN med andre tabeller
- Aggregeringer (SUM, COUNT, etc.)
- Kompleks forretningslogikk
- Derived/calculated felter (med unntak av enkle kombinasjoner)

### Marts Layer
✅ **GÅR:**
- JOIN mellom staging-modeller
- Aggregeringer og beregninger
- Forretningslogikk
- Denormalisering for rapportering

❌ **IKKE GÅR:**
- Direkte referanser til sources (bruk staging)
- Hardkoding av verdier
- Uklar navngiving

---

## 📊 Materialiserings-strategi

### For dette kurset:

| Modell | Materialisering | Begrunnelse |
|--------|----------------|-------------|
| `stg_customers` | View (default) | Liten tabell, kjapp å kjøre |
| `stg_orders` | View (default) | Mellomlagring, liten overhead |
| `fak_customer_orders` | Table | Sluttprodukt, kan cache for performance |

### I produksjon kunne du vurdert:

```yaml
# dbt_project.yml
models:
  intro_kurs:
    staging:
      +materialized: view
    marts:
      +materialized: table
      
    # For store datasett:
    # marts:
    #   large_model:
    #     +materialized: incremental
```

---

## 🔄 Kjøre-rekkefølge

dbt beregner automatisk kjørerekkefølge basert på `ref()` og `source()`:

```
1. Sources (jaffle_shop.customers, jaffle_shop.orders)
   ↓
2. Staging (stg_customers, stg_orders) - kan kjøres parallelt
   ↓
3. Marts (fak_customer_orders)
```

**Verifiser med:**
```bash
dbt ls --select +fak_customer_orders
```

---

## 💡 Utvidelsesmuligheter

### Ekstra modeller du kan lage:

**Intermediate layer:**
```
models/intermediate/
├── int_order_enriched.sql       # Orders beriket med kunde-info
└── int_customer_segments.sql    # Kunde-segmentering
```

**Flere marts:**
```
models/marts/
├── fak_customer_orders.sql      # (eksisterende)
├── fak_daily_revenue.sql        # Daglig inntekt
└── fak_product_performance.sql  # Produktanalyse
```

**Tillegg fra Stripe data:**
```
models/staging/
├── stg_payments.sql             # Fra stripe.payment
└── ...

models/marts/
└── fak_payment_analysis.sql     # Betalingsanalyse
```

---

## 📚 Referanser

- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)
- [How we structure our dbt projects](https://docs.getdbt.com/guides/best-practices/how-we-structure/1-guide-overview)
- [The dbt viewpoint](https://docs.getdbt.com/community/resources/viewpoint)
