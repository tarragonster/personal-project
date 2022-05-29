import { WebSocketServer } from 'ws'
class AppSocket {
  constructor(sessionParser) {
    this.connections = new Map();
    this.sessionParser = sessionParser
  }

  connect (server) {
    this.wsServer = new WebSocketServer({ noServer: true });
    this.interval = setInterval(this.checkAll.bind(this), 10000)
    this.wsServer.on("close", this.close.bind(this))
    this.wsServer.on("connection", this.add.bind(this))

    server.on("upgrade", (request, socket, head) => {
      console.log("websocket upgraded")
      console.log('Parsing session from request...');
      this.sessionParser(request, {}, () => {
        if (!request.session.userId) {
          socket.write("HTTP/1.1 401 Unauthorized\r\n\r\n");
          socket.destroy();
          return;
        }

        console.log("Session is parsed!");

        this.wsServer.handleUpgrade(request, socket, head,  (ws) => {
          this.wsServer.emit("connection", ws, request);
        });
      })
    })
  }

  add (socket, request) {
    const userId = request.session.userId;
    socket.on("message", (message) => {
      console.log(`Received message ${message} from user ${userId}`);
    })

    socket.isAlive = true
    socket.on('pong', () => {
      console.log("pong")
      socket.isAlive = true
    })
    socket.on('close', this.remove.bind(this, userId))
    this.connections.set(userId, socket)
  }

  send (id, message) {
    const connection = this.connections.get(id)
    connection.send(JSON.stringify(message))
  }

  broadcast (message) {
    this.connections.forEach(connection =>
      connection.send(JSON.stringify(message))
    )
  }

  isAlive (id) {
    return !!this.connections.get(id)
  }

  checkAll () {
    console.log(`connected clients ${this.wsServer.clients.size}`)
    this.connections.forEach((connection, key) => {
      console.log(`connection_key ${key}`)
      if (!connection.isAlive) {
        console.log(`terminate ${key}`)
        return connection.terminate()
      }

      connection.isAlive = false
      connection.ping('')
    })
  }

  remove (id) {
    console.log(`close_connection_with_client ${id}`)
    this.connections.delete(id)
  }

  getConnection(key) {
    return this.connections.get(key)
  }

  close () {
    clearInterval(this.interval)
  }
}

export default AppSocket;