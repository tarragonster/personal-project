// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const PancakeFactory = await hre.ethers.getContractFactory("PancakeFactory");
  const pancakeFactory = await PancakeFactory.deploy("0xC4c615c9e22a76272417cAFBA726317c36957a33");

  await pancakeFactory.deployed();

  console.log("TToken deployed to:", pancakeFactory.address);

  await hre.run("verify:verify", {
    address: pancakeFactory.address,
    contract: "contracts/PancakeSwapFactory.sol:PancakeFactory",
    constructorArguments: ["0xC4c615c9e22a76272417cAFBA726317c36957a33"],
  });
}
// factory 0x97555E3D10E5Cfe1164Bd96dF9c436A0FBDc467D

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });