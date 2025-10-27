# 🎮 dbt Utfordringsoppgaver - Ekstra læring

## 🏃‍♂️ Quick Wins (5-10 min hver)

### Utfordring 1: Data Detective
**Scenario:** Du får beskjed om at antall kunder ikke stemmer overens mellom rapporter.

**Din oppgave:**
```sql
-- Undersøk og rapporter:
-- 1. Hvor mange unike kunder er det i customers-tabellen?
-- 2. Hvor mange unike customer_id er det i orders-tabellen?  
-- 3. Er det kunder som aldri har bestilt?
-- 4. Er det bestillinger uten gyldig kunde?

-- Skriv SQL som besvarer disse spørsmålene
```

**Bonuspoeng:** Lag en modell som viser "data quality report"

---

### Utfordring 2: Performance Detective  
**Scenario:** Modellene tar lang tid å kjøre.

**Oppgaver:**
1. Kjør `dbt run --select dim_customer` og noter kjøretiden
2. Legg til `{{ config(materialized='table') }}` øverst i modellen
3. Kjør på nytt - hva er forskjellen?
4. Test også `materialized='view'` og `materialized='incremental'`

**Refleksjon:** Når ville du brukt hver type materialisering?

---

### Utfordring 3: Makro Magi
**Scenario:** Du skriver samme SQL-logikk mange steder.

**Din oppgave:**
Lag en makro `macros/get_date_parts.sql`:
```sql
-- TODO: Lag en makro som tar inn en dato-kolonne
-- og returnerer år, måned, dag som separate kolonner
{% macro get_date_parts(date_column) %}
  -- Din kode her
{% endmacro %}
```

Bruk den i en modell for å analysere bestillinger per måned.

---

## 🧗‍♀️ Intermediate Challenges (15-30 min)

### Utfordring 4: Customer Segmentation
**Scenario:** Marketing vil segmentere kunder.

**Krav:**
- VIP: 10+ bestillinger
- Regular: 3-9 bestillinger  
- New: 1-2 bestillinger
- Inactive: 0 bestillinger

**Bonus:** Legg til tidsaspekt - hvor lenge siden siste bestilling?

---

### Utfordring 5: Advanced Testing
**Din oppgave:**
1. Lag en custom test som sjekker at ingen bestillinger er fra fremtiden
2. Lag en test som sikrer at total antall bestillinger matcher mellom staging og marts
3. Implementer en test for at kundenavn følger riktig format

**Hint:** Se på `tests/` mappen og dbt test-dokumentasjon

---

### Utfordring 6: Snapshot Exploration
**Scenario:** Du må spore endringer i kundedata over tid.

**Din oppgave:**
1. Sett opp en snapshot av customers-tabellen
2. Endre noen kundedata manuelt
3. Kjør snapshot på nytt
4. Analyser hvordan dbt sporer endringene

---

## 🚀 Advanced Missions (30+ min)

### Utfordring 7: Full Pipeline
**Scenario:** Bygg et komplett data warehouse for en e-handel.

**Din oppgave:**
Implementer hele prosessen fra sources til marts:
- Sources (customers, orders, payments)
- Staging (renaming, cleaning, basic transformations)
- Intermediate (business logic, calculations)
- Marts (final business-ready models)

**Krav:**
- Minimum 5 modeller
- Full test-suite
- Komplett dokumentasjon
- Performante materialiseringer

---

### Utfordring 8: Data Freshness Monitor
**Scenario:** Data må være ferskt for at business kan stole på det.

**Din oppgave:**
1. Sett opp freshness-monitoring for alle kilder
2. Lag en modell som rapporterer data-ferskhet per tabell
3. Implementer alerting-logikk (simulert)

---

### Utfordring 9: Multi-Environment Setup
**Scenario:** Du trenger separate miljøer for dev, test og prod.

**Din oppgave:**
1. Sett opp `profiles.yml` for multiple targets
2. Lag environment-spesifikke konfigurasjoner
3. Test deployment mellom miljøer
4. Dokumenter best practices

---

## 🎯 Debugging Scenarios

### Scenario A: "Modellen kjører ikke"
```
Compilation Error in model 'dim_customer'
  column "customer_id" must appear in the GROUP BY clause
```
**Din oppgave:** Debug og fiks feilen

### Scenario B: "Test feiler"
```
1 of 2 ERROR UNIQUE test on columns (id) of model stg_customers
```
**Din oppgave:** Undersøk hvorfor og løs problemet

### Scenario C: "Ingen data i output"
**Din oppgave:** Modellen kjører uten feil, men resultatet er tomt. Hvorfor?

---

## 📊 Selvvurdering

Etter hver utfordring, ranger deg selv:

**Tekniske ferdigheter:**
- [ ] Begynner (følger oppskrift)
- [ ] Selvstendig (løser nye problemer)
- [ ] Avansert (optimaliserer og innoverer)

**dbt-konsepter:**
- [ ] Forstår sources, staging, marts
- [ ] Behersker ref() og source() funksjoner
- [ ] Kan sette opp testing og dokumentasjon
- [ ] Forstår materialiseringer og performance

**Feilsøking:**
- [ ] Kan lese feilmeldinger
- [ ] Systematisk tilnærming til debugging
- [ ] Forstår dbt compile og run prosessen

---

## 🤝 Samarbeidsoppgaver

### Peer Review Challenge
**Hvis dere er flere:**
1. Bytt dbt-prosjekter med en kollega
2. Review koden deres og gi feedback på:
   - Kode-kvalitet og lesbarhet
   - Test-dekning
   - Dokumentasjon
   - Modell-struktur

### Knowledge Sharing
**Velg ett tema og lag en 5-minutters presentasjon:**
- Når bruke table vs view materialisering?
- Best practices for modell-naming
- Hvordan strukturere test-strategien?
- Performance-optimalisering i dbt
