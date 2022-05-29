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
  const Huuk1155General = await hre.ethers.getContractFactory(
    "Huuk1155General"
  );
  const huuk1155General = await hre.upgrades.deployProxy(
    Huuk1155General,
    ["Huuk1155", "v1", "https://api.huuk.market"],
    { initializer: "initialize", kind: "uups" }
  );

  await huuk1155General.deployed();
  console.log("huuk1155General deployed to:", huuk1155General.address);
  return huuk1155General.address;
}
main()
  .then((add) => {
    fse.outputFileSync("address/huuk1155", add);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
