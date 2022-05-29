require('dotenv').config()

const environment = {
  REDIS_URL: process.env.REDIS_URL,
}

module.exports = {
  environment
}