const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const { MongoClient } = require('mongodb');

const url = 'mongodb://admin:pass@mongo-demo:27017';
const client = new MongoClient(url);
const dbName = 'dummydb';
let db

app.use(bodyParser.urlencoded({extended: false}));

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.get('/data', async (req, res) => {
  const findResult = await db.collection("dummycollection").find({}).toArray();
  res.status(200).send(findResult)
})


const start = async () => {
  try {
    await client.connect();
    console.log('Connected successfully to server');
    db = client.db(dbName);

    app.listen('3000', function () {
      console.log("Listening on port 3000!");
    });
  } catch (err) {
    process.exit(1);
  }
}
start();
