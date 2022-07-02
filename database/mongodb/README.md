# Mongodb demo

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

### Reference
[Vid] Mongodb - [MongoDB Change Streams: The Hidden Gem within the MongoDB Repertoire](https://www.youtube.com/watch?v=hPMLuHH4ZAc&ab_channel=MongoDB) \
[Issue] [failed to connect to server [mongo:27017] on first connect](https://github.com/mongo-express/mongo-express-docker/issues/35) \
[Lib] mongodb - [MongoDB NodeJS Driver](https://www.npmjs.com/package/mongodb) \
[Doc] mongosh - [Install mongosh](https://www.mongodb.com/docs/mongodb-shell/install/)