const dgram = require('dgram');
const socket = dgram.createSocket('udp4');

socket.on('message', (msg, rinfo) => {
  console.log(`server got: ${msg} from ${rinfo.address}:${rinfo.port}`);
});

socket.bind(8080); //echo "hi" | nc -w1 -u 0.0.0.0 15
                        // nc -u 0.0.0.0 15