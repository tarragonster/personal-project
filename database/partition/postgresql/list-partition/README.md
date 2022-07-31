#List Partition

###What is it?
- A list partition is created with predefined values to hold in a partitioned table.
  A default partition (optional) holds all those values that are not part of any specified partition.

###Run docker

```shell
docker-compose up -d
docker exec -it list-partition /bin/sh
psql list-partition postgres
\dt
select * from customers;
SELECT tableoid::regclass,* FROM customers;
```