#Multilevel Partition

###What is it?
- PostgreSQL multilevel partitions can be created up to N levels. 
  Partition methods LIST-LIST, LIST-RANGE, LIST-HASH, RANGE-RANGE, RANGE-LIST, RANGE-HASH, HASH-HASH, HASH-LIST, and HASH-RANGE 
  can be created in PostgreSQL declarative partitioning.
###Run docker

```shell
docker-compose up -d
docker exec -it multi-partition /bin/sh
psql multi-partition postgres
\dt
select * from customers;
SELECT tableoid::regclass,* FROM customers;
```