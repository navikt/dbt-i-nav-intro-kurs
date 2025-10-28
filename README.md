# 🚀 dbt Intro-kurs - Selvstudie

Velkommen til det interaktive dbt selvstudiet! Dette kurset er designet for oppdagelsesbasert læring hvor du lærer ved å utforske, eksperimentere og reflektere.

## Forutsetninger
- GitHub-konto koblet til NAV-IKT
- Grunnleggende SQL-kunnskap

## 🎯 Kursstruktur

### 📚 Hovedmateriell
- **[📖 Selvstudie-guide](kursmatrialet/SELVSTUDIE_GUIDE.md)** - Din hovedreise gjennom dbt-konseptene
- **[📀 Kilde-oversikt](kursmatrialet/KILDE_OVERSIKT.md)** - Visuell guide til kildedataene
- **[📊 Modell-oversikt](kursmatrialet/MODELL_OVERSIKT.md)** - Visuell guide til prosjektstrukturen
- **[⚡ DBT Quick Reference](kursmatrialet/QUICK_REFERENCE.md)** - Hurtigreferanse for dbt- kommandoer og syntaks
- **[🦆 Duckcli Quick Reference](kursmatrialet/DUCKCLI_REFERENCE.md)** - Hurtigreferanse for duck db/cli- kommandoer og syntaks
- **[📋 Progresjon & Sjekklister](kursmatrialet/PROGRESJON_SJEKKLISTE.md)** - Følg din fremgang og sett mål
- **[🧠 Quiz & Refleksjon](kursmatrialet/QUIZ_REFLEKSJON.md)** - Test forståelsen og reflekter over læringen
- **[🎮 Utfordringsoppgaver](kursmatrialet/UTFORDRINGSOPPGAVER.md)** - Ekstra øvelser for dypere læring
- **[🚨 Feilsøking](kursmatrialet/FEILSOKING.md)** - Løsninger på vanlige problemer

## 🏃‍♂️ Quick Start

### For deg som vil komme i gang raskt:

**Steg 1: Starte Codespaces og selvstudiet**

1. Klikk på "Code" (grønn knapp)
2. Velg "Codespaces" tab
3. Klikk :heavy_plus_sign: "Create codespace"

Mens Codespaces starter opp (ca 1-2 minutter) kan du ta en kaffe og lese litt om utviklingsmiljøet 👇

Codespace't som starter opp er et fult utviklingsmiljø med alt du trenger for å fullføre kurset. Alt foregår i browseren så du trenger ikke å installere noe lokalt. Det består av en database (av typen duckdb) med ferdig lastet [kildedata](kursmatrialet/KILDE_OVERSIKT.md) som skal brukes under kurset. Et tilhørende sql klient-verkøy ([duckcli](kursmatrialet/DUCKCLI_REFERENCE.md)) og et ferdig oppsatt dbt-prosjekt med kobling mot databasen.

**Steg 2: Verifiser oppsett**

Kjør følgende kommandoer i terminalen for å se at oppsettet fungerer. Hvis du ikke ser terminalen kan du åpne den med `ctrl/cmd + j`

```bash
cd intro_kurs
dbt debug
```

Forventet output på siste linje:
```bash
12:29:06  All checks passed!
```

Hvis noe gikk galt, se avsnittet [Få hjelp](README.md#-f%C3%A5-hjelp)

**Steg 3: Velg din læringssti**

**🎯 Strukturert selvstudie (anbefalt for nye):**
1. Start med [selvstudie](kursmatrialet/SELVSTUDIE_GUIDE.md)
2. Følg progressjonen din med [sjekklisten](kursmatrialet/PROGRESJON_SJEKKLISTE.md)
3. Test deg selv med [quiz](kursmatrialet/QUIZ_REFLEKSJON.md)

**⚡ Hands-on øvinger (for erfarne):**
 - Utfordre deg med [utfordringsoppgaver](kursmatrialet/UTFORDRINGSOPPGAVER.md)

## ⏱️ Estimert tidsbruk
- **Grunnleggende gjennomgang:** 2-3 timer
- **Med utfordringsoppgaver:** 4-6 timer  
- **Full fordypning:** 1-2 dager

## 🎯 Læringsmål

Etter å ha fullført dette selvstudiet vil du:
- ✅ Forstå dbt's kjernekomponenter (sources, staging, marts)
- ✅ Kunne bygge og teste dbt-modeller selvstendig  
- ✅ Mestre ref() og source() funksjoner
- ✅ Implementere datakvalitetstesting
- ✅ Strukturere et dbt-prosjekt etter best practices

## 🛠️ Teknisk oppsett

### Nyttige kommandoer

**Åpne / lukke terminalvindu**

```shell
ctrl/cmd + j
```

**Gå til dbt-prosjektmappen:**
```shell
cd intro_kurs
```

**Gå opp et nivå i mappestrukturen**
```shell
cd ..
```

**Bygge prosjektet:**
```shell
dbt build
```

**Se resultatet av en modell:**
```shell
dbt show -s <model name>
```

**Kjøre spesifikke modeller:**
```shell
dbt run --select <model_name>
dbt run --select +<model_name>  # Inkluderer avhengigheter
```

**Testing:**
```shell
dbt test
dbt test --select <model_name>
```

## 🤝 Få hjelp

Hvis du sitter fast er det bare å spørre i [#dbt-i-nav](https://nav-it.slack.com/archives/C0377V3DDUM) eller ta kontakt med Espen Holtebu, Eivind André Holen, Stig Mange Henriksen eller Patrick Pedersen.

- **Spørsmål om dbt:** Sjekk [dbt dokumentasjon](https://docs.getdbt.com/)
- **Kurs-spesifikke spørsmål:** Opprett issue i dette repositoriet
- **Diskusjon:** Bruk team-kanaler eller [#dbt-i-nav](https://nav-it.slack.com/archives/C0377V3DDUM)

## 🎉 Kom i gang!

Klar til å starte? Gå til **[SELVSTUDIE_GUIDE.md](kursmatrialet/SELVSTUDIE_GUIDE.md)** og begynn din dbt-reise! 

*Lykke til! 🚀*
