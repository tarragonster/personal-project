/* global ethers */
/* eslint prefer-const: "off" */

import { ERC1155HolderFacet } from "../typechain";
import hre, { ethers } from "hardhat";

const { getSelectors, FacetCutAction } = require("./libraries/diamond.js");
const fse = require("fs-extra");
const { HUUK_721, HUUK_721_PREMIUM, HUUK_1155, HUUK_1155_PREMIUM, DIAMOND_FACET } = process.env;

export const setProxy = async () => {
  const diamondAddress = DIAMOND_FACET ?? fse.readFileSync("./address/diamond", "utf8");

  const huuk721Address = HUUK_721 ?? fse.readFileSync("./address/huuk721", "utf8");

  const huuk721PremiumAddress = HUUK_721_PREMIUM ?? fse.readFileSync("./address/huuk721Premium", "utf8");

  const huuk1155Address = HUUK_1155 ?? fse.readFileSync("./address/huuk1155", "utf8");

  const huuk1155PremiumAddress = HUUK_1155_PREMIUM ?? fse.readFileSync("./address/huuk1155Premium", "utf8");

  console.log({
    huuk721Address,
    huuk721PremiumAddress,
    huuk1155Address,
    huuk1155PremiumAddress,
    diamondAddress,
  });
  const huuk1155 = await hre.ethers.getContractAt("Huuk1155General", huuk1155Address);
  const huuk1155Premium = await hre.ethers.getContractAt("Huuk1155Premium", huuk1155PremiumAddress);
  const huuk721 = await hre.ethers.getContractAt("Huuk721General", huuk721Address);
  const huuk721Premium = await hre.ethers.getContractAt("Huuk721Premium", huuk721PremiumAddress);

  let tx1 = await huuk1155.setProxyAddress(diamondAddress);
  let receipt1 = await tx1.wait();
  if (!receipt1.status) {
    throw Error(`huuk1155 SetProxyAddress failed: ${tx1.hash}`);
  }
  tx1 = await huuk1155Premium.setProxyAddress(diamondAddress);
  receipt1 = await tx1.wait();
  if (!receipt1.status) {
    throw Error(`huuk1155Premium SetProxyAddress failed: ${tx1.hash}`);
  }
  tx1 = await huuk721.setProxyAddress(diamondAddress);
  receipt1 = await tx1.wait();
  if (!receipt1.status) {
    throw Error(`huuk721 SetProxyAddress failed: ${tx1.hash}`);
  }
  tx1 = await huuk721Premium.setProxyAddress(diamondAddress);
  receipt1 = await tx1.wait();
  if (!receipt1.status) {
    throw Error(`huuk721Premium SetProxyAddress failed: ${tx1.hash}`);
  }
};

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  setProxy()
    // eslint-disable-next-line no-process-exit
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      // eslint-disable-next-line no-process-exit
      process.exit(1);
    });
}
