# Nodejs-udp Server Demo

udp do not require connection (connection based)
faster than tcp
stateless (client and server do not know each other)

## Start Nodejs-udp docker

```
cd webserver
docker-compose up -d nodejs-udp
```

## Run Demo

```
open local terminal
command -> echo "hi" | nc -w1 -u 0.0.0.0 15
type hello
```

## References

[CODE] hnasr - [udp](https://github.com/hnasr/javascript_playground/tree/master/tcp) \
[VIDEO] Hussein Nasser - [Building TCP & UDP Servers with Node JS](https://www.youtube.com/watch?v=1acKGwbby-E&list=PLQnljOFTspQX_Zkt_8teMRsdY4sNt4BX6&index=5&ab_channel=HusseinNasser) \
[VIDEO] Hussein Nasser - [TCP vs UDP Crash Course](https://www.youtube.com/watch?v=qqRYkcta6IE&list=PLQnljOFTspQX_Zkt_8teMRsdY4sNt4BX6&index=1&ab_channel=HusseinNasser) \