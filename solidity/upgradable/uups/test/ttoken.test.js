const hre = require('hardhat')
const assert  = require('assert')

describe('should initialize', function () {
  before('get factories', async function () {
    this.Ttoken = await hre.ethers.getContractFactory('TToken');
    this.TTokenV2 = await hre.ethers.getContractFactory('TTokenV2');
    this.TTokenV3 = await hre.ethers.getContractFactory('TTokenV3');
  })

  it('Prints the list of accounts', async function () {
    const accounts = await hre.ethers.getSigners();
    for (const account of accounts) {
      console.log(account.address);
    }
  })

  it('deploy Ttoken and match name', async function () {
    this.ttokenv1 = await hre.upgrades.deployProxy(this.Ttoken, { kind: 'uups' });
    console.log({ ttokenv1: this.ttokenv1.address });
    assert(await this.ttokenv1.name() === 'TToken');
  })

  it('deploy TtokneV2 and match version', async function () {
    this.ttokenv2 = await hre.upgrades.upgradeProxy(this.ttokenv1, this.TTokenV2);
    console.log({ ttokenv2: this.ttokenv2.address });
    assert(await this.ttokenv2.version() === 'V2!');
  })

  it('deploy TtokneV3 and match version', async function () {
    this.ttokenv3 = await hre.upgrades.upgradeProxy(this.ttokenv1, this.TTokenV3);
    console.log({ ttokenv3: this.ttokenv3.address });
    assert(await this.ttokenv3.version() === 'V3!');
  })
})
