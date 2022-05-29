// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const fse = require("fs-extra");

async function main() {
  const Huuk721Premium = await hre.ethers.getContractFactory("Huuk721Premium");
  const huuk721Premium = await hre.upgrades.deployProxy(
    Huuk721Premium,
    ["Huuk721 Premium", "Huuk721 Premium", "v1", "https://api.huuk.market"],
    { initializer: "initialize", kind: "uups" }
  );

  await huuk721Premium.deployed();
  return huuk721Premium.address;
}
main()
  .then((add) => {
    fse.outputFileSync("address/huuk721Premium", add);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
