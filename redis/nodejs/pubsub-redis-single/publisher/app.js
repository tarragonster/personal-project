// Require the framework and instantiate it
const fastify = require('fastify')({
  logger: true,
  disableRequestLogging: true
});
let client;
const redisClient = require('./redis-client')

// Declare a route
fastify.get('/', async (req, res) => {
  const user = {
    id: "123456",
    name: "Davis",
  }
  await client.publish("user-notify", JSON.stringify(user))
  res.send("Publishing an Event using Redis")
})

// Run the server!
const start = async () => {
  try {
    client = await redisClient.getClient();
    await fastify.listen(3000, "0.0.0.0");
    fastify.log.info(`server listening on ${fastify.server.address().port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
}
start();