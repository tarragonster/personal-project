# Microservice Pattern


### Principles of microservice architecture?

- Scalability
- Availability
- Resiliency
- Flexibility
- Independent, autonomous
- Decentralized governance
- Failure isolation
- Auto-Provisioning
- Continuous delivery through DevOps

### Decomposition Patterns

#### 1. Decompose by Business Capability
- single responsibility principle
- Order Management is responsible for orders
- Customer Management is responsible for customers

#### 2. Decompose by Subdomain
- Define services corresponding to Domain-Driven Design (DDD) subdomains
- A domain is consists of multiple subdomains. Each subdomain corresponds to a different part of the business

#### 3. Decompose by Transactions
- Two-phase commit (2pc) pattern (prepare/commit)
- Three-phase commit (2pc) pattern (prepare/precommit/commit)
- Saga pattern (prepare/commit)

#### 4. Strangler Pattern
- This creates two separate applications that live side by side in the same URI space
- the newly refactored application “strangles” or replaces the original application until finally, you can shut off the monolithic application
- Transform (Create a parallel new site with modern approaches). 
- Coexist (Leave the existing site where it is for a time. Redirect from the existing site to the new one so the functionality is implemented incrementally)
- Eliminate (Remove the old functionality from the existing site)

#### 5. Bulkhead Pattern
- Isolate elements of an application into pools so that if one fails, the others will continue to function
- Partition service instances into different groups, based on consumer load and availability requirements
- isolate failures, and allows you to sustain service functionality for some consumers, even during a failure

#### 6. Sidecar Pattern

- Deploy components of an application into a separate processor container to provide isolation and encapsulation
- This pattern can also enable applications to be composed of heterogeneous components and technologies
- Resembles a sidecar attached to a motorcycle
- Ref: CodeOpinion - [Sidecar Pattern to SIMPLIFY services or just more COMPLEXITY?](https://www.youtube.com/watch?v=9zAjtcf9Wyo&ab_channel=CodeOpinion)

### Integration Patterns

#### 7. API Gateway Pattern

- **Problem with microservice**:
  * There are multiple calls for multiple microservices by different channels
  * There is a need for handling different type of Protocols
  * Different consumers might need a different format of the responses
- **API Gateway helps to address many concerns raised by the microservice implementation**:
  * An API Gateway is the single point of entry for any microservice call
  * It can work as a proxy service to route a request to the concerned microservice
  * It can aggregate the results to send back to the consumer
  * This solution can create a fine-grained API for each specific type of client
  * It can also convert the protocol request and respond
  * It can also offload the authentication/authorization responsibility of the microservice

#### 8. Aggregator Pattern

- necessary to think about how to collaborate the data returned by each service
- This responsibility cannot be left with the consumer
- It talks about how we can aggregate the data from different services and then send the final response to the consumer
- Composite microservice will make calls to all the required microservices, consolidate the data, and transform the data before sending back
- An API Gateway can also partition the request to multiple microservices and aggregate the data before sending it to the consumer
- Ref: Mark Richards - [Lesson 44 - Microservices Aggregation Pattern](https://www.youtube.com/watch?v=fZkMxA_TKS4&ab_channel=MarkRichards)
- Ref: Green Learner -  [Aggregator Pattern || Branch Pattern || Chained Pattern || Microservices Integration Patterns](https://www.youtube.com/watch?v=hGIe2wUmL2c&ab_channel=GreenLearner)

#### 9. Proxy Pattern

- API gateway we just expose Microservices over API gateway
- The API gateway has three API modules
- Ref: [The Proxy Pattern Explained and Implemented in Java](https://www.youtube.com/watch?v=TS5i-uPXLs8&ab_channel=Geekific)

#### 10. Gateway Routing Pattern

- The API gateway is responsible for request routing
- API operations by routing requests to the corresponding service
- When it receives a request, the API gateway consults a routing map that specifies which service to route the request to
- A routing map might, for example, map an HTTP method and path to the HTTP URL of service
- This function is identical to the reverse proxying features provided by web servers such as NGINX

#### 11. Chained Microservice Pattern

- Chained microservice design pattern will help you to provide the consolidated outcome to your request
- The request received by a microservice-1, which is then communicating with microservice-2 and it may be communicating with microservice-3
- All these services are synchronous calls
- Ref: Java Expert - [Chained or Chain of Responsibility Pattern](https://www.youtube.com/watch?v=mg8b3Zjl2Ww&t=130s&ab_channel=JavaExpert)

#### 12. Branch Pattern

- A microservice may need to get the data from multiple sources including other microservices
- Branch microservice pattern is a mix of Aggregator & Chain design patterns and allows simultaneous request/response processing from two or more microservices
- Brach pattern can also be used to invoke different chains of microservices, or a single chain
- Ref: Green Learner - [Aggregator Pattern || Branch Pattern || Chained Pattern || Microservices Integration Patterns](https://www.youtube.com/watch?v=hGIe2wUmL2c&ab_channel=GreenLearner)

#### 13. Client-Side UI Composition Pattern

- the UI has to be designed as a skeleton with multiple sections/regions of the screen/page
- Each section will make a call to an individual backend microservice to pull the data
- Frameworks like AngularJS and ReactJS help to do that easily

### Database Patterns
- Services must be loosely coupled
- Business transactions may enforce invariants that span multiple services
- Some business transactions need to query data that is owned by multiple services
- Databases must sometimes be replicated and shared in order to scale
- Different services have different data storage requirements

#### 14. Database per Service

- one database per microservice must be designed
- it must be private to that service only
- It should be accessed by the microservice API only
- It cannot be accessed by other services directly

#### 15. Shared Database per Service

- It is anti-pattern for microservices
- But if the application is a monolith and trying to break into microservices, denormalization is not that easy
- A shared database per service is not ideal, but that is the working solution for the above scenario

#### 16. Command Query Responsibility Segregation (CQRS)

- there is a requirement to query, which requires joint data from multiple services
- it’s not possible
- CQRS suggests splitting the application into two parts — the command side and the query side
- The command side handles the Create, Update, and Delete requests
- The query side handles the query part by using the materialized views
- The event sourcing pattern is generally used along with it to create events for any data change
- Ref: CodeOpinion - [Is CQRS Complicated? No, it's simple!](https://www.youtube.com/watch?v=LbVpPQaAgVY&ab_channel=CodeOpinion)
- 

#### 17. Event Sourcing
- Application work with data to maintain the current state
- in the traditional create, read, update, and delete (CRUD) model a typical data process 
is to read data from the store. It contains limitations of locking the data with often using transactions
- The Event Sourcing pattern defines an approach to handling operations on data that’s driven by a sequence 
of events, each of which is recorded in an append-only store
- Application code sends a series of events that imperatively describe each action that has occurred on the data to the event store
- Each event represents a set of changes to the data
- The events are persisted in an event store that acts as the system of record
- Ref: CodeOpinion - [Event Sourcing Example & Explained](https://www.youtube.com/watch?v=AUj4M-st3ic&t=243s&ab_channel=CodeOpinion)
- Ref: CodeOpinion - [CQRS & Event Sourcing Code Walk-Through](https://www.youtube.com/watch?v=5aznkIEvkKc&t=242s&ab_channel=CodeOpinion)
- Ref: CodeOption - [Projections in Event Sourcing: Build ANY model you want!](https://www.youtube.com/watch?v=bTRjO6JK4Ws&ab_channel=CodeOpinion)

#### 18. Saga Pattern
- each service has its own database and a business transaction spans multiple services
- how do we ensure data consistency across services
- Each request has a compensating request that is executed when the request fails
- It can be implemented in two ways:
  * `Choreography`: no central coordination, each service produces and listens to 
  another service’s events and decides if an action should be taken or not. 
  It dictates acceptable patterns of requests and responses between parties
  * `Orchestration`: An orchestrator (object) takes responsibility for a saga’s 
  decision making and sequencing business logic. when they’re all in one domain 
  of control and you can control the flow of activities

### Observability Patterns

#### 19. Log Aggregation
- Each service instance generates a log file in a standardized format
- We need a centralized logging service
- PCF does have Log aggregator, which collects logs from each component
  of the PCF platform along with applications

#### 20. Performance Metrics
- When the service portfolio increases due to a microservice architecture
- it becomes critical to keep a watch on the transactions so that patterns can be monitored and alerts sent when an issue happens
- A metrics service is required to gather statistics about individual operations
- It should aggregate the metrics of an application service
- `There are two models for aggregating metrics`:
  * Push — the service pushes metrics to the metrics service e.g. NewRelic, AppDynamics
  * Pull — the metrics services pulls metrics from the service e.g. Prometheus

#### 21. Distributed Tracing
- Requests often span multiple services
- Each service handles a request by performing one or more operations across multiple services
- While in troubleshoot it is worth to have trace ID, we trace a request end-to-end
- The solution is to introduce a transaction ID
  * Assigns each external request a unique external request id
  * Passes the external request id to all services
  * Includes the external request id in all log messages

#### 22. Health Check
- there is a chance that a service might be up but not able to handle transactions
- Each service needs to have an endpoint which can be used to check the health of the application
- This API should o check the status of the host, the connection to other services/infrastructure, and any specific logic


### Cross-Cutting Concern Patterns

#### 23. External Configuration
- Config server
- For each environment like dev, QA, UAT, prod, the endpoint URL or some configuration properties might be different
- change in any of those properties might require a re-build and re-deploy of the service
- To avoid code modification configuration can be used. Externalize all the configuration, including endpoint URLs and credentials

#### 24. Service Discovery Pattern

- With container technology, IP addresses are dynamically allocated to the service instances
- Every time the address changes, a consumer service can break and need manual changes
- Each service URL has to be remembered by the consumer and become tightly coupled
- A service registry needs to be created which will keep the metadata of each producer service and specification for each
- A service instance should register to the registry when starting and should de-register when shutting down
- There are 2 types of service discovery:
  * client-side : eg: Netflix Eureka
  * Server-side : eg: AWS ALB
- Ref: [MICROSERVICES ARCHITECTURE | SERVICE REGISTRY](https://www.youtube.com/watch?v=LsJ1dw0qtWs&ab_channel=TechDummiesNarendraL)

#### 25. Circuit Breaker Pattern
- A service generally calls other services to retrieve data, and there is the chance that the downstream service may be down
- Problem-1: the request will keep going to the down service, exhausting network resources, and slowing performance
- Problem-2: the user experience will be bad and unpredictable
- The consumer should invoke a remote service via a proxy that behaves in a similar fashion to an electrical circuit breaker
- for the duration of a timeout period, all attempts to invoke the remote service will fail immediately
- After the timeout expires the circuit breaker allows a limited number of test requests to pass through
- If those requests succeed, the circuit breaker resumes normal operation

#### 26. Blue-Green Deployment Pattern

- With microservice architecture, one application can have many microservices
- If we stop all the services then deploy an enhanced version, the downtime will be huge and can impact the business
- Also, the rollback will be a nightmare. Blue-Green Deployment Pattern avoid this
- The blue-green deployment strategy can be implemented to reduce or remove downtime
- It achieves this by running two identical production environments, Blue and Green.
- Let’s assume Green is the existing live instance and Blue is the new version of 
the application. At any time, only one of the environments is live, with the live 
environment serving all production traffic


### References

[Blog] madhuka udantha - [Microservice Architecture and Design Patterns for Microservices](https://medium.com/@madhukaudantha/microservice-architecture-and-design-patterns-for-microservices-e0e5013fd58a) \
