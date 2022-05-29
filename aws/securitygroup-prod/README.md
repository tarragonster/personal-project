# how to secure your service

## Security group

- service open sg only for healthcheck port (if mapping docker to port 4000 -> sg-inbound open port for 3000)
- open port only for loadbalancer sg
- loadbalancer open port for http and https 0.0.0.0
- websocket require allTraffic loadbalancer (open allTraffic -> 0.0.0.0), service (open allTraffic -> loadBalancer)