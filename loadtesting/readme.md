# Load Testing Tool

Check out [the document](https://k6.io/docs/) \
Test TCP: [WebSockets testing](https://k6.io/docs/using-k6/protocols/websockets/) \
[Blog] [Hping Tips and Tricks](https://iphelix.medium.com/hping-tips-and-tricks-85698751179f) \
[Code] nerdalert - [net-tools](https://github.com/gopher-net/dockerized-net-tools/tree/master/fping)

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