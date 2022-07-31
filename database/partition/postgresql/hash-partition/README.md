#Hash Partition

###What is it?
- A hash partition is created by using modulus and remainder for each partition, 
  where rows are inserted by generating a hash value using these modulus and remainders.

###Run docker

```shell
docker-compose up -d
docker exec -it hash-partition /bin/sh
psql hash-partition postgres
\dt
select * from customers;
SELECT tableoid::regclass,* FROM customers;
```