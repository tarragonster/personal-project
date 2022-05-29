#! /bin/bash

docker stop $(docker ps -a -q) &&
docker rm -v -f $(docker ps -a -q) &&
docker image prune -a -f &&
docker volume prune -f &&
docker network prune -f