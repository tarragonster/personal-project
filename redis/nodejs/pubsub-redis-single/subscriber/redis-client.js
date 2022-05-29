const { createClient } = require('redis')
const { environment } = require('./environment')

async function getClient() {
  const client = createClient({
    url: `${environment.REDIS_URL}`
  });
  await client.connect();

  client.on('error', (err) => console.log('Redis Client Error', err));
  client.on('connect', () => console.log('Redis Client Connected'));

  return client
}

module.exports = {
  getClient: getClient
}
