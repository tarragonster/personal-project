// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const fse = require("fs-extra");

async function main() {
  const Huuk721General = await hre.ethers.getContractFactory("Huuk721General");
  const huuk721General = await hre.upgrades.deployProxy(
    Huuk721General,
    ["Huuk721", "Huuk721", "v1", "https://api.huuk.market"],
    { initializer: "initialize", kind: "uups" }
  );
  await huuk721General.deployed();
  console.log("Huuk721General deployed to:", huuk721General.address);
  return huuk721General.address;
}
main()
  .then((add) => {
    fse.outputFileSync("address/huuk721", add);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
