const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const mongoose = require('mongoose');

const url = 'mongodb://mongo1:27017';
const dbName = 'dummydb?replicaSet=my-mongo-set';
let db;
let Kitten;
let session;

const kittySchema = new mongoose.Schema({
  name: String
});

app.use(bodyParser.urlencoded({extended: false}));

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.get('/data', async (req, res) => {
  session = await db.startSession();

  try {
    //TODO Example with startTransaction(); uncomment to use startTransaction

    // await session.startTransaction();
    // await Kitten.findOneAndUpdate(
    //   { name: 'Ritu1 update' },
    //   { $set: { name: 'Ritu1 abc' } },
    //   { upsert: true, session }
    // );
    // throw new Error('lmao dead');
    // await Kitten.findOneAndUpdate(
    //   { name: 'Ritu2 update' },
    //   { $set: { name: 'Ritu2 abc' } },
    //   { upsert: true, session }
    // );

    //TODO Example with withTransaction(); uncomment to use withTransaction
    // https://github.com/dmfay/massive-js/issues/617

    await session.withTransaction(async () => {
      await Kitten.findOneAndUpdate(
        { name: 'Ritu1 abc' },
        { $set: { name: 'Ritu1 update' } },
        { upsert: true, session }
      );
      console.log("retry time")
      throw new Error('lmao dead');
      await Kitten.findOneAndUpdate(
        { name: 'Ritu2 abc' },
        { $set: { name: 'Ritu2 update' } },
        { upsert: true, session }
      );
    })

    //TODO Example with startTransaction(); uncomment to use startTransaction

    // await session.commitTransaction();
    res.send("SUCCESS")
  } catch (error) {
    //TODO Example with startTransaction(); uncomment to use startTransaction

    // await session.abortTransaction();
    console.log(error.message);
    // res.send(error.message);
  } finally {
    session.endSession();
  }
})

const start = async () => {
  try {
    await mongoose.connect(`${url}/${dbName}`, {
      connectTimeoutMS: 1000
    });
    db = await mongoose.connection;
    db.on('error', () => console.error("connection error"))
    db.once('open', () => console.error("connected"))

    Kitten = db.model('Kitten', kittySchema);

    app.listen('3000', function () {
      console.log("Listening on port 3000!");
    });
  } catch (err) {
    console.log(err)
    process.exit(1);
  }
}
start();
