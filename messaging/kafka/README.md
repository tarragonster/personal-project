# Kafka Apache

## Problem:
#### Context:
- Traditional http network, client sends message to server.
#### Issue
- If server dies -> request fail
- Client and Server are coupled  
#### Solution:
- Client sends message to Kafka Broker
- Server gets message from kafka broker
- Scalability
- High availability

- Messages can be replicated across brokers
- Client (producers), Server consume message (consumers)
- Messages store in broker called topics
- Topics can be divided into partitions
- Messages go into partitions
- High availability: Kafka stores copy of that messages on different 
  partitions
- When you call "send" method for this topic, the data would be sent
  to only ONE specific partition based on the hash value of your key 
  (by default). Each partition may have a replica, which means that both 
  partitions and its replicas store the same data
- Messages can be sent in order with index number
- Consumer fail, index number can be used to continue where it left off

- Zookeeper takes care of the synchronization between the distributed clusters and manages the configurations, controlling and naming

## Reference
[ODocs] [Kafka](https://kafka.apache.org/documentation/#gettingStarted)

[Vid-code] Hussein Nasser - [Apache Kafka Crash Course](https://www.youtube.com/watch?v=R873BlNVUB4&ab_channel=HusseinNasser) \
[code] Hussein Nasser - [kafka](https://github.com/hnasr/javascript_playground/tree/master/kafka) \
[QA] [what is difference between partition and replica of a topic in kafka cluster](https://stackoverflow.com/questions/27150925/what-is-difference-between-partition-and-replica-of-a-topic-in-kafka-cluster)
[Code] marcel-dempers - [kafka](https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/messaging/kafka) \
