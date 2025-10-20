# 🧠 dbt Quiz og Refleksjonsøvelser

## 🎯 Hvordan bruke denne guiden

Dette er **ikke** en tradisjonell test, men refleksjonsverktøy for:
- 🤔 Å sjekke din egen forståelse  
- 💡 Å oppdage kunnskapshull
- 🎯 Å fokusere videre læring
- 🗣️ Å diskutere med andre

**Instruksjoner:**
1. Svar ærlig - det er ikke poeng for "riktige" svar
2. Diskuter svarene med andre hvis mulig
3. Kom tilbake og svar på nytt etter mer erfaring

---

## 📚 Modul 1: Grunnleggende konsepter

### 🤔 Refleksjonsspørsmål

**1. Konseptuell forståelse**
Du forklarer dbt til en kollega som aldri har hørt om det. Hvilken analogi ville du brukt?
- [ ] A) Som et byggverktøy for data-hus
- [ ] B) Som en oppskrift for å lage mat
- [ ] C) Som en fabrikk som forvandler råmaterialer
- [ ] D) Annet: _________________

*Refleksjon: Hvorfor valgte du denne analogien?*

**2. Praktisk forståelse**
Du kjører `dbt run --select dim_customer` og får denne feilen:
```
Compilation Error: Model 'dim_customer' depends on model 'stg_customers' which was not found
```

Hva vil du gjøre først?
- [ ] A) Slette dim_customer og starte på nytt
- [ ] B) Sjekke om stg_customers.sql eksisterer
- [ ] C) Kjøre `dbt clean` og prøve igjen
- [ ] D) Endre ref() til hardkodet tabellnavn

*Refleksjon: Hvilken feilsøkingsstrategi bruker du generelt?*

### 🧪 Scenariobaserte spørsmål

**Scenario: Den mystiske tabellen**
Du arver et dbt-prosjekt og ser denne modellen:
```sql
select customer_id, sum(order_value) as total_spent
from {{ ref('mysterious_model') }}  
group by customer_id
```

Mysteriet: Modellen `mysterious_model.sql` finnes ikke i prosjektet!

**Diskusjonspoeng:**
1. Hvordan ville du undersøkt dette?
2. Hva kan være årsaken?
3. Hvordan kan slike problemer unngås?

---

## 🏗️ Modul 2: Staging og kilder

### 🎮 Debugging Challenge

**Situasjon:** Din kollega sier:
> "Jeg forstår ikke staging. Hvorfor kan jeg ikke bare bruke tabellene direkte?"

**Din oppgave:** Lag 3 konkrete eksempler som viser verdien av staging.

*Eksempel 1:*
_____________________

*Eksempel 2:*
_____________________

*Eksempel 3:*
_____________________

### 🤔 Arkitekturspørsmål

**Scenario:** Du skal lage staging for denne tabellen:
```
customers
- id: 1, 2, 3...
- full_name: "Lars Hansen", "Kari Berg"  
- email: "lars@email.com", "KARI@EMAIL.COM"
- created: "2023-01-15", "2023-02-20"
- status: "active", "INACTIVE", "pending"
```

**Design-spørsmål:**
1. Hvilke transformasjoner bør gjøres i staging?
2. Hvilke bør vente til senere lag?
3. Hvordan ville du håndtert inkonsekvente data-format?

**Tenk høyt:** 
- Når er det OK å endre data i staging vs senere?
- Hvordan balanserer du "ren" staging vs praktiske behov?

---

## 🔗 Modul 3: Referanser og avhengigheter  

### 🧩 Dependency Puzzle

**Gitt disse modellene:**
```
A → B → D
A → C → D  
B → E
C → E
```

**Quiz:**
1. Hvilken rekkefølge vil dbt kjøre modellene i?
2. Hva skjer hvis modell C feiler?
3. Hvilken `--select` kommando kjører bare A, B og D?

**Svar:**
1. _____________________
2. _____________________  
3. _____________________

### 🤔 Refactoring Refleksjon

**Før refactoring:**
```sql
select * from raw_schema.customer_table
join raw_schema.order_table on ...
```

**Etter refactoring:**
```sql  
select * from {{ ref('stg_customers') }}
join {{ ref('stg_orders') }} on ...
```

**Refleksjonspoeng:**
- Hvilke fordeler gav refaktoringen?
- Hvilke nye utfordringer introduserte den?
- Når er ref() overkill?

---

## 🧪 Modul 4: Testing og kvalitet

### 🔍 Test Strategy Workshop

**Scenario:** Du har denne modellen:
```sql
-- customer_lifetime_value.sql
select 
    customer_id,
    first_order_date,
    last_order_date, 
    total_orders,
    total_spent,
    avg_order_value
from ...
```

**Workshop-oppgaver:**

**1. Identifiser test-kandidater**
Hvilke felter/regler bør testes?
- [ ] customer_id (unique/not_null)
- [ ] first_order_date ≤ last_order_date  
- [ ] total_orders > 0 (hvis kunden har bestilt)
- [ ] total_spent = total_orders × avg_order_value
- [ ] Annet: _________________

**2. Prioriter testene**
Ranger 1-5 (hvor 1 = mest kritisk):
- [ ] Data-integritet (unique, not_null)
- [ ] Forretningslogikk (beregninger)
- [ ] Referanse-integritet (foreign keys)
- [ ] Data-ferskhet (freshness)
- [ ] Performance (kjøretid)

**3. Design custom test**
Skriv en custom test som sikrer at ingen kunde har negativ total_spent:

```sql
-- tests/assert_positive_spending.sql
-- Din kode her
```

### 🚨 Failure Analysis

**Du får denne test-feilen:**
```
FAIL 1 unique_customer_lifetime_value_customer_id
Got 1 result, configured to fail if != 0
```

**Feilsøking workflow:**
1. Hva vil du gjøre først?
2. Hvilke spørsmål vil du stille?
3. Hvordan vil du fikse det?

---

## 📊 Modul 5: Performance og optimalisering

### 🏎️ Performance Quiz

**Scenario:** Din modell tar 45 minutter å kjøre.

**Hvilke optimaliseringsstrategier ville du prøvd? (Ranger 1-6)**
- [ ] Endre fra view til table materialisering
- [ ] Legge til WHERE-klausul for å filtrere data
- [ ] Bruke incremental materialisering  
- [ ] Optimalisere JOIN-strategien
- [ ] Partisjonere store tabeller
- [ ] Cache mellomresultater

**Refleksjon:** Hvordan ville du målt effekten av hver optimalisering?

### 🔄 Incremental Logic Challenge

```sql
{{ config(materialized='incremental') }}

select * from {{ source('app', 'events') }}
{% if is_incremental() %}
  where created_at > (select max(created_at) from {{ this }})
{% endif %}
```

**Spørsmål:**
1. Hva skjer på første kjøring?
2. Hva skjer hvis source-data endrer historiske records?  
3. Hvordan ville du håndtert late-arriving data?

---

## 🎯 Anvendelsesorienterte scenarioer

### 🏢 Enterprise Scenario

**Du jobber i et stort team med dette oppsettet:**
- 50+ dbt-modeller
- 5 utviklere
- Data oppdateres hver time
- Rapporter må være klare til 08:00 hver dag

**Diskusjonspoeng:**
1. Hvordan ville du organisert koden?
2. Hvilken test-strategi ville du implementert?
3. Hvordan ville du håndtert deployment?
4. Hva med CI/CD pipeline?

### 🔧 Maintenance Scenario  

**6 måneder etter lansering:**
- Modeller kjører sakte
- Test feiler sporadisk  
- Nye kilder legges til ukentlig
- Dokumentasjon er utdatert

**Refactoring plan:**
1. Hvilke problemer ville du prioritert?
2. Hvordan ville du hindret de samme problemene igjen?
3. Hvilke prosesser ville du endret?

---

## 🎤 Presentasjonsøvelser

### 🎯 Elevator Pitch
**Scenario:** Du møter data-teamets leder i heisen (30 sekunder).

**Oppgave:** Forklar verdien av dbt på 30 sekunder.

*Din pitch:*
_____________________

### 👥 Team Onboarding
**Scenario:** Du skal lære opp 3 nye teammedlemmer i dbt.

**Planlegg 30-minutters introduksjon:**
1. Hva er de 3 viktigste konseptene å dekke?
2. Hvilken live-demo ville du vist?
3. Hvilke oppgaver ville du gitt dem?

---

## 🔄 Selvrefleksjon og utvikling

### 📈 Kompetansevurdering

**Ranger deg selv (1-5 skala):**

**Tekniske ferdigheter:**
- [ ] SQL og data-transformering
- [ ] dbt-kommandoer og workflow
- [ ] YAML-konfigurasjon  
- [ ] Testing og kvalitetssikring
- [ ] Performance-optimalisering

**Prosess-forståelse:**
- [ ] ELT vs ETL konsepter
- [ ] Data warehouse arkitektur
- [ ] Software development lifecycle
- [ ] Git og versjonskontroll
- [ ] CI/CD prinsipper

**Samarbeid og kommunikasjon:**
- [ ] Kode-dokumentasjon
- [ ] Peer review
- [ ] Kunnskapsoverføring
- [ ] Prosjektplanlegging
- [ ] Stakeholder-kommunikasjon

### 🎯 Utviklingsmål

**Basert på selvvurderingen over:**

**Mine top 3 utviklingsområder:**
1. _____________________
2. _____________________
3. _____________________

**Konkrete tiltak neste 4 uker:**
1. _____________________
2. _____________________  
3. _____________________

**Success-kriterier:**
1. _____________________
2. _____________________
3. _____________________

---

## 🤝 Gruppeaktiviteter

### 🔄 Code Review Workshop

**Oppgave:** Review denne modellen med en partner:

```sql
select c.customer_id, c.first_name, c.last_name,
       o.order_date, o.order_total,
       case when o.order_total > 1000 then 'VIP' 
            when o.order_total > 500 then 'Premium'
            else 'Standard' end as customer_tier
from customers c
left join orders o on c.id = o.customer_id
where o.order_date >= '2023-01-01'
```

**Review-punkter:**
- [ ] Kode-kvalitet og lesbarhet
- [ ] dbt best practices
- [ ] Potensielle forbedringer
- [ ] Test-behov
- [ ] Dokumentasjon

### 🎯 Architecture Design Session

**Scenario:** Design dbt-arkitektur for e-handel platform.

**Kilder:** customers, products, orders, payments, reviews, inventory

**Oppgave i gruppe:** Tegn arkitektur med:
- Source layer
- Staging layer  
- Intermediate layer
- Marts layer

**Presenter og diskuter forskjellige tilnærminger**

---

## ✅ Avsluttende refleksjon

### 🎯 Læringsjournal

**Hva var mest overraskende å lære?**
_____________________

**Hvilket konsept var vanskeligst å forstå?**  
_____________________

**Hva vil du bruke mest i praktisk arbeid?**
_____________________

**Hvilke spørsmål har du fortsatt?**
_____________________

### 📋 Action Items

**Basert på denne selvstudien, hva er dine neste steg?**

**Denne uken:**
- [ ] _____________________
- [ ] _____________________

**Neste måned:**  
- [ ] _____________________
- [ ] _____________________

**Kvartal:**
- [ ] _____________________
- [ ] _____________________

---

*💡 Tips: Kom tilbake til disse spørsmålene etter 3 måneder og se hvordan svarene dine har endret seg!*