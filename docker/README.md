# Docker Command

### 1. To kill docker

```
killall Docker && open /Applications/Docker.app
```
Ref: [Cannot kill container: <container-id>: tried to kill container, but did not receive an exit event](https://stackoverflow.com/questions/48751505/how-can-i-choose-between-client-or-pool-for-node-postgres) \

### 2. Docker command

Check disk usage of docker

```
cd /var/lib/docker
du -sch *
```

### 3. Docker log rotation

####3.1 add daemon.json to rotate logs for all service
```
cd /etc/docker
Create file: daemon.json
```

Add following code to daemon.json
```
{
   "log-driver": "json-file",
   "log-opts": {
       "max-size": "10m",
       "max-file": "3"
   }
}
```

Code Suggest that; Maximum 3 files, 10MB each can be created per container

```
sudo systemctl restart docker 
```

Restart docker

####3.2 Docker-Compose to rotate logs for specific service
```
name-of-service:
    ...
    logging:
      options:
        max-size: "10m"
        max-file: "3"
```

####3.3 Docker-Cli to rotate logs for specific service

```
docker run --name mysql --log-opt max-size=10m --log-opt max-file=5 -v /my/own/datadir:/var/lib/mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=my-secret-password -d mysql:5.6
```

####3.4 References

[Blog] ishita shah - [Why rotating Docker logs is important — How to rotate Docker logs](https://ishitashah142.medium.com/why-rotating-docker-logs-is-important-how-to-rotate-docker-logs-840520e4c47) \
[Docs] docker - [Configure logging drivers](https://docs.docker.com/config/containers/logging/configure/)

### 4. dockerd & daemon

####4.1 Reference
[Docs] docker - [dockerd](https://docs.docker.com/engine/reference/commandline/dockerd/) \

### 5. install docker ubuntu

5.1 Update the apt package index and install packages to allow apt to use a repository over HTTPS:
```
 sudo apt-get update
 sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```
5.2 Add Docker’s official GPG key:
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
5.3 Use the following command to set up the stable repository. To add the nightly or test repository, add the word nightly or test (or both) after the word stable in the commands below.
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

5.4 Install Docker Engine

```
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

5.5 Install Docker-compose

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

5.5 Reference
Ref: [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

