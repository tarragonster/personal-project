import hre, { ethers } from "hardhat";
import { FacetCutAction, getSelectors } from "../../scripts/libraries/diamond";

const fse = require("fs-extra");
const { MARKET, DIAMOND } = process.env;

export const transferData = async () => {
  const accounts = await ethers.getSigners();
  const marketAddress = MARKET ?? fse.readFileSync("./address/market", "utf8");
  const diamondAddress = DIAMOND ?? fse.readFileSync("./address/diamond", "utf8");
  const newMarket = await hre.ethers.getContractAt("HuukMarketNew", marketAddress);
  const diamondCutFacet = await ethers.getContractAt("DiamondCutFacet", diamondAddress);
  const MigrationFacet = await ethers.getContractFactory("MigrationFacet");
  const migrationFacet = await MigrationFacet.deploy();
  await migrationFacet.deployed();
  const selectors = getSelectors(migrationFacet);
  const tx2 = await diamondCutFacet.diamondCut(
    [
      {
        facetAddress: migrationFacet.address,
        action: FacetCutAction.Add,
        functionSelectors: selectors,
      },
    ],
    ethers.constants.AddressZero,
    "0x",
    { gasLimit: 800000 }
  );
  const receipt = await tx2.wait();
  if (!receipt.status) {
    throw Error(`Diamond upgrade failed: ${tx2.hash}`);
  }
  const tx1 = await newMarket.transferData(diamondAddress, { gasLimit: 800000 });
  await tx1.wait();
};
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  transferData()
    .then((add) => {
      // fse.outputFileSync("address/market", add);
    })
    // eslint-disable-next-line no-process-exit
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      // eslint-disable-next-line no-process-exit
      process.exit(1);
    });
}
