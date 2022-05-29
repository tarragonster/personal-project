const {create} = require('ipfs-http-client');

const client = async () => {
  const ipfs = await create({
    host: "ipfs.infura.io",
    port: 5001,
    protocol: "https"
  })

  return ipfs
}

async function main() {
  let ipfs = await client();
  const file = await ipfs.add("text1")
  console.log(file)
}

main();

//ref https://www.youtube.com/watch?v=jI6wcuY8p2Y&t=261s&ab_channel=AdityaJoshi
// limi https://community.infura.io/t/ipfs-hosting-files-for-free/3498/3