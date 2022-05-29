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
  const Contract = await hre.ethers.getContractFactory("ERC721HolderFacet");
  const contract = await Contract.deploy();
  await contract.deployed();
  console.log("ERC721HolderFacet deployed to:", contract.address);
  return contract.address;
}

main()
  .then((add) => {
    fse.outputFileSync("address/erc721HolderFacet", add);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
