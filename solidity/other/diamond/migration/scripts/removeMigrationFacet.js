import hre, { ethers } from "hardhat";
import { FacetCutAction, getSelectors } from "../../scripts/libraries/diamond";

const fse = require("fs-extra");
const { DIAMOND } = process.env;

export const removeMigrationFacet = async () => {
  const accounts = await ethers.getSigners();
  const diamondAddress = DIAMOND ?? fse.readFileSync("./address/diamond", "utf8");
  const diamondCutFacet = await ethers.getContractAt("DiamondCutFacet", diamondAddress);
  const migrationFacet = await ethers.getContractAt("MigrationFacet", diamondAddress);
  const selectors = getSelectors(migrationFacet);
  const tx2 = await diamondCutFacet.diamondCut(
    [
      {
        facetAddress: ethers.constants.AddressZero,
        action: FacetCutAction.Remove,
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
};
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  removeMigrationFacet()
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
