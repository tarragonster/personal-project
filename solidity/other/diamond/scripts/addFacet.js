import { ERC1155HolderFacet } from "../typechain";
import hre, { ethers } from "hardhat";

const { getSelectors, FacetCutAction } = require("./libraries/diamond.js");
const fse = require("fs-extra");
const { ERC_721_HOLDER_FACET, ERC_1155_HOLDER_FACET, MARKET_FACET, DIAMOND_FACET } = process.env;

export const addFacet = async () => {
  const diamondAddress = DIAMOND_FACET ?? fse.readFileSync("./address/diamond", "utf8");

  const erc1155HolderFacetAddress = ERC_1155_HOLDER_FACET ?? fse.readFileSync("./address/erc1155HolderFacet", "utf8");

  const erc721HolderFacetAddress = ERC_721_HOLDER_FACET ?? fse.readFileSync("./address/erc721HolderFacet", "utf8");

  const marketFacetAddress = MARKET_FACET ?? fse.readFileSync("./address/market", "utf8");

  console.log({
    marketFacetAddress,
    erc1155HolderFacetAddress,
    erc721HolderFacetAddress,
    diamondAddress,
  });
  const diamondCutFacet = await hre.ethers.getContractAt("DiamondCutFacet", diamondAddress);
  const erc1155HolderFacet = await hre.ethers.getContractAt("ERC1155HolderFacet", erc1155HolderFacetAddress);
  const erc721HolderFacet = await hre.ethers.getContractAt("ERC721HolderFacet", erc721HolderFacetAddress);
  const marketFacet = await hre.ethers.getContractAt("HuukMarketFacet", marketFacetAddress);
  let selectors1 = getSelectors(erc1155HolderFacet);
  let tx1 = await diamondCutFacet.diamondCut(
    [
      {
        facetAddress: erc1155HolderFacet.address,
        action: FacetCutAction.Add,
        functionSelectors: selectors1,
      },
    ],
    hre.ethers.constants.AddressZero,
    "0x",
    { gasLimit: 800000 }
  );
  let receipt1 = await tx1.wait();
  if (!receipt1.status) {
    throw Error(`Diamond upgrade failed: ${tx1.hash}`);
  }
  selectors1 = getSelectors(erc721HolderFacet);
  tx1 = await diamondCutFacet.diamondCut(
    [
      {
        facetAddress: erc721HolderFacet.address,
        action: FacetCutAction.Add,
        functionSelectors: selectors1,
      },
    ],
    hre.ethers.constants.AddressZero,
    "0x",
    { gasLimit: 800000 }
  );
  receipt1 = await tx1.wait();
  if (!receipt1.status) {
    throw Error(`Diamond upgrade failed: ${tx1.hash}`);
  }
  selectors1 = getSelectors(marketFacet);
  tx1 = await diamondCutFacet.diamondCut(
    [
      {
        facetAddress: marketFacet.address,
        action: FacetCutAction.Add,
        functionSelectors: selectors1,
      },
    ],
    hre.ethers.constants.AddressZero,
    "0x",
    { gasLimit: 800000 }
  );
  receipt1 = await tx1.wait();
  if (!receipt1.status) {
    throw Error(`Diamond upgrade failed: ${tx1.hash}`);
  }
};

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  addFacet()
    // eslint-disable-next-line no-process-exit
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      // eslint-disable-next-line no-process-exit
      process.exit(1);
    });
}
