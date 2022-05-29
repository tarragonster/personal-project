// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const fse = require("fs-extra");

async function main() {
  const Contract = await hre.ethers.getContractFactory("HuukMarketFacet");
  const contract = await Contract.deploy();
  await contract.deployed();
  console.log("HuukMarketFacet deployed to:", contract.address);
}
// yarn hardhat run --network bsc scripts/market.js
// 0x219CBE6128FFB9568564E876F2E6C18a9889111C
// yarn hardhat verify --network bsc 0x12D1E63E083aDa324b32ccD81F6A996793970AA0

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then((add) => {
    fse.outputFileSync("address/market", add);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
