wrk -t4 -c1000 -d30s -R200000 http://docker.for.mac.localhost:87/

#wrk command with 12 threads and 1,000 connections for 30 seconds with 200,000 requests per second