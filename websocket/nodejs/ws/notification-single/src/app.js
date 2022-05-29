import express from 'express';
import bodyParser from "body-parser";
import cors from 'cors'
import AppSocket from "./appSocket.js";
import { createServer } from 'http';
import * as uuid from 'uuid';
import session from 'express-session'
import path from 'path'

const __dirname = path.resolve("src");
const port = 3000;
const app = express()
const server = createServer(app)
const sessionParser = session({
  saveUninitialized: false,
  secret: '$eCuRiTy',
  resave: false
});

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({
  limit: '50mb',
  parameterLimit: 100000,
  extended: true
}))

// server static files from public folder
app.use(express.static(path.join(__dirname, "public")));
app.use(sessionParser)

// parse application/json
app.use(bodyParser.json({
  limit: '50mb'
}))

app.use(cors({
  origin: '*',
  methods: "GET,PUT,POST,DELETE"
}));

app.get('/', function(req, res) {
  res.status(200).sendFile(path.join(__dirname, 'public', 'index.html'))
  // res.json({
  //   msg: `Hello World!`,
  // });
});

app.post('/login', (req, res) => {
  const id = uuid.v4();
  console.log(`Updating session for user ${id}`);
  req.session.userId = id;
  res.send({ result: 'OK', message: 'Session updated' });
})

app.delete('/logout',  (req, res) => {
  const ws = wsSever.getConnection(req.session.userId);

  console.log('Destroying session');
  req.session.destroy(function () {
    if (ws) ws.close();

    res.send({ result: 'OK', message: 'Session destroyed' });
  });
});

const wsSever = new AppSocket(sessionParser);
wsSever.connect(server);

server.listen(port , function() {
  console.log(`app listening on port ${port}!`)
});