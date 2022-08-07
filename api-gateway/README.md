# All type of api-gateway

## API Gateway Context

### 1. What is Api Gateway?
- An API gateway acts as a reverse proxy to accept all application programming interface (API) calls,
  aggregate the various services required to fulfill them, and return the appropriate result

### 2. Why use an API gateway?
- You want to protect your APIs from overuse and abuse, so you use an authentication service and rate limiting.
- You want to understand how people use your APIs, so you’ve added analytics and monitoring tools.
- If you have monetized APIs, you’ll want to connect to a billing system.
- You may have adopted a microservices architecture, in which case a single request could require calls to dozens of distinct applications.
- Over time you’ll add some new API services and retire others, but your clients will still want to find all your services in the same place.
- An API gateway is a way to decouple the client interface from your backend implementation
- When a client makes a request, the API gateway breaks it into multiple requests, routes them to the right places, produces a response, and keeps track of everything

### 3. Api-Gateway components

- Authentication
  * Basic Authentication
  * HMAC Authentication
  * JWT Authentication
  * Key Authentication (Encrypted)
  * LDAP Authentication
  * Oauth 2.0
  * Open ID Connect
  * Session
  * Vault Authentication
  * Okta
  * PASETO
  * Upstream HTTP Basic Authentication

- Security
  * ACME
  * Bot Detection
  * CORS
  * IP Restriction
  * OPA
  * Cleafy plugin for Kong
  * Approov API Threat Protection
  * Salt Security
  * Path Allow (Determine if the path is in the path allow list, and if not, return a 403)
  * Signal Sciences
  * Wallarm (AI-Powered Security Platform for protecting microservices and APIs)

- Traffic control
  * ACL (access control list)
  * Canary Release
  * Forward Proxy
  * GraphQL Proxy Caching
  * GraphQL Rate Limiting
  * Mocking (mock endpoint to test API)
  * Proxy Cache
  * Rate Limiting
  * Request Size Limiting
  * Request Termination
  * Request Validator
  * Response Rate Limiting
  * Route By Header
  * Set Dynamic Upstream Host (Constructs the upstream hostname dynamically based on the incoming request parameters)
  * Response Size Limiting (Block responses with bodies greater than a specified size)
  * Service Virtualization (Mock virtual API request and response pairs through Kong Gateway)

- Serverless
  * AWS Lambda
  * Azure Functions
  * Apache OpenWhisk
  * Serverless Functions (Lua code)

- Analytics & Monitoring
  * Datadog
  * Prometheus
  * Zipkin
  * ArecaBay MicroSensor
  * Moesif API Analytics
  * SignalFx

- Transformations
  * Correlation ID (Correlate requests and responses using a unique ID)
  * DeGraphQL (Transform a GraphQL upstream into a REST API)
  * Exit Transformer (Customize Kong exit responses sent downstream)
  * gRPC-gateway (Access gRPC services through HTTP REST)
  * gRPC-Web (Allow browser clients to call gRPC services)
  * jq (Transform JSON objects included in API requests or responses using jq programs.)
  * Kafka Upstream (Transform requests into Kafka messages in a Kafka topic.)
  * Request Transformer (Use regular expressions, variables, and templates to transform requests)
  * Response Transformer (Modify the upstream response before returning it to the client)
  * Route Transformer Advanced (Transform routing by changing the upstream server, port, or path)
  * Inspur Request Transformer (Kong plugin to transform diversiform requests)
  * Inspur Response Transform (kong plugin to transform http response from json to xml)
  * API Transformer (Kong middleware to transform requests / responses, using Lua script.)
  * Reedelk Transformer (Kong plugin to transform Reedelk requests and responses)
  * Template Transformer (Kong middleware to transform requests / responses, using pre-configured templates.)
  * URL Rewrite (Kong middleware to completely rewrite the URL of a route.)

- Logging
  * File Log (Append request and response data to a log file)
  * HTTP Log (Send request and response logs to an HTTP server)
  * Kafka Log (Publish logs to a Kafka topic)
  * Loggly (Send request and response logs to Loggly)
  * StatsD (Send request and response logs to StatsD)
  * Syslog (Send request and response logs to Syslog)
  * TCP Log (Send request and response logs to a TCP server)
  * UDP Log (Send request and response logs to a UDP server)
  * Kong Google Cloud Logging (Logs Kong requests with Google Cloud Logging)
  * Moesif API Analytics (Powerful API analytics and tools to activate, understand, and monetize customers.)
  * Kong Splunk Log (Log API transactions to Splunk using the Splunk HTTP collector)
  * Google Analytics Log (Log API transactions to Google Analytics)

- Deployment
  * AWS with Terraform
  * Microsoft Azure Certified
  * Microsoft Azure
  * Azure Container Instances

## References

### 1.Aws Gateway

Ref: [What is Amazon API Gateway?](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html) \

### 2.Kong Gateway

Ref: [Kong gateway](https://konghq.com/kong) \
Ref: [kong-community](https://konghq.com/install#kong-community)

### 3.Zuul Gateway

Ref: [Zuul](https://github.com/Netflix/zuul)

### 4.Kraken Gateway

Ref: [krakend gateway](https://www.krakend.io)