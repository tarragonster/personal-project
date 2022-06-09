# My understanding Rabbitmq

###Questions:

####Q1: What is Rabbitmq?
- service to service asynchronous communication
- Popular in microservice

####Q2: what is asynchronous messaging?
- Service A -> service B through TCP: synchronous communication
- Synchronous communication could issue latency
- Couple service A and B, if B failed -> A must retry multiple time just to
get successful response
- Asynchronous messaging allowed service A just send message then continue with
its life and does not care about the inline respone

####Q3: what is Message queuing?
- Service A push a message to a queue then service A can go on without care
about who process the message.
- Service B picks up the message and then have an outcome.
- Service A (producer), service B (consumer), queue (broker)
- Easy to scale up.
- Spread messages out to multiple consumers.

####Q4: what is delivery at acknowledgment?
- Context: Service A put message into queue, service B picks up those message but B crashed
- If Rabbitmq configured with delivery at acknowledgment, it will expect B to put an
acknowledgment into the queue after picking up
- Service B dies and queue does not receipt acknowledgment, rabbitmq will automatically
put the message back into the queue for other consumer to pick up -> add resilience to
message queue

####Q5: Rabbitmq advance?
- Distributed deployment mechanism to setup instances in highly available manner like cluster
- Cloud and kubernetes ready.
- Tool and management plugin.

####Q6: What is channels?
- Channels are virtual connections to a specific queue.
- Define a queue and then putting messages into that queue.

####Q7 What is Rabbitmq Exchange

- Exchange is responsible for routing the messages to different queues with the help of header attributes, bindings,
and routing keys
- A binding is a "link" that you set up to bind queue to an exchange
- routing key is a message attribute the exchange looks at when deciding how to route the messages to queues

Ref: [Rabbitmq exchanges, routing keys and bindings](https://www.cloudamqp.com/blog/part4-rabbitmq-for-beginners-exchanges-routing-keys-bindings.html#:~:text=Exchanges%20are%20message%20routing%20agents,a%20queue%20to%20an%20exchange.)

####Q8 what is standard Rabbitmq message flow?
1. The producer publishes a message to exchange.
2. The exchange receives the message and is now responsible for the routing of the message.
3. Binding must be set up between the queue and the exchange. In this case, we have bindings to two different queues
from the exchange. The exchange routes the message into the queues.
4. The message stay in the queue until they are handled by a consumer
5. The consumer handles the message.

