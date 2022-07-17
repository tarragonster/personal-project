import { io } from 'socket.io-client'
import {EventEnum} from "./enum";

const room = "123"
const socket = io("http://localhost:4000");

socket.on('welcome', (data) => console.log(data));
socket.emit('join', room);

socket.on(EventEnum.WALLET_BALANCE_INFO, (data) => console.log(data));