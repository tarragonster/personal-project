import hre, { ethers } from "hardhat";

const fse = require("fs-extra");
const { MARKET, PAYMENT_METHODS } = process.env;

export const withDrawCoin = async () => {
  const accounts = await ethers.getSigners();
  const marketAddress = MARKET ?? fse.readFileSync("./address/market", "utf8");
  const newMarket = await hre.ethers.getContractAt("HuukMarketNew", marketAddress);

  let t = await newMarket.balance(ethers.constants.AddressZero);
  console.log("Contract's Balance of Native Token: ", t);
  const paymentMethods = PAYMENT_METHODS.split(",");
  for (const paymentMethod in paymentMethods) {
    t = await newMarket.balance(paymentMethod);
    console.log("Contract's Balance of ERC ", paymentMethod, " ", t);
  }
  console.log("......................Withdrawing......................");
  const tx1 = await newMarket.withdrawFunds(accounts[0].address, hre.ethers.constants.AddressZero, { gasLimit: 800000 });
  await tx1.wait();
  console.log("Native token: Success");
  for (const paymentMethod in paymentMethods) {
    const tx1 = await newMarket.withdrawFunds(accounts[0].address, paymentMethod, { gasLimit: 800000 });
    await tx1.wait();
    console.log(paymentMethod, ": Success");
  }
  console.log("......................Checking......................");
  t = await newMarket.balance(ethers.constants.AddressZero);
  console.log("Contract's Balance of Native Token: ", t);
  for (const paymentMethod in paymentMethods) {
    t = await newMarket.balance(paymentMethod);
    console.log("Contract's Balance of ERC ", paymentMethod, " ", t);
  }
};
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  withDrawCoin()
    .then((add) => {
      // fse.outputFileSync("address/market", add);
    })
    // eslint-disable-next-line no-process-exit
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      // eslint-disable-next-line no-process-exit
      process.exit(1);
    });
}
