# ✅ dbt Læringsprogresjon - Sjekkliste

## 📋 Før du starter

### Tekniske forutsetninger
- [ ] GitHub-konto koblet til NAV-IKT ✅
- [ ] Laptop med internett-tilgang ✅  
- [ ] Grunnleggende SQL-kunnskap ✅
- [ ] Deltatt på "Hva er dbt"-kurs (anbefalt) ✅

### Miljøoppsett
- [ ] Repository klonet lokalt
- [ ] Terminal/kommandolinje tilgjengelig
- [ ] dbt installert og fungerer (`dbt --version`)
- [ ] Kan navigere til `intro_kurs/` mappen

---

## 🎯 Modul 1: dbt Grunnlegger
*Estimert tid: 30 minutter*

### Forståelse
- [ ] Kan forklare hva dbt er med egne ord
- [ ] Forstår forskjellen på SELECT og CREATE TABLE
- [ ] Vet hva `dbt_project.yml` inneholder
- [ ] Kan navigere i dbt-prosjektstrukturen

### Praktiske ferdigheter  
- [ ] Kan kjøre `dbt --help` og forstå output
- [ ] Kan bruke `dbt run --select <model>`
- [ ] Kan bruke `dbt show -s <model>`
- [ ] Har laget sin første modell (`dim_customer.sql`)

### Kontrollspørsmål ✋
Før du går videre, svar på:
1. "Hva er forskjellen på en SQL-fil og en dbt-modell?"
2. "Hvorfor lages det views/tabeller når du kjører `dbt run`?"

---

## 🏗️ Modul 2: Staging og Kilder  
*Estimert tid: 45 minutter*

### Forståelse
- [ ] Forstår staging-konseptet og hvorfor det er viktig
- [ ] Vet forskjellen på rå data og klargjort data  
- [ ] Forstår source-funksjonen og dens fordeler
- [ ] Kan forklare datalineage (hvem bruker hva)

### Praktiske ferdigheter
- [ ] Har laget staging-modeller (`stg_customers.sql`, `stg_orders.sql`)
- [ ] Har definert sources i YAML (`src_jaffle_shop.yml`)
- [ ] Kan bruke `{{ source() }}` funksjonen
- [ ] Kan kjøre `dbt run --select staging`

### Kvalitetssikring
- [ ] Har lagt til basic tester (unique, not_null)
- [ ] Kan kjøre `dbt test` og forstå resultatet
- [ ] Har implementert freshness-sjekk
- [ ] Kan kjøre `dbt source freshness`

### Kontrollspørsmål ✋
1. "Når ville du definert data som 'ikke fersk nok'?"
2. "Hva skjer hvis du sletter en staging-modell som andre bruker?"

---

## 🔗 Modul 3: Referanser og Avhengigheter
*Estimert tid: 30 minutter*

### Forståelse  
- [ ] Forstår `{{ ref() }}` funksjonen
- [ ] Vet hvordan dbt bygger avhengighetsgraf
- [ ] Forstår `+` og `-` i select-statement
- [ ] Kan forklare hvorfor hardkoding av tabellnavn er problematisk

### Praktiske ferdigheter
- [ ] Har refaktorert `dim_customer` til å bruke `ref()`
- [ ] Kan kjøre `dbt run --select +fak_customer_orders`
- [ ] Forstår rekkefølgen modeller kjører i
- [ ] Kan visualisere lineage (med `dbt docs`)

### Kontrollspørsmål ✋
1. "Hva skjer hvis du har sirkulære avhengigheter?"
2. "Hvordan ville du testet at en refaktorering ikke endret resultatet?"

---

## 🧪 Modul 4: Testing og Kvalitet
*Estimert tid: 25 minutter*

### Forståelse
- [ ] Vet forskjellen på data-tester og schema-tester
- [ ] Forstår når du bør bruke unique vs not_null
- [ ] Kan forklare verdien av automatisk testing
- [ ] Forstår konseptet "shift left" på datakvalitet

### Praktiske ferdigheter
- [ ] Har definert tester i YAML-filer
- [ ] Kan kjøre tester selektivt (`dbt test --select <model>`)
- [ ] Kan tolke test-feilmeldinger
- [ ] Har fikset feilende tester

### Avanserte konsepter
- [ ] Forstår singular tests (custom SQL tests)
- [ ] Kan implementere business rule testing
- [ ] Vet om test-coverage strategier

### Kontrollspørsmål ✋
1. "Hvor mange tester er 'nok'?"
2. "Hvordan ville du testet at en aggregering er korrekt?"

---

## 📚 Modul 5: Dokumentasjon og Vedlikehold  
*Estimert tid: 20 minutter*

### Forståelse
- [ ] Forstår viktigheten av selvdokumenterende kode
- [ ] Vet hvordan dbt genererer dokumentasjon
- [ ] Kan forklare forretningsverdi av god dokumentasjon
- [ ] Forstår metadata og lineage-konsepter

### Praktiske ferdigheter  
- [ ] Har dokumentert modeller og kolonner i YAML
- [ ] Kan generere docs (`dbt docs generate`)
- [ ] Kan serve dokumentasjon lokalt (`dbt docs serve`)
- [ ] Har utforsket lineage-grafen

### Kontrollspørsmål ✋
1. "Hvem er målgruppen for dbt-dokumentasjonen?"
2. "Hvordan holder du dokumentasjonen oppdatert over tid?"

---

## 🎓 Sertifiseringsnivåer

### 🥉 dbt Begynner
**Du har oppnådd dette nivået når du:**
- [ ] Kan lage enkle dbt-modeller
- [ ] Forstår sources og staging
- [ ] Kan kjøre grunnleggende dbt-kommandoer
- [ ] Har implementert basic testing

**Bevis:** Lag et mini-prosjekt med 3 modeller og full test-suite

### 🥈 dbt Praktiker  
**Du har oppnådd dette nivået når du:**
- [ ] Behersker ref() og source() funksjoner
- [ ] Kan strukturere et dbt-prosjekt
- [ ] Forstår materialiseringsstrategier
- [ ] Kan feilsøke og optimalisere modeller

**Bevis:** Refaktorer et eksisterende prosjekt til dbt best practices

### 🥇 dbt Ekspert
**Du har oppnådd dette nivået når du:**
- [ ] Kan sette opp CI/CD for dbt
- [ ] Behersker makroer og Jinja
- [ ] Forstår incremental models og snapshots
- [ ] Kan coache andre i dbt

**Bevis:** Implementer enterprise-løsning med multiple miljøer

---

## 📈 Kontinuerlig læring

### Ukentlige mål
- [ ] Uke 1: Fullfør grunnleggende moduler
- [ ] Uke 2: Implementer i eget prosjekt  
- [ ] Uke 3: Lær avanserte konsepter
- [ ] Uke 4: Del kunnskap med teamet

### Månedlige evalueringer
- [ ] Måned 1: Selvvurdering av tekniske ferdigheter
- [ ] Måned 2: Peer review av dbt-kode
- [ ] Måned 3: Presentasjon av best practices
- [ ] Måned 4: Mentoring av nye utviklere

### Ressurser for videre læring
- [ ] dbt.com dokumentasjon
- [ ] dbt Slack community
- [ ] "Analytics Engineering with dbt" kurs
- [ ] Lokale meetups og konferanser

---

## 🎯 Personlige mål

**Mine læringsmål for denne perioden:**
1. _Skriv ditt mål her_
2. _Skriv ditt mål her_  
3. _Skriv ditt mål her_

**Dato for målevaluering:** ___________

**Mentor/buddy:** ___________

**Tilbakemeldingsplan:** ___________