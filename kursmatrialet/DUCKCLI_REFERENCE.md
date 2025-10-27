# 🦆㏈

Her er en oversikt over de viktigste duckdb / duckcli kommanodene.

## Koble på databasen

duckdb støtter kun en databasetilkobling av gangen så husk å koble fra etter du er ferdig med å utforske databasen

```bash
duckcli <database-fil>
```

**Eksempel:**

```bash
duckcli dev.duckdb
```

**Forventet output:**

```bash
duckcli dev.duckdb 
Version: 0.2.1
GitHub: https://github.com/dbcli/duckcli
dev.duckdb>
```

## Koble fra databasen

```sql
exit
```

**Forventet output:**

```bash
dev.duckdb> exit
Goodbye!
@patped ➜ /workspaces/dbt-i-nav-intro-kurs (selv_studie) $ 
```

## Se databasestruktur

```sql
show
```

**Forventet output:**

```bash
dev.duckdb> show
+----------+-------------+-----------+-------------------------------------------------------------------+--------------------------------------------------------------+-----------+
| database | schema      | name      | column_names                                                      | column_types                                                 | temporary |
+----------+-------------+-----------+-------------------------------------------------------------------+--------------------------------------------------------------+-----------+
| dev      | jaffle_shop | customers | ['id', 'first_name', 'last_name']                                 | ['BIGINT', 'VARCHAR', 'VARCHAR']                             | False     |
| dev      | jaffle_shop | orders    | ['ID', 'USER_ID', 'ORDER_DATE', 'STATUS', '_etl_loaded_at']       | ['BIGINT', 'BIGINT', 'DATE', 'VARCHAR', 'TIMESTAMP']         | False     |
| dev      | stripe      | payments  | ['ID', 'ORDERID', 'PAYMENTMETHOD', 'STATUS', 'AMOUNT', 'CREATED'] | ['BIGINT', 'BIGINT', 'VARCHAR', 'VARCHAR', 'BIGINT', 'DATE'] | False     |
+----------+-------------+-----------+-------------------------------------------------------------------+--------------------------------------------------------------+-----------+
3 rows in set
Time: 0.032s
```

## Se kolonner i en tabell

```bash
show <schema>.<tabell>
```

**Eksempel:**

```sql
show jaffle_shop.customers
```

**Forventet output:**

```bash
dev.duckdb> show jaffle_shop.customers
+-------------+-------------+------+--------+---------+--------+
| column_name | column_type | null | key    | default | extra  |
+-------------+-------------+------+--------+---------+--------+
| id          | BIGINT      | YES  | <null> | <null>  | <null> |
| first_name  | VARCHAR     | YES  | <null> | <null>  | <null> |
| last_name   | VARCHAR     | YES  | <null> | <null>  | <null> |
+-------------+-------------+------+--------+---------+--------+
3 rows in set
Time: 0.004s
```

## Kjøre sql spørring

```bash
<spørring>
```

**Eksempel:**

```sql
select * from jaffle_shop.orders limit 2
```

**Forventet output:**

```bash
dev.duckdb> select * from jaffle_shop.orders limit 2
+----+---------+------------+--------+----------------------------+
| ID | USER_ID | ORDER_DATE | STATUS | _etl_loaded_at             |
+----+---------+------------+--------+----------------------------+
| 84 | 70      | 2018-03-26 | placed | 2021-11-19 05:21:58.564126 |
| 86 | 68      | 2018-03-26 | placed | 2021-11-19 05:21:58.564126 |
+----+---------+------------+--------+----------------------------+
2 rows in set
Time: 0.004s
```
