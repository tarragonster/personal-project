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
  const PancakeRouter = await hre.ethers.getContractFactory("PancakeRouter");
  const pancakeRouter = await PancakeRouter.deploy("0x97555E3D10E5Cfe1164Bd96dF9c436A0FBDc467D", "0x8EdE5083676b07fcB087F3AF505c91563b87bDa5");

  await pancakeRouter.deployed();

  console.log("pancakeRouter deployed to:", pancakeRouter.address);

  await hre.run("verify:verify", {
    address: pancakeRouter.address,
    contract: "contracts/PancakeswapRouterV2.sol:PancakeRouter",
    constructorArguments: ["0x97555E3D10E5Cfe1164Bd96dF9c436A0FBDc467D", "0x8EdE5083676b07fcB087F3AF505c91563b87bDa5"],
  });
}
// 0xAD52144E9DeCdb8f5B90569e8A68401709F0D2f1
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
