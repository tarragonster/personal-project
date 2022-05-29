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
  const HuukProfitEstimator = await hre.ethers.getContractFactory(
    "HuukProfitEstimator"
  );
  const huukProfitEstimator = await hre.upgrades.deployProxy(
    HuukProfitEstimator,
    [
      "0xd5B702ACE1204a39202c5dd14795d9D15e7Fb797",
      "0x681bdf7830707227ca404Ff43A792062bd551B83",
    ],
    {
      initializer: "initialize",
      kind: "uups",
    }
  );

  await huukProfitEstimator.deployed();
  console.log("huukExchange deployed to:", huukProfitEstimator.address);
  return huukProfitEstimator.address;
}

main()
  .then((add) => {
    fse.outputFileSync("address/profitEstimator", add);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
