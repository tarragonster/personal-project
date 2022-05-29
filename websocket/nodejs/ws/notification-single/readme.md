# Single secured Express Websocket (ws) Demo

Demo illustrates single core Secured
Websocket server using (Express)

## Start ws-notification-single docker

```
cd webserver/nodejs
docker-compose up -d ws-notification-single
```

## Run Demo

```
http://localhost:90/
Login -> attach session
Logout -> remove session
Open WebSocket connection -> establish websocket connection
Send WebSocket message -> send a msg from client to server
```

## Check connection
```
socket.on('pong', () => {
      console.log("pong")
      socket.isAlive = true
    })
```

## Total number of connected clients
```
Use wss.clients.size
```
[REF](https://github.com/websockets/ws/issues/1087)

## Authentication with session

- [Document](https://www.npmjs.com/package/express-session)
- [Example](https://github.com/websockets/ws/blob/master/examples/express-session-parse/index.js)

## Secured Websocket Example

- [Secured example](https://github.com/websockets/ws/blob/master/examples/express-session-parse/index.js)

## Websocket library

- [Document](https://github.com/websockets/ws)

## Guide Book

- [How To Send Server-Side Notifications Through WebSockets in JavaScript](https://medium.com/better-programming/solving-real-life-problems-in-javascript-sending-server-side-notifications-through-websockets-a3bdb2cc065)
    - [Demo](https://gist.github.com/iperiago/8fba72dc5f3b8e2a7b2ddc3dfd9816a5)
- [Pass Express to http and use it as server](https://blog.mrg.sh/build-a-websocket-server-using-express-and-ws-package)
```
import express from 'express';
import { createServer } from 'http';

const app = express()
const server = createServer(app)
```

## Improvement

- [Redis for websocket cluster](https://medium.com/better-programming/solving-real-life-problems-in-javascript-sending-server-side-notifications-through-websockets-a3bdb2cc065)
- [Prevent open Multiple Connections](https://medium.com/hackernoon/enforcing-a-single-web-socket-connection-per-user-with-node-js-socket-io-and-redis-65f9eb57f66a)
  - [Demo](https://github.com/mariotacke/blog-single-user-websocket/blob/master/server/index.js)
- [Comparing websocket library](https://medium.com/@denizozger/finding-the-right-node-js-websocket-implementation-b63bfca0539)
- [Serverless WebSockets with AWS Lambda & Fanout](https://medium.com/hackernoon/serverless-websockets-with-aws-lambda-fanout-15384bd30354)
- [Real time notifications using socket.io, NodeJS and angular](https://hetaram37.medium.com/real-time-notifications-using-socket-io-nodejs-and-angular-ec2df283d00b)
- [The Complete Guide to WebSockets-Hussein Nasser](https://www.youtube.com/watch?v=XgFzHXOk8IQ&ab_channel=HusseinNasser)
- [Implementing Redis Pub/Sub in Node.js Application](https://cloudnweb.dev/2019/08/implementing-redis-pub-sub-in-node-js-application/)
- [Redis pub/sub Document](https://redis.io/topics/pubsub)

  