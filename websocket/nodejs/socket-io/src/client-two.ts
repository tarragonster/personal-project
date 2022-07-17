import { io } from 'socket.io-client'
import {EventEnum} from "./enum";


const socket = io("http://localhost:4000");

socket.on('welcome', (data) => console.log(data));

socket.emit(EventEnum.WALLET_BALANCE_INFO, {
  room: "123",
  data: {
    msg: "test"
  }
});