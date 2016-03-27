#!/usr/bin/env bash

ssh -i ~/.ssh/nextyrocks.pem ubuntu@nexty.rocks bash -c "                   \
  echo logged in
                                                                            \
  sudo docker pull eluck/nexty                                          ;   \
  sudo docker rm -f nexty                                               ;   \
  sudo docker rm -f mongo-nexty                                         ;   \

  sudo docker run -d --name mongo-nexty -v /data:/data mongo:2.6        &&  \
  sudo docker run -d                         \
    --name nexty                        \
    -p 80:80                            \
    -e MONGO_URL=mongodb://mongo-nexty  \
    -e ROOT_URL=http://nexty.rocks      \
    --link mongo-nexty:mongo-nexty      \
    eluck/nexty
"
