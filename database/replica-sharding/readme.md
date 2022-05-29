# Differences and limitation replicas vs shard

Replica-set:
A Replica-Set means that you have multiple instances which each mirror all the data of each other. A replica-set consists of one Master (also called "Primary") and one or more Slaves (aka Secondary). Read-operations can be served by any slave, so you can increase read-performance by adding more slaves to the replica-set (provided that your client application is capable to actually use different set-members). But write-operations always take place on the master of the replica-set and are then propagated to the slaves, so writes won't get faster when you add more slaves.

Sharded Cluster:
A Sharded Cluster means that each shard of the cluster (which can also be a replica-set) takes care of a part of the data. Each request, both reads and writes, is served by the cluster where the data resides. This means that both read- and write performance can be increased by adding more shards to a cluster

## References

[Community] Philipp - [Difference between Sharding And Replication on MongoDB](https://dba.stackexchange.com/questions/52632/difference-between-sharding-and-replication-on-mongodb) \
[Vid] Be a better dev - [What is Database Sharding?](https://www.youtube.com/watch?v=hdxdhCpgYo8&ab_channel=BeABetterDev)