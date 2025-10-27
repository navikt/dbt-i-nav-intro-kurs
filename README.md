# 🚀 dbt Intro-kurs - Selvstudie

Velkommen til det interaktive dbt selvstudiet! Dette kurset er designet for oppdagelsesbasert læring hvor du lærer ved å utforske, eksperimentere og reflektere.

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

1. Gå til repositoriet på GitHub
2. Bytt til **selv_studie** branch først (dropdown øverst til venstre)
3. Klikk på "Code" (grønn knapp)
4. Velg "Codespaces" tab
5. Klikk "Create codespace"

Ta en kaffe mens Codespaces starter opp ca (1-2 minutter)
Når Codespace er klar, kjør i terminalen:

```bash
cd intro_kurs
```

**Steg 2: Velg din læringssti**

**🎯 Strukturert selvstudie (anbefalt for nye):**
1. Start med [SELVSTUDIE_GUIDE.md](kursmatrialet/SELVSTUDIE_GUIDE.md)
2. Følg [PROGRESJON_SJEKKLISTE.md](kursmatrialet/PROGRESJON_SJEKKLISTE.md)
3. Test deg selv med [QUIZ_REFLEKSJON.md](kursmatrialet/QUIZ_REFLEKSJON.md)

**⚡ Hands-on øvinger (for erfarne):**
 - Utfordre deg med [UTFORDRINGSOPPGAVER.md](kursmatrialet/UTFORDRINGSOPPGAVER.md)

**Steg 3: Verifiser oppsett**
```bash
cd intro_kurs
dbt --version
dbt debug
```

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

### Forutsetninger
- GitHub-konto koblet til NAV-IKT
- Grunnleggende SQL-kunnskap
- Terminal/kommandolinje tilgang

### Nyttige kommandoer

**Gå til dbt-prosjektmappen:**
```shell
cd intro_kurs
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

- **Spørsmål om dbt:** Sjekk [dbt dokumentasjon](https://docs.getdbt.com/)
- **Kurs-spesifikke spørsmål:** Opprett issue i dette repositoriet
- **Diskusjon:** Bruk team-kanaler eller Slack

## 🎉 Kom i gang!

Klar til å starte? Gå til **[SELVSTUDIE_GUIDE.md](kursmatrialet/SELVSTUDIE_GUIDE.md)** og begynn din dbt-reise! 

*Lykke til! 🚀*
