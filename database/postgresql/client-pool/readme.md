# Choose between client and pool
Use a pool if you have or expect to have multiple concurrent requests. That is literally what it is there for: to provide a pool of re-usable open client instances (reduces latency whenever a client can be reused).

In that case you definitely do not want to call pool.end() when your query completes, you want to reserve that for when your application terminates because pool.end() disposes of all the open client instances. (Remember, the point is to keep up to a fixed number of client instances available.)

## References

[Community] user268396 - [How can I choose between Client or Pool for node-postgres](https://stackoverflow.com/questions/48751505/how-can-i-choose-between-client-or-pool-for-node-postgres) \
[Vid] Hussein Nasser - [Connection Pooling in PostgresSQL with NodeJS (Performance Numbers)](https://www.youtube.com/watch?v=GTeCtIoV2Tw&t=328s&ab_channel=HusseinNasser) \
[Vid] Hussein Nasser - [Step by Step Javascript and Postgres Tutorial using node-postgres](https://www.youtube.com/watch?v=ufdHsFClAk0&ab_channel=HusseinNasser) \
