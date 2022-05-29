# Testing of kafka

## Topic

Let's create a Topic that allows us to store Order information.
To create a topic, Kafka and Zookeeper have scripts with the installer that allows us to do so.

Access the container:

```
docker exec -it zookeeper-1 bash
```

Create the Topic:

```
/kafka/bin/kafka-topics.sh \
--create \
--zookeeper zookeeper-1:2181 \
--replication-factor 1 \
--partitions 3 \
--topic Orders
```

Describe our Topic:

```
/kafka/bin/kafka-topics.sh \
--describe \
--topic Orders \
--zookeeper zookeeper-1:2181
```

## Simple Producer & Consumer

The Kafka installation also ships with a script that allows us to produce and consume messages to our Kafka network:

We can then run the consumer that will receive that message on that Orders topic:

```
docker exec -it zookeeper-1 bash

/kafka/bin/kafka-console-consumer.sh \
--bootstrap-server kafka-1:9092,kafka-2:9092,kafka-3:9092 \
--topic Orders --from-beginning
```

With a consumer in place, we can start producing messages

```
docker exec -it zookeeper-1 bash

echo "New Order: 7" | \
/kafka/bin/kafka-console-producer.sh \
--broker-list kafka-1:9092,kafka-2:9092,kafka-3:9092 \
--topic Orders > /dev/null
```

Once we have a message in Kafka, we can explore where it got stored in which partition:

```
docker exec -it kafka-1 bash

apt install -y tree
tree /tmp/kafka-logs/


ls -lh /tmp/kafka-logs/Orders-*

/tmp/kafka-logs/Orders-0:
total 4.0K
-rw-r--r-- 1 root root 10M May  4 06:54 00000000000000000000.index    
-rw-r--r-- 1 root root   0 May  4 06:54 00000000000000000000.log      
-rw-r--r-- 1 root root 10M May  4 06:54 00000000000000000000.timeindex
-rw-r--r-- 1 root root   8 May  4 06:54 leader-epoch-checkpoint       

/tmp/kafka-logs/Orders-1:
total 4.0K
-rw-r--r-- 1 root root 10M May  4 06:54 00000000000000000000.index    
-rw-r--r-- 1 root root   0 May  4 06:54 00000000000000000000.log      
-rw-r--r-- 1 root root 10M May  4 06:54 00000000000000000000.timeindex
-rw-r--r-- 1 root root   8 May  4 06:54 leader-epoch-checkpoint       

/tmp/kafka-logs/Orders-2:
total 8.0K
-rw-r--r-- 1 root root 10M May  4 06:54 00000000000000000000.index    
-rw-r--r-- 1 root root  80 May  4 06:57 00000000000000000000.log      
-rw-r--r-- 1 root root 10M May  4 06:54 00000000000000000000.timeindex
-rw-r--r-- 1 root root   8 May  4 06:54 leader-epoch-checkpoint
```

By seeing 0 bytes in partition 0 and 1, we know the message is sitting in partition 2 as it has 80 bytes.
We can check the message with :

```
cat /tmp/kafka-logs/Orders-2/*.log
```