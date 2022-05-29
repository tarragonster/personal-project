// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const fse = require("fs-extra");

async function main() {
  const HuukMarket = await hre.ethers.getContractFactory("HuukMarket");
  const huukMarket = await hre.upgrades.forceImport(
    "0xd5B702ACE1204a39202c5dd14795d9D15e7Fb797",
    HuukMarket,
    {}
  );

  await huukMarket.deployed();
  console.log("huukExchange deployed to:", huukMarket.address);
  return huukMarket.address;
}

main()
  .then((add) => {
    fse.outputFileSync("address/market", add);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
