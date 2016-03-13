#!/usr/bin/env bash

docker rm -f nexty
docker rm -f mongo-nexty

docker run -d --name mongo-nexty -v /data:/data mongo:2.6
docker run -d                         \
  --name nexty                        \
  -p 80:80                            \
  -e MONGO_URL=mongodb://mongo-nexty  \
  -e ROOT_URL=http://nexty.rocks      \
  --link mongo-nexty:mongo-nexty      \
  eluck/nexty
