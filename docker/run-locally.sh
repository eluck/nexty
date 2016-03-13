#!/usr/bin/env bash

docker rm -f nexty
docker rm -f mongo-nexty

docker run -d --name mongo-nexty mongo:2.6
docker run -it                        \
  --name nexty                        \
  -p 3000:80                          \
  -e MONGO_URL=mongodb://mongo-nexty  \
  -e ROOT_URL=http://localhost:3000   \
  --link mongo-nexty:mongo-nexty      \
  eluck/nexty
