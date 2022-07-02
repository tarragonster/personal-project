#!/bin/bash

echo "start"
sleep 5s
mongo --host mongo1:27017 --eval
      '
      config = {
        "_id" : "my-mongo-set",
        "members" : [
          {
            "_id" : 0,
            "host" : "mongo1:27017"
          },
          {
            "_id" : 1,
            "host" : "mongo2:27017"
          },
          {
            "_id" : 2,
            "host" : "mongo3:27017"
          }
        ]
      };
      rs.initiate(config);
      '