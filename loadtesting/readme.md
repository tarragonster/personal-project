# Load Testing Tool

Check out [the document](https://k6.io/docs/)

## Start your preferred load testing tool

```
cd loadtesting
docker-compose up -d k6
```

## Start Prometheus, Grafana & Dashboards

Check out [here](../monitoring/prometheus/readme.md)

## Run Tests

```
docker exec -it [k6 containerID] /bin/sh
k6 run loadtesting/simpletest.js
```