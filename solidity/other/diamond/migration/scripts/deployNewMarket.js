import hre from "hardhat";

const fse = require("fs-extra");
const { MARKET } = process.env;

export const deployNewMarket = async () => {
  const oldMarketAddress = MARKET ?? fse.readFileSync("./address/market", "utf8");
  const HuukMarketNew = await hre.ethers.getContractFactory("HuukMarketNew");
  const huukMarketNew = await hre.upgrades.upgradeProxy(oldMarketAddress, HuukMarketNew);
  await huukMarketNew.deployed();
  console.log("HuukMarketNew deployed to:", huukMarketNew.address);
  return huukMarketNew.address;
};

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  deployNewMarket()
    .then((add) => {
      fse.outputFileSync("address/market", add);
    })
    // eslint-disable-next-line no-process-exit
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      // eslint-disable-next-line no-process-exit
      process.exit(1);
    });
}
