import { expect } from "chai";
import { ethers, upgrades } from "hardhat";

describe("Exchange", function () {
  before('get factories and prepare tokenAddress', async function () {
    this.uniswapRouter = "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3";
    this.usdt = "0xA9389B343559E4c201d22BC573edfE17D81Da7D1";
    this.wrappedToken = "0xae13d989dac2f0debff460ac112a837c89baa7cd";
    this.otherToken = "0x8ede5083676b07fcb087f3af505c91563b87bda5";
    this.address0 = "0x0000000000000000000000000000000000000000";

    this.accounts = await ethers.getSigners();
    this.deployer = this.accounts[0].address;

    this.Exchange = await ethers.getContractFactory('Exchange');
  })

  it("Should deploy contract Exchange", async function () {
    this.exchange = await upgrades.deployProxy(
      this.Exchange,
      [this.uniswapRouter, this.usdt, this.wrappedToken],
      { kind: 'uups' }
    );

    expect(await this.exchange.USDT()).to.be.equal(this.usdt);
  });

  it("Should estimate USDT value of wrappedToken", async function () {
    const amountInUSDT = await this.exchange.estimateToUSDT(this.address0, "1000000000000000000");
    console.log({ wrappedTokenToUSDT: amountInUSDT.toString() });

    expect(amountInUSDT.toString()).to.be.eq("425814425659636652926") // 1 wrappedToken = 426USDT
  })

  it("Should estimate USDT value of otherToken", async function () {
    const amountInUSDT = await this.exchange.estimateToUSDT(this.otherToken, "1000000000000000000");
    console.log({ otherTokenToUSDT: amountInUSDT.toString() });

    expect(amountInUSDT.toString()).to.be.eq("82282053771056328") // 1 otherToken = 0.08USDT
  })

  it("Should estimate wrappedToken value of USDT", async function () {
    const amountInUSDT = await this.exchange.estimateFromUSDT(this.address0, "1000000000000000000");
    console.log({ USDTToWrappedToken: amountInUSDT.toString() });

    expect(amountInUSDT.toString()).to.be.eq("1231008025805029") // 1 usdt = 0,0012wrappedToken
  })

  it("Should estimate otherToken value of USDT", async function () {
    const amountInUSDT = await this.exchange.estimateFromUSDT(this.otherToken, "1000000000000000000");
    console.log({ USDTToOtherToken: amountInUSDT.toString() });

    expect(amountInUSDT.toString()).to.be.eq("12026087247586435897") // 1 usdt = 12,02otherToken
  })
});
