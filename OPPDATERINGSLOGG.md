# 📝 Oppdateringslogg - Selvstudiemateriale

## 🎯 Hva er nytt i denne versjonen?

### ✨ Hovedforbedringer

#### 1. **Komplett kodeeksempler** ✅
- Erstattet alle TODO-kommentarer med faktisk fungerende kode
- Inkluderte presise SQL-eksempler fra `Kursdoc.md`
- Lagt til steg-for-steg instruksjoner

#### 2. **Nye ressursfiler**

**[MODELL_OVERSIKT.md](MODELL_OVERSIKT.md)** 📊
- Visuelt dataflyt-diagram
- Detaljert forklaring av hver modell
- Design-prinsipper for staging vs marts
- Materialiserings-strategi

**[FEILSOKING.md](FEILSOKING.md)** 🚨
- Vanlige feil med konkrete løsninger
- Debugging-strategi
- YAML-feil og SQL-syntaksfeil
- Test-failures og hvordan fikse dem

**[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** ⚡
- Hurtigreferanse for alle dbt-kommandoer
- Jinja-funksjoner (ref, source, config)
- Selection syntax (+, -, @)
- Best practices for SQL og struktur

#### 3. **Forbedret hovedguide** 📖

**[SELVSTUDIE_GUIDE.md](SELVSTUDIE_GUIDE.md)**
- Lagt til læringsløype-oversikt med visuelt diagram
- Komplette kodeeksempler for hver modul
- Bedre debugging-instruksjoner
- Dokumentasjonsseksjon med `dbt docs`
- Verifiseringssteg med faktiske kommandoer

#### 4. **Bedre navigasjon** 🧭

**[README.md](README.md)**
- Strukturert Quick Start med valg av læringssti
- Tydelig materiell-oversikt
- Estimert tidsbruk per tilnærming

---

## 📚 Komplett materialoversikt

### For nybegynnere (anbefalt rekkefølge):

1. **[README.md](README.md)** - Start her for oversikt
2. **[SELVSTUDIE_GUIDE.md](SELVSTUDIE_GUIDE.md)** - Følg steg-for-steg
3. **[MODELL_OVERSIKT.md](MODELL_OVERSIKT.md)** - Forstå strukturen visuelt
4. **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Ha denne ved siden av deg
5. **[FEILSOKING.md](FEILSOKING.md)** - Når du møter problemer
6. **[PROGRESJON_SJEKKLISTE.md](PROGRESJON_SJEKKLISTE.md)** - Spor fremgang
7. **[QUIZ_REFLEKSJON.md](QUIZ_REFLEKSJON.md)** - Sjekk forståelse

### For erfarne utviklere:

1. **[Kursdoc.md](Kursdoc.md)** - Direkte til oppgavene
2. **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Kommandoreferanse
3. **[UTFORDRINGSOPPGAVER.md](UTFORDRINGSOPPGAVER.md)** - Avanserte øvelser
4. **[FEILSOKING.md](FEILSOKING.md)** - Ved behov

---

## 🎥 Anbefalinger for instruksjonsvideoer

### Video-serie struktur:

#### 🎬 Video 1: "Velkommen til dbt" (5 min)
- Oversikt over kurset
- Forventninger og læringsmål
- Hvor finne ressursene
- Hvordan bruke selvstudiet

#### 🎬 Video 2: "Din første dbt-modell" (10 min)
**Innhold:**
- Vis `dim_customer.sql` eksemplet
- Kjør `dbt run --select dim_customer`
- Vis resultat med `dbt show`
- Pause for refleksjon: "Hva tror du skjer nå?"

**Interaktive momenter:**
- ⏸️ Pause: "Før jeg kjører kommandoen, hva tror du vil skje?"
- ⏸️ Pause: "Prøv selv før du ser videre"
- ⏸️ Pause: "Sammenlign ditt resultat med mitt"

#### 🎬 Video 3: "Staging - Ryddig kildekode" (12 min)
**Innhold:**
- Problemet: hardkoding av tabellnavn
- Løsningen: staging-modeller
- Live-koding av `stg_customers.sql` og `stg_orders.sql`
- Demonstrer `dbt run --select staging`

**Oppdagelsesmoment:**
- Vis feil først (hardkodet)
- Refaktorer til staging
- Diskuter fordeler

#### 🎬 Video 4: "Sources - Abstraksjonslagret" (10 min)
**Innhold:**
- Lag `src_jaffle_shop.yml`
- Oppdater staging-modeller til å bruke `{{ source() }}`
- Kjør `dbt source freshness`
- Demonstrer testing

**Live debugging:**
- Vis en feil (f.eks. feil source-navn)
- Debug sammen med seeren
- Fiks og kjør på nytt

#### 🎬 Video 5: "Ref og avhengigheter" (10 min)
**Innhold:**
- Lag `fak_customer_orders.sql`
- Bruk `{{ ref() }}` til staging-modeller
- Demonstrer `dbt run --select +fak_customer_orders`
- Vis lineage i `dbt docs`

**Visualisering:**
- Tegn avhengighetsgrafen
- Vis i dbt docs
- Forklar rekkefølge

#### 🎬 Video 6: "Testing - Kvalitetssikring" (12 min)
**Innhold:**
- Lag `mdl_jaffle_shop.yml`
- Kjør `dbt test`
- Vis feilende test (bevisst)
- Debug og fiks

**Interaktivt:**
- Introduser feil i data
- La seerne pause og tenke over løsning
- Vis flere tilnærminger til løsning

#### 🎬 Video 7: "Dokumentasjon og lineage" (8 min)
**Innhold:**
- `dbt docs generate`
- `dbt docs serve`
- Utforsk interaktiv dokumentasjon
- Lineage-grafen

#### 🎬 Video 8: "Debugging når noe går galt" (10 min)
**Innhold:**
- Vanlige feil (fra FEILSOKING.md)
- `dbt compile` workflow
- `dbt debug` kommando
- Les feilmeldinger

---

## 🎓 Pedagogisk tilnærming

### Oppdagelsesbasert læring:

**Før-koding:**
- Still spørsmål
- La seerne tenke
- Be om pause i videoen

**Under-koding:**
- Tenk høyt
- Forklar hvorfor, ikke bare hvordan
- Vis feil og debugging

**Etter-koding:**
- Refleksjonsspørsmål
- Utfordring til seeren
- Link til videre ressurser

### Interaktive elementer:

**⏸️ Pause-punkter i video:**
```
"Pause videoen nå og prøv selv før du ser løsningen"
"Hva tror du vil skje når jeg kjører dette?"
"Sammenlign ditt resultat med mitt"
```

**✅ Checkpoints:**
```
"Hvis du har kommet hit, gratulerer! Du har nå..."
"Før du går videre, sørg for at du kan..."
```

**🎯 Utfordringer:**
```
"Ekstra utfordring: Kan du legge til..."
"For avanserte: Prøv å..."
```

---

## 💡 Tips for video-innspilling

### Teknisk:

1. **Screen recording:**
   - Vis terminal og editor side-by-side
   - Bruk stor font (minst 16pt)
   - Zoom inn på viktige deler

2. **Kommandoer:**
   - Type sakte og tydelig
   - Forklar hver parameter
   - Vis output og forklar det

3. **Kode:**
   - Skriv kode live (ikke copy-paste)
   - Forklar hver linje
   - Bruk syntax highlighting

### Pedagogisk:

1. **Pacing:**
   - Pause mellom konsepter
   - Gjenta viktige punkter
   - La output vises lenge nok

2. **Engagement:**
   - Still retoriske spørsmål
   - Bruk entusiasme i stemmen
   - Feir små seiere ("Se - det fungerte!")

3. **Feil:**
   - Ikke redigér bort feil
   - Vis debugging-prosessen
   - Normaliser at feil skjer

---

## 📊 Forventet læringsutbytte

### Etter grunnkurset (Video 1-6):

**Studenten kan:**
- ✅ Lage og kjøre grunnleggende dbt-modeller
- ✅ Strukturere et dbt-prosjekt med staging og marts
- ✅ Bruke source() og ref() funksjoner korrekt
- ✅ Implementere basic testing
- ✅ Dokumentere modeller i YAML
- ✅ Navigere i dbt-dokumentasjon

**Studenten forstår:**
- ✅ Hvorfor staging-lag er viktig
- ✅ Hvordan dbt bygger avhengighetsgrafer
- ✅ Verdien av automatisk testing
- ✅ Data lineage konseptet

### Etter utfordringer:

**Studenten kan:**
- ✅ Optimalisere modeller (materialisering)
- ✅ Lage custom tests
- ✅ Håndtere komplekse transformasjoner
- ✅ Debugge systematisk
- ✅ Strukturere enterprise-prosjekter

---

## 🚀 Neste steg

### For videre utvikling av kurset:

1. **CI/CD modul** - GitHub Actions for dbt
2. **Incremental models** - For store datasett
3. **Snapshots** - SCD Type 2 tracking
4. **Macros** - Gjenbrukbar SQL-logikk
5. **Packages** - dbt_utils og andre
6. **Testing strategies** - Custom generic tests
7. **Production deployment** - Multi-environment setup

### Feedback-loop:

- Samle tilbakemeldinger fra første runde studenter
- Oppdater materiale basert på vanlige spørsmål
- Legg til flere eksempler der det trengs
- Utvid FEILSOKING.md med nye scenarioer

---

## 📧 Kontakt

For spørsmål eller forslag til forbedringer:
- Opprett issue i dette repositoriet
- Diskuter i team-kanaler
- Bidra med pull requests

---

**Dato for siste oppdatering:** 20. oktober 2025
**Versjon:** 2.0 - Forbedret for selvstudie
**Opprettet av:** GitHub Copilot AI Assistant
