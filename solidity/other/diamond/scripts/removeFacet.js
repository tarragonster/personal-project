/* global ethers */
/* eslint prefer-const: "off" */

import { ERC1155HolderFacet } from "../typechain";
import hre, { ethers } from "hardhat";

const { getSelectors, FacetCutAction } = require("./libraries/diamond.js");
const fse = require("fs-extra");
const { OLD_MARKET_FACET, DIAMOND_FACET } = process.env;

export const removeFacet = async () => {
  const diamondAddress = DIAMOND_FACET ?? fse.readFileSync("./address/diamond", "utf8");

  const marketFacetAddress = OLD_MARKET_FACET ?? fse.readFileSync("./address/market", "utf8");

  console.log({
    marketFacetAddress,
    diamondAddress,
  });
  const diamondCutFacet = await hre.ethers.getContractAt("DiamondCutFacet", diamondAddress);
  const marketFacet = await hre.ethers.getContractAt("HuukMarketFacet", marketFacetAddress);
  const selectors1 = getSelectors(marketFacet);
  const tx1 = await diamondCutFacet.diamondCut(
    [
      {
        facetAddress: ethers.constants.AddressZero,
        action: FacetCutAction.Remove,
        functionSelectors: selectors1,
      },
    ],
    hre.ethers.constants.AddressZero,
    "0x",
    { gasLimit: 800000 }
  );
  const receipt1 = await tx1.wait();
  if (!receipt1.status) {
    throw Error(`Diamond upgrade failed: ${tx1.hash}`);
  }
};

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  removeFacet()
    // eslint-disable-next-line no-process-exit
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      // eslint-disable-next-line no-process-exit
      process.exit(1);
    });
}
