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
  const Huuk1155Premium = await hre.ethers.getContractFactory(
    "Huuk1155Premium"
  );
  const huuk1155Premium = await hre.upgrades.deployProxy(
    Huuk1155Premium,
    ["Huuk1155 Premium", "v1", "https://api.huuk.market"],
    { initializer: "initialize", kind: "uups" }
  );

  await huuk1155Premium.deployed();
  console.log("Huuk1155Premium deployed to:", huuk1155Premium.address);
  return huuk1155Premium.address;
}

main()
  .then((add) => {
    fse.outputFileSync("address/huuk1155Premium", add);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
