# Cluster Fastify Server Demo

You will use cluster nodejs(fastify) for demo of high availability
which mock a fail server and switching thread to prevent crashes

click [here](https://blog.devgenius.io/how-to-scale-a-nodejs-application-a51d3e8e2d36)
for further reference

## Start Fastify docker

```
cd webserver
docker-compose up -d fastify-cluster
```

## Run Demo

```
http://localhost:87
```

## Caveats

Using cluster module is an excellent way to scale your NodeJS application but you need to be aware of some cases.

No In-Memory Caching: Now that we have multiple processes
running in parallel, we won't be able to cache some objects
in memory and access them. Since there is no shared memory
among processes. Well, this is good I believe since dedicated
caching technologies trump in memory caching. Now we would be
forced to use some caching mechanism like Redis or Memcache and
be able to access that from any process.

No Stateful Communication: Network calls that are stateful
won’t work anymore since communication is not guaranteed to
be with the same worker. So sessions would not work. It is
better to opt for a stateless token based authentication
mechanism like JWT. I believe this is good as well and this truly
makes our server stateless.


