// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const fse = require("fs-extra");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run("compile");

  // We get the contract to deploy
  const HuukExchange = await hre.ethers.getContractFactory("HuukExchange");
  const huukExchange = await hre.upgrades.deployProxy(
    HuukExchange,
    [
      "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3",
      "0xA9389B343559E4c201d22BC573edfE17D81Da7D1",
      "0xae13d989dac2f0debff460ac112a837c89baa7cd",
    ],
    { initializer: "initialize", kind: "uups" }
  );

  await huukExchange.deployed();
  console.log("huukExchange deployed to:", huukExchange.address);
  return huukExchange.address;
}
// npx hardhat run --network bsc scripts/exchange.js
// 0x681bdf7830707227ca404Ff43A792062bd551B83
// npx hardhat verify --network bsc 0x6476bb91eCB90F3069EFCE25E43681e032Cb05F6

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then((add) => {
    fse.outputFileSync("address/exchange", add);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
