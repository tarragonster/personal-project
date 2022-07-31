# Partitioning

##Type of partition
###List partition
###Range partition
###Hash partition
###Multilevel partition
###Limitation
1. Unique constraints on partitioned tables must include all the partition key columns. One work-around is to create unique constraints on each partition instead of a partitioned table.

2. Partition does not support BEFORE ROW triggers on partitioned tables. If necessary, they must be defined on individual partitions, not the partitioned table.

3. Range partition does not allow NULL values.

4. PostgreSQL does not create a system-defined subpartition when not given it explicitly, so if a subpartition is present at least one partition should be present to hold values.

5. In the case of HASH-LIST, HASH-RANGE, and HASH-HASH composite partitions, users need to make sure all partitions are present at the subpartition level as HASH can direct values at any partition based on hash value.

##References
[Blog] 3/26/2020 - Rajkumar Raghuwanshi - [How to use table partitioning to scale PostgreSQL](https://www.enterprisedb.com/postgres-tutorials/how-use-table-partitioning-scale-postgresql) \
[Blog] [Beginner’s Guide to Table Partitioning In PostgreSQL](https://medium.com/swlh/beginners-guide-to-table-partitioning-in-postgresql-5a014229042) \