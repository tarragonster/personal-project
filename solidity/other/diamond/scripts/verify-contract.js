const hre = require("hardhat");
const fse = require("fs-extra");

async function main() {
  await hre.run("verify:verify", {
    address: "0x0cd367c2240B2DC3598b09aa1ed37E399bD5DF85",
    constructorArguments: [
      "0xf956d7d4869b0681DE26CF5c96Fc6b14B65BBBB1",
      "0xc5E81195b9eBbeB61493ECB3baB4a17E969291EC",
    ],
  });

  // const diamondAddress = fse.readFileSync("./address/diamond", "utf8");
  // console.log(diamondAddress)
  //
  // const OperationFacet = await hre.ethers.getContractFactory("OperationFacet");
  // const operationFacet = await OperationFacet.attach(diamondAddress);
  //
  // await operationFacet.whiteListOperator(hre.ethers.getSigners()[1], true)
  //
  // const Market = await hre.ethers.getContractFactory("HuukMarketFacet");
  // const market = await Market.attach(diamondAddress);
  //
  // await market.addHuukNFTs(
  //   "0x7057B47d965707a6d0b70BeE1F157A12bba5Bb49",
  //   true
  // );
  //
  // await market.addHuukNFTs(
  //   "0xcad18eF199f052323DE5debe15D72AF26741C538",
  //   true
  // );
  //
  // await market.addHuukNFTs(
  //   "0x68F30c260adD87f55588bD41B98d40825bD9f2B3", // nft721premium
  //   true
  // );
  //
  // await market.addHuukNFTs(
  //   "0xB4738466E6B4279535Faa90FC7A221A8f5829957", // nft1155premium
  //   true
  // );
  //
  // await market.setReferralContract(
  //   "0xd4D617344507659BC4fBa6002cB62C186952CFcd"
  // );
  //
  // await market.setHuukExchangeContract(
  //   "0x681bdf7830707227ca404Ff43A792062bd551B83"
  // );
  //
  // await market.setPaymentMethod(
  //   "0xA9389B343559E4c201d22BC573edfE17D81Da7D1",
  //   true
  // );
  //
  // await market.setPaymentMethod(
  //   "0xae13d989dac2f0debff460ac112a837c89baa7cd",
  //   true
  // );
  //
  // await market.setProfitSenderContract(
  //   "0x2AE2A08E20dcee4ff314188680C3f56224b8720e"
  // );
  //
  // await market.setSystemFee(250, 250, 10000, 0, 0, 0, 0)
}

main()