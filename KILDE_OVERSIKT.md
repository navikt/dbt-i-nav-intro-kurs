# 🗄️ dbt Kilde-oversikt

## 📊 Datakilde-struktur

```
dev.duckdb
├── jaffle_shop (schema)
│   ├── customers          # Kundedata
│   └── orders             # Ordredata  
└── stripe (schema)
    └── payments           # Betalingsdata
```

## 🔍 Datakilde-diagram

```
┌────────────────────────────────────────────────────────────┐
│  EKSTERNE DATAKILDER (CSV FILES)                           │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  .duckdb/data/                                             │
│  ┌──────────────┬──────────────┬──────────────┐            │
│  │              │              │              │            │
│  │ customers.csv│  orders.csv  │ payments.csv │            │
│  │              │              │              │            │
│  └──────────────┴──────────────┴──────────────┘            │
│                                                            │
└─────────────────────┬───────────────────┬──────────────────┘
                      │                   │
                      │ import_data.sql   │
                      ▼                   ▼
┌───────────────────────────────────────────────────-──────────┐
│  DUCKDB - LOCAL DEVELOPMENT                                  │
├─────────────────────────────────────────────────-────────────┤
│                                                              │
│  jaffle_shop (schema)           stripe (schema)              │
│  ┌──────────────────────-┐        ┌──────────────────────┐   │
│  │ customers             │        │ payments             │   │
│  │ ┌──────────────────┐  │        │ ┌──────────────────┐ │   │
│  │ │ id (int)         │  │        │ │ id (int)         │ │   │
│  │ │ first_name (str) │  │        │ │ orderid (int)    │ │   │
│  │ │ last_name (str)  │  │        │ │ paymentmethod    │ │   │
│  │ └──────────────────┘  │        │ │ status (str)     │ │   │
│  │                       │        │ │ amount (int)     │ │   │
│  │ orders                │        │ │ created (date)   │ │   │
│  │ ┌──────────────────┐  │        │ └──────────────────┘ │   │
│  │ │ id (int)         │  │        └──────────────────────┘   │
│  │ │ user_id (int)    │  │                                   │
│  │ │ order_date (date)│  │                                   │
│  │ │ status (str)     │  │                                   │
│  │ │ _etl_loaded_at   │  │                                   │
│  │ └──────────────────┘  │                                   │
│  └──────────────────────-┘                                   │
│                                                              │
│                                                              │
└────────────────────────────-─────────────────────────────────┘
```

## 📋 Kilde-detaljer

### jaffle_shop.customers
**Formål:** Grunnleggende kundeinformasjon

**Struktur:**
```sql
CREATE TABLE jaffle_shop.customers (
    id BIGINT,              -- Primærnøkkel, unik kunde-ID
    first_name VARCHAR,      -- Fornavn
    last_name VARCHAR        -- Etternavn
);
```

**Datakvalitet:**
- 100 rader totalt (kunde ID 1-100)
- Alle kunder har fornavn og etternavn
- Ingen duplikater på ID

**Eksempeldata:**
```
id | first_name | last_name
1  | Michael    | P.
2  | Shawn      | M.
3  | Kathleen   | P.
```

**Brukes til:**
- Kundeidentifikasjon
- Navn for rapportering
- Kobling med ordredata

---

### jaffle_shop.orders
**Formål:** Ordrehistorikk og transaksjonsdata

**Struktur:**
```sql
CREATE TABLE jaffle_shop.orders (
    id BIGINT,                    -- Primærnøkkel, unik ordre-ID  
    user_id BIGINT,               -- Fremmednøkkel til customers.id
    order_date DATE,               -- Bestillingsdato
    status VARCHAR,                -- Ordrestatus
    _etl_loaded_at TIMESTAMP       -- ETL metadata
);
```

**Datakvalitet:**
- 99 ordrer totalt (ordre ID 1-99, mangler noen numre)
- Dato-spenn: 2018-01-01 til 2018-04-09
- Alle ordrer har gyldig customer reference

**Status-verdier:**
- `completed` - Fullført (majoriteten)
- `shipped` - Sendt
- `placed` - Bestilt
- `returned` - Returnert  
- `return_pending` - Venter på retur

**Eksempeldata:**
```
id | user_id | order_date | status    | _etl_loaded_at
1  | 1       | 2018-01-01 | returned  | 2021-11-19 05:21:58.564126 UTC
2  | 3       | 2018-01-02 | completed | 2021-11-19 05:21:58.564126 UTC
```

**Relasjon:**
- `user_id` → `customers.id` (mange-til-en)

---

### stripe.payments
**Formål:** Betalingsinformasjon og transaksjonsdetaljer

**Struktur:**
```sql
CREATE TABLE stripe.payments (
    id BIGINT,                    -- Primærnøkkel, unik betalings-ID
    orderid BIGINT,               -- Fremmednøkkel til orders.id
    paymentmethod VARCHAR,         -- Betalingsmåte
    status VARCHAR,                -- Betalingsstatus
    amount BIGINT,                -- Beløp (i øre/cent)
    created DATE                   -- Betalingsdato
);
```

**Datakvalitet:**
- 113 betalinger totalt
- Dato-spenn: 2018-01-12 til 2018-04-03
- Flere betalinger kan tilhøre samme ordre

**Betalingsmåter:**
- `credit_card` - Kredittkort (mest vanlig)
- `bank_transfer` - Bankoverføring
- `coupon` - Kupong/rabattkode
- `gift_card` - Gavekort

**Status-verdier:**
- `success` - Vellykket betaling
- `fail` - Feilet betaling

**Beløp:**
- Lagret i øre/cent (må deles på 100 for kroner)
- Spenn: 0 til 2600 (0 til 26,00 kr)

**Eksempeldata:**
```
id | orderid | paymentmethod | status  | amount | created
80 | 65      | credit_card   | success | 0      | 2018-03-08
93 | 77      | credit_card   | success | 0      | 2018-03-21
```

**Relasjon:**
- `orderid` → `orders.id` (mange-til-en)

---

## 🔗 Relasjonsdiagram

```
customers (1) ←──── (∞) orders (1) ←──── (∞) payments
    ↑                      ↑                     ↑
  id = user_id           id = orderid        Betalingsdetaljer
```

**Konkret:**
```
jaffle_shop.customers.id → jaffle_shop.orders.user_id → stripe.payments.orderid
```

**Eksempel dataflyt:**
```
Customer #1 (Michael P.) - jaffle_shop.customers
└── Order #1 (2018-01-01, returned) - jaffle_shop.orders
└── Order #37 (2018-02-10, completed) - jaffle_shop.orders
    └── Payment #37 (credit_card, success, 1000) - stripe.payments
```
