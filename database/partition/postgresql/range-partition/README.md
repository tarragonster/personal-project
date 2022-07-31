#Range Partition

###What is it?
- A range partition is created to hold values within a range provided on the partition key. 
  Both minimum and maximum values of the range need to be specified, 
  where minimum value is inclusive and maximum value is exclusive.  
  
###Run docker

```shell
docker-compose up -d
docker exec -it range-partition /bin/sh
psql range-partition postgres
\dt
select * from customers;
SELECT tableoid::regclass,* FROM customers;
```