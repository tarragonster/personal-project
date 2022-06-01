# Fluentd introduction

###My understanding

####1. Fundamental of Fluentd
- how to run it
- how to configure it
- how to collect logs from various sources
- push logs to central place where it can be analyzed

####2. Concept 
   2.1 Input source
   - input source 1: application sending logs to a file (install on machine, configure to collect logs and send it elsewhere like web server). 
   - input source 2: application uses code logic to send logs to https endpoint (can not have fluentd installed like a cloud server).
   - input source3: collecting logs from docker host (multiple container running). 
   
   2.2 Input plugin (<source></source>) (where to get logs)
   - file: (input source 1: file based input)
      - @type -> tail: reading logs from a file (type of input plugin u would use)
      - format: log format
      - tag: tell Fluentd where to send the log (identify the log collected)
      - path: where to collect the log
      - pos_file: where it will track which line it read so it won't have to start from beginning
   - http: (input source 2)
      - @type -> http: 
      - port: where to expect logs
      - bind: address to bind to
      - body_size_limit
      - keepalive_timeout
   - docker-logging: (collect all the logs from multiple docker container)
      - check containers-fluent.conf (very similar to file)
      - /var/lib/docker/containers:/fluentd/log/containers -> volume your docker-host log to fluentd-logs
     
   2.3 output plugin (<match {tag}></match>) (do with logs. ex: dump it to local-file, forward to other fluentd, send to http/kafka/s3/cloudwatch/db/elasticsearch)
   - must match tag from input plugin
   
   2.4 filter (<filter {tag}></filter>) (post-processing pipeline - pickup log and do thing with them before sending to output plugin)
   - filter  
     - @type -> record_transformer: do thing with the log
     - <record></record> injecting field

   2.5 @include syntax (structure config -> easier to read and less complicated config)
   - create fluent.conf
   - use @include {name-file.conf}

   2.6 output logs to elasticsearch
   - elasticsearch plugin
   - install elasticsearch plugin inside a docker container (Dockerfile)
   - use <match></match> to get input logs from tags (file or http)
   - @type -> elasticsearch: define output is elasticsearch
   - host: elasticsearch host
   - port: elasticsearch port
   - index_name: concept index
   - type_name: name-of-type
### Start project

####1. Retrieve logs file from existing webserver send it to other location

```bash
file-fluent.conf -> uncomment line 17-20 / comment line 10-15
docker-compose up -d fluentd file-myapp
```
NOTE: comment all file-fluent.conf after done

####2. Stimulate an application with logging lib sending logs directly to fluentd through htt-endpoint

```shell
http-fluent.conf -> uncomment line 1-7 / comment line 9-14 / uncomment line 16-19
docker-compose up -d fluentd http-myapp
```

NOTE: comment all http-fluent.conf after done

####3. Simulate a filtered logs for file-myapp and http-myapp

filter injects hostname into logs

```shell
file-fluent.conf -> uncomment all
docker-compose up -d fluentd file-myapp
or
http-fluent.conf -> uncomment all
docker-compose up -d fluentd http-myapp
```

NOTE: comment all http-fluent.conf and file-fluent.conf after done

###6. Stimulate aggregate logs from docker into fluentd

/*/*-json.log -> dockerId/dockerId-json.log

```shell
containers-fluent.conf -> uncomment all
any other container ->
docker-compose up -d fluentd http-myapp
docker-compose up -d fluentd file-myapp
```

NOTE: comment all http-fluent.conf and containers-fluent.conf after done

###7. fluentd logs output to elasticsearch

```shell
containers-fluent.conf -> comment match block, uncomment all other
file-fluent.conf -> comment match block, uncomment all other
http-fluent.conf -> comment match block, uncomment all other

docker-compose up -d
```

###Reference

[Vid] That Devops Guys - [Understanding Logging: Containers & Microservices](https://www.youtube.com/watch?v=MMVdkzeQ848&ab_channel=ThatDevOpsGuy) \
[Vid] That Devops Guys - [Introduction to Fluentd: Collect logs and send almost anywhere](https://www.youtube.com/watch?v=Gp0-7oVOtPw&ab_channel=ThatDevOpsGuy) \
[Code] marcel-dempers - [fluentd-basic-demo](https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/monitoring/logging/fluentd/basic-demo) \
[Docs] [fluentd](https://docs.fluentd.org) \