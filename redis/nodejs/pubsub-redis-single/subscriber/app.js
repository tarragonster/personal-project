// Require the framework and instantiate it
const fastify = require('fastify')({
  logger: true,
  disableRequestLogging: true
});
let client;
const redisClient = require('./redis-client')

// Declare a route
fastify.get('/', async (req, res) => {
  client.subscribe("user-notify", (message) => {
    console.log(message);
  })

  res.send("Subscriber One")
})

// Run the server!
const start = async () => {
  client = await redisClient.getClient()
  try {
    await fastify.listen(3000, "0.0.0.0");
    fastify.log.info(`server listening on ${fastify.server.address().port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
}
start();