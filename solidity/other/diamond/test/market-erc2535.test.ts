import chai, { assert } from "chai";
import chaiAsPromised from "chai-as-promised";
import { ethers } from "hardhat";
import { deployDiamond } from "../scripts/deployDiamond";
import { FacetCutAction, getSelectors } from "../scripts/libraries/diamond";

chai.use(chaiAsPromised);

describe("MarketTest", async () => {
  it("adding huukMarketFacet to diamond", async () => {
    const accounts = await ethers.getSigners();

    const diamondAddress = await deployDiamond();
    const diamondCutFacet = await ethers.getContractAt("DiamondCutFacet", diamondAddress);
    const diamondLoupeFacet = await ethers.getContractAt("DiamondLoupeFacet", diamondAddress);
    const ownershipFacet = await ethers.getContractAt("OwnershipFacet", diamondAddress);
    const operationFacet = await ethers.getContractAt("OperationFacet", diamondAddress);

    const HuukMarketFacet = await ethers.getContractFactory("HuukMarketFacet");
    const marketContract = await HuukMarketFacet.deploy();
    await marketContract.deployed();
    const selectors = getSelectors(marketContract);
    const tx = await diamondCutFacet.diamondCut(
      [
        {
          facetAddress: marketContract.address,
          action: FacetCutAction.Add,
          functionSelectors: selectors,
        },
      ],
      ethers.constants.AddressZero,
      "0x",
      { gasLimit: 800000 }
    );
    const receipt = await tx.wait();
    if (!receipt.status) {
      throw Error(`Diamond upgrade failed: ${tx.hash}`);
    }
  });
});
