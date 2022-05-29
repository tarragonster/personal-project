# Sharding database demo

## References
[CODE] Hussein Nasser - [sharding](https://github.com/hnasr/javascript_playground/blob/master/sharding/index.js) \
[CODE] Arnout Kazemier - [node-hashring](https://github.com/3rd-Eden/node-hashring) \
[Vid] Be A Better Dev - [What is Database Sharding?](https://www.youtube.com/watch?v=hdxdhCpgYo8&ab_channel=BeABetterDev) \

## Stack
- Docker postgres
- Hash-ring algorithm (load balancing)
- Client and Cluster postgres (error on database connection)

## Start Demo

```
cd database
docker-compose up -d postgres-shard-one postgres-shard-two postgres-shard-three adminer node-sharding
cd database/postgres/sharding/http-client -> run request
```

NOTICE 1: the connection to postgres will be terminated after a
few minutes (the demo running with Client pg and no client.end()) -> preferably using
Cluster (no need to open/close connection)

If this is the case just restart docker-compose or make changes to
the files

NOTICE 2: Node 14 is not compatible with pg lib under 8.0.3.
[Further Info](https://github.com/brianc/node-postgres/issues/2180)

