# Intro til dbt


## Installasjon

### Forutsetninger

* python 3
* git

### dbt

```shell
pip install -r requirements.txt
```

### Initier et nytt prosjekt

```shell
dbt init
```

Gi prosjektet et navn. F.eks: `intro_kurs`

```shell
(.venv) dbt-i-nav-intro % dbt init
10:15:48  Running with dbt=1.9.1
Enter a name for your project (letters, digits, underscore): intro_kurs
```

Velg `1` (duckdb) som database.

```shell
...
10:18:32  Setting up your profile.
Which database would you like to use?
[1] duckdb

(Don't see the one you want? https://docs.getdbt.com/docs/available-adapters)

Enter a number: 1
```

### Bygg prosjektet

Gå inn i prosjektmappen

#### Unix/macOS

```shell
cd intro_kurs
```

#### Windows

*comming soon*

Bygg prosjektet:

```shell
dbt build
```

### Feilende tester

Når vi bygget prosjektet fikk vi en test som feilet.

```shell
10:23:46  Running with dbt=1.9.1
10:23:46  Registered adapter: duckdb=1.9.1
10:23:46  Unable to do partial parsing because saved manifest not found. Starting full parse.
10:23:46  Found 2 models, 4 data tests, 424 macros
10:23:46
10:23:46  Concurrency: 1 threads (target='dev')
10:23:46
10:23:46  1 of 6 START sql table model main.my_first_dbt_model ........................... [RUN]
10:23:46  1 of 6 OK created sql table model main.my_first_dbt_model ...................... [OK in 0.03s]
10:23:46  2 of 6 START test not_null_my_first_dbt_model_id ............................... [RUN]
10:23:46  2 of 6 FAIL 1 not_null_my_first_dbt_model_id ................................... [FAIL 1 in 0.02s]
10:23:46  3 of 6 START test unique_my_first_dbt_model_id ................................. [RUN]
10:23:46  3 of 6 PASS unique_my_first_dbt_model_id ....................................... [PASS in 0.01s]
10:23:46  4 of 6 SKIP relation main.my_second_dbt_model .................................. [SKIP]
10:23:46  5 of 6 SKIP test not_null_my_second_dbt_model_id ............................... [SKIP]
10:23:46  6 of 6 SKIP test unique_my_second_dbt_model_id ................................. [SKIP]
10:23:46
10:23:46  Finished running 1 table model, 4 data tests, 1 view model in 0 hours 0 minutes and 0.13 seconds (0.13s).
10:23:46
10:23:46  Completed with 1 error, 0 partial successes, and 0 warnings:
10:23:46
10:23:46  Failure in test not_null_my_first_dbt_model_id (models/example/schema.yml)
10:23:46    Got 1 result, configured to fail if != 0
10:23:46
10:23:46    compiled code at target/compiled/intro_kurs/models/example/schema.yml/not_null_my_first_dbt_model_id.sql
10:23:46
10:23:46  Done. PASS=2 WARN=0 ERROR=1 SKIP=3 TOTAL=6
```

