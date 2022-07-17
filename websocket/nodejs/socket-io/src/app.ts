import express from "express";
import bodyParser from "body-parser";
import cors from "cors";
import 'dotenv/config'
import {createServer} from "http";
import {Server} from 'socket.io'
import {NotificationType} from "./type";
import {EventEnum} from "./enum";

const port = 4000;
const app = express();
app.use(cors());
app.use(bodyParser.json());

const server = createServer(app)
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
    credentials: true
  }
})

io.on("connection", (socket) => {
  socket.emit("welcome", "Welcome to socket server")
  console.log(` ${socket.id} had connection ...`)
  socket.on('join', async (room: string) => {
    console.log(`${socket.id} join room ${room}`)
    socket.join(room);
  })

  socket.on(EventEnum.WALLET_BALANCE_INFO, async (data: NotificationType) => {
    console.log(`sender ${socket.id} send data to room ${data.room}`)
    io.in(data.room).emit(EventEnum.WALLET_BALANCE_INFO, data.data)
  })

  socket.on("disconnect", () => {
    console.log(`${socket.id} left`)
  })
})

server.listen(port, function () {
  console.log(`app listening on port ${port}!`)
});

