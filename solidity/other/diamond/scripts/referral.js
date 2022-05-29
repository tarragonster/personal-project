// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const fse = require("fs-extra");

async function main() {
  const HuukReferral = await hre.ethers.getContractFactory("HuukReferral");
  const huukReferral = await hre.upgrades.deployProxy(
    HuukReferral,
    [],
    { initializer: "initialize", kind: "uups" }
  );
  await huukReferral.deployed();
  console.log("HuukReferral deployed to:", huukReferral.address);
  return huukReferral.address;
}
main()
  .then((add) => {
    fse.outputFileSync("address/referral", add);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
