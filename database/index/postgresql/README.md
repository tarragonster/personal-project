# Postgresql index

###1. Command-line

1. `psql DBNAME USERNAME` enter into psql
2. `\?` list all the commands
3. `\l` list databases
4. `\conninfo` display information about current connection
5. `\c [DBNAME]` connect to new database, e.g., \c template1
6. `\dt` list tables of the public schema
7. `\dt <schema-name>.*` list tables of certain schema, e.g., \dt public.*
8. `\dt *.*` list tables of all schemas
9. Then you can run SQL statements, e.g., `SELECT * FROM my_table;` (Note: a statement must be terminated with semicolon ;)
10. `\q` quit psql
11. `\d TABLENAME` show info including column
12. `\d+ TABLENAME` (show relation information) equivalent via sql

###2. Start project

```shell
docker-compose up -d
docker exec -it postgres-index /bin/sh
psql index-gres postgres
-> \d towns
```

article does not use index -> Execution Time: 67.611 ms (very slow)
```
explain analyze select * from towns where article = '[VALUE]'
```

name does use index -> Execution Time: 6.216 ms (better)
```
explain analyze select * from towns where name = '[VALUE]'
```

name does use index but does not apply for expression (LIKE) -> Execution Time: 106.820 ms (very slow)
```
explain analyze select * from towns where name = '%[VALUE]%'
```

- UNIQUE act the same as INDEX
- INDEX do not support UPPER expression

###3. Index algorithm

- `btree` `hash` `gist` `spgist` `gin` & `brin`

Postgres use btree as default index algorithm
btree -> binary search tree

###References

[QA] Clodoaldo Neto - [How can I generate big data sample for Postgresql using generate_series and random?](https://stackoverflow.com/questions/24841142/how-can-i-generate-big-data-sample-for-postgresql-using-generate-series-and-rand) \
[QA] zwcloud - [PostgreSQL: Show tables in PostgreSQL](https://stackoverflow.com/questions/769683/postgresql-show-tables-in-postgresql) \
[Blog] [PostgreSQL CREATE INDEX](https://www.postgresqltutorial.com/postgresql-indexes/postgresql-create-index/) \
[Vid] Hussein Nasser - [Database Indexing Explained (with PostgreSQL)](https://www.youtube.com/watch?v=-qNSXK7s7_w&list=PLQnljOFTspQXjD0HOzN7P2tgzu7scWpl2&index=7&ab_channel=HusseinNasser) \