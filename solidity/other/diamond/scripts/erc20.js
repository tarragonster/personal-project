// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const fse = require("fs-extra");

async function main() {
  const Contract = await hre.ethers.getContractFactory("MockERC20");
  const contract = await hre.upgrades.deployProxy(
    Contract,
    ["HuukCoin", "HC"],
    {
      kind: "uups",
    }
  );
  await contract.deployed();
  console.log("MockERC20 deployed to:", contract.address);
  return contract.address;
}

main()
  .then((add) => {
    fse.outputFileSync("address/erc20", add);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
