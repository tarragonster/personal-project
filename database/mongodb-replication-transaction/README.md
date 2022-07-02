# Mongodb replication transaction

###Understand Replica Set Primary

- The primary is the only member in the replica set that receives write 
  operations. MongoDB applies write operations on the primary and then 
  records the operations on the primary's oplog. Secondary members replicate
  this log and apply the operations to their data sets.

- Ref: [Replica Set Primary](https://www.mongodb.com/docs/manual/core/replica-set-primary/)

### Start mongoose replication demo
1. Generate an authentication key
```shell
cd database/mongodb-replication-transaction
openssl rand -base64 756 > ./keys/mongo-key
```

2. Run docker-compose

```shell
docker-compose up -d
```

3. Open mongo-express

```shell
http://localhost:1305
user: admin
pass: pass
```

4. Test action insert db fail (transaction revert)

```shell
http://localhost:207/data
```

5. Test action insert db success

```shell
uncomment "throw new Error('lmao dead');" in app.js
http://localhost:207/data
```

- Ref: ERIC CABREL TIOGO - [Create a replica set in MongoDB with Docker Compose](https://blog.tericcabrel.com/mongodb-replica-set-docker-compose/)
- Ref: Vishal Agrawal - [MongoDB Replica Set Configuration: 7 Easy Steps](https://hevodata.com/learn/mongodb-replica-set-config/)
- Ref: Soham Kamani - [Creating a MongoDB Replica Set Using Docker](https://www.sohamkamani.com/docker/mongo-replica-set/)

### withTransaction()

- retrying either the commit operation
  or entire transaction as needed (and when the error permits) to better ensure that
  the transaction can complete successfully.
  
- Ref: [withTransaction](https://mongodb.github.io/node-mongodb-native/3.2/api/ClientSession.html#withTransaction)
- Ref: [db.withTransaction using async/await not rolling back](https://github.com/dmfay/massive-js/issues/617)

###startTransaction()

- Must be used with startTransaction, commitTransaction, abortTransaction

- Ref: [How to use mongoose to start a session for transaction?](https://stackoverflow.com/questions/67879357/nestjs-how-to-use-mongoose-to-start-a-session-for-transaction) \

### Generate an authentication key
1. Generate an authentication key
```shell
openssl rand -base64 756 > ./keys/mongo-key
```

### Mongoose sorting

```javascript
Room.find({}).sort('-date').exec((err, docs) => { ... });
Room.find({}).sort({date: -1}).exec((err, docs) => { ... });
Room.find({}).sort({date: 'desc'}).exec((err, docs) => { ... });
Room.find({}).sort({date: 'descending'}).exec((err, docs) => { ... });
Room.find({}).sort([['date', -1]]).exec((err, docs) => { ... });
Room.find({}, null, {sort: '-date'}, (err, docs) => { ... });
Room.find({}, null, {sort: {date: -1}}, (err, docs) => { ... });
```

- Ref: JohnnyHK - [In Mongoose, how do I sort by date? (node.js)](https://stackoverflow.com/questions/5825520/in-mongoose-how-do-i-sort-by-date-node-js) \

### Install mongosh ubuntu

1. Import the public key used by the package management system.

```shell
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
```

2. Create a list file for MongoDB.

```shell
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
```

3. Reload local package database

```shell
sudo apt-get update
```

4. Install the mongosh package

```shell
sudo apt-get install -y mongodb-mongosh
```
5. Execute mongo through shell script

```shell
mongo --eval "printjson(db.serverStatus())"
```
- Ref: [How to execute mongo commands through shell scripts?](https://stackoverflow.com/questions/4837673/how-to-execute-mongo-commands-through-shell-scripts)
- Ref: [db.withTransaction using async/await not rolling back](https://github.com/dmfay/massive-js/issues/617) \

###Ref Setup MongoDB Replication

[Blog] [Setup MongoDB Replication](https://medium.com/nonstopio/setup-mongodb-replication-da22d07e526) \
[Vid] [Setup MongoDB for Production deployment](https://www.youtube.com/watch?v=gChzfhVGqp8) \

### Reference

[Docs] Tidelift Subscription - [Transactions in Mongoose](https://mongoosejs.com/docs/transactions.html) \
[Blog] [MongoDB Replica Set Configuration: 7 Easy Steps](https://hevodata.com/learn/mongodb-replica-set-config/) \
[Vid] Mongodb - [MongoDB Change Streams: The Hidden Gem within the MongoDB Repertoire](https://www.youtube.com/watch?v=hPMLuHH4ZAc&ab_channel=MongoDB) \
[Issue] [failed to connect to server [mongo:27017] on first connect](https://github.com/mongo-express/mongo-express-docker/issues/35) \
[Lib] mongodb - [MongoDB NodeJS Driver](https://www.npmjs.com/package/mongodb) \
[Doc] mongosh - [Install mongosh](https://www.mongodb.com/docs/mongodb-shell/install/) \
[Code] rituparna-ui - [mongoose-transactions-example](https://github.com/rituparna-ui/mongoose-transactions-example/blob/master/index.js) \
[Code] Wanago.io - [Transactions in MongoDB and Mongoose](https://wanago.io/2021/09/06/api-nestjs-transactions-mongodb-mongoose/) \