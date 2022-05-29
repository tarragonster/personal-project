# Cluster Fastify-Pm2 Server Demo

You will use cluster nodejs(fastify) for demo of difference in performance
with single thread nodejs including pm2

click [here](https://blog.devgenius.io/how-to-scale-a-nodejs-application-a51d3e8e2d36)
for further reference

## Start Fastify-Pm2 docker

```
cd webserver
docker-compose up -d fastify-cluster-pm2
```

## Run Demo

```
http://localhost:89
```

## Pm2 Command

```
pm2 list
pm2 monit
```

click [here](https://pm2.keymetrics.io/docs/usage/quick-start/) for pm2
command list reference