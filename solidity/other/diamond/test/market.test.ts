import { expect } from "chai";
import { ethers, upgrades } from "hardhat";

describe("Market", function () {
  before("get market factories and nft factories", async function () {
    this.erc721 = "0x4Db3f02644968A9c4e3D8Cc244d89c25e442BCA8";
    this.huukExchange = "0x681bdf7830707227ca404Ff43A792062bd551B83";
    this.huukProfitEstimator = "0x2AE2A08E20dcee4ff314188680C3f56224b8720e";
    this.referral = "0x81cFe49C4d0D3eB437716b730a7C48d854d0198E";

    // this.accounts = await ethers.getSigners();
    // this.Market = await ethers.getContractFactory("HuukMarket");
    this.Erc721 = await ethers.getContractFactory("Huuk721General");
  });

  it("deploy Erc721", async function () {
    this.erc721 = await upgrades.deployProxy(this.Erc721, ["Huuk721", "Huuk721", "v1", "https://api.huuk.market"], { initializer: "initialize", kind: "uups" });
    console.log("contract erc721: " + this.erc721.address);
    expect(true);
  });

  it("create token", async function () {
    const owner = "0xFF08483293718b26a098f662EA3B232332DFe02E";
    const uri = "test";
    const royaltyFee = 10;
    const signerNonce = 10;
    const signature = "0xd42e4dab0b67df327a5ba4b4049d519d8a67c1fd63b1a8ab93a6b6f28c4c6c77187626e7837f027bd02732282969271e3db8fc249f3f18bd66a173e9497645f41b"; // TODO create signature
    console.log("chainId: " + (await this.erc721.getChainID()));
    await this.erc721.create(owner, uri, royaltyFee, signerNonce, signature);
    console.log(await this.erc721.totalSupply());
    expect(true);
  });

  // it("deploy market", async function() {
  //   this.market = await upgrades.deployProxy(
  //     this.Market,
  //     ["HuukMarket", "V1"],
  //     { initializer: "initialize", kind: "uups" }
  //   );

  //   console.log("contract address: " + await this.market.address)

  //   await this.market.addHuukNFTs(
  //     this.erc721,
  //     true
  //   );

  //   await this.market.setReferralContract(
  //     this.referral
  //   );

  //   await this.market.setHuukExchangeContract(
  //     this.huukExchange
  //   );

  //   await this.market.setPaymentMethod(
  //     "0xA9389B343559E4c201d22BC573edfE17D81Da7D1",
  //     true
  //   );

  //   await this.market.setPaymentMethod(
  //     "0xae13d989dac2f0debff460ac112a837c89baa7cd",
  //     true
  //   );

  //   await this.market.setPaymentMethod(
  //     "0x8ede5083676b07fcb087f3af505c91563b87bda5",
  //     true
  //   );

  //   await this.market.setProfitSenderContract(
  //     "0x2AE2A08E20dcee4ff314188680C3f56224b8720e"
  //   );

  //   expect(await this.market.huukExchangeContract()).to.be.eq(this.huukExchange)
  // })

  // it("test lazybuy", async function() {
  //   const owner = "0xFF08483293718b26a098f662EA3B232332DFe02E";
  //   const token = "0x4Db3f02644968A9c4e3D8Cc244d89c25e442BCA8";
  //   const id = 0;
  //   const uri = "test";
  //   const initialSupply = 1;
  //   const maxSupply = 1;
  //   const royaltyFee = 10;
  //   const signer_nonce = 9; //TODO change this value
  //   const isERC721 = true;

  //   const paymentToken = "0xA9389B343559E4c201d22BC573edfE17D81Da7D1";
  //   const price = 100000000000000;
  //   const amount = 1;
  //   const signature = "0xafc40d2de6168fb926b4c02e7894669c3d9eff8a7d56eedf454a22bca77a56373d0246862a4f10ee9501c235ec76d115a7f97947207bf394b25c675017b281d41c" //TODO create signature
  //   const lazyBuyTuple = [[owner, token, id, uri, initialSupply, maxSupply, royaltyFee, signer_nonce, isERC721], paymentToken, price, amount];
  //   console.log(lazyBuyTuple)

  //   await this.market.lazyBuy(lazyBuyTuple, amount, signature);
  //   expect(true)
  // })
});
