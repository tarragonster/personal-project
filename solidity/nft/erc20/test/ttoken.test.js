const hre = require('hardhat')
const assert  = require('assert')

describe('should initialize', function () {
  before('get factories', async function () {
    this.Ttoken = await hre.ethers.getContractFactory('TToken');
  })

  it('Prints the list of accounts', async function () {
    const accounts = await hre.ethers.getSigners();
    for (const account of accounts) {
      console.log(account.address);
    }
  })

  it('deploy Ttoken and match name', async function () {
    const ttoken = await this.Ttoken.deploy();
    console.log({ ttoken: ttoken.address })

    assert(await ttoken.name() === 'TToken')
  })
})
