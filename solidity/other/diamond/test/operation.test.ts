import { ethers } from "hardhat";
import { deployDiamond } from "../scripts/deployDiamond";
import { IDiamondCut, IDiamondLoupe, IOperation, OwnershipFacet } from "../typechain";
import chai, { expect } from "chai";
import chaiAsPromised from "chai-as-promised";
chai.use(chaiAsPromised);

describe("OperationTest", async () => {
  let diamondAddress: any;
  let diamondCutFacet: IDiamondCut;
  let diamondLoupeFacet: IDiamondLoupe;
  let ownershipFacet: OwnershipFacet;
  let operationFacet: IOperation;
  // let pausableFacet: PausableFacet;

  before(async () => {
    diamondAddress = await deployDiamond();
    diamondCutFacet = await ethers.getContractAt("DiamondCutFacet", diamondAddress);
    diamondLoupeFacet = await ethers.getContractAt("DiamondLoupeFacet", diamondAddress);
    ownershipFacet = await ethers.getContractAt("OwnershipFacet", diamondAddress);
    operationFacet = await ethers.getContractAt("OperationFacet", diamondAddress);
    // pausableFacet = await ethers.getContractAt("PausableFacet", diamondAddress);
  });

  it("should paused", async () => {
    const a = await operationFacet.pause();
    await a.wait();
    const t = await operationFacet.paused();
    expect(t).to.equal(true);
  });
  it("should prevent calling functions when paused", async () => {
    expect(operationFacet.pause()).to.be.rejectedWith();
  });
  it("should set unPaused successfully", async () => {
    const a = await operationFacet.unPause();
    await a.wait();
    const t = await operationFacet.paused();
    expect(t).to.equal(false);
  });
  // it("should work with Huuk Market functions", async () => {
  //   const HuukMarketFacet = await ethers.getContractFactory("HuukMarketFacet");
  //   const huukMarketFacet = await HuukMarketFacet.deploy();
  //   await huukMarketFacet.deployed();
  //   addresses.push(huukMarketFacet.address);
  //   const selectors = getSelectors(huukMarketFacet);
  //   tx = await diamondCutFacet.diamondCut(
  //     [
  //       {
  //         facetAddress: huukMarketFacet.address,
  //         action: FacetCutAction.Add,
  //         functionSelectors: selectors,
  //       },
  //     ],
  //     ethers.constants.AddressZero,
  //     "0x",
  //     { gasLimit: 800000 }
  //   );
  //   receipt = await tx.wait();
  //   if (!receipt.status) {
  //     throw Error(`Diamond upgrade failed: ${tx.hash}`);
  //   }
  //   result = await diamondLoupeFacet.facetFunctionSelectors(
  //     huukMarketFacet.address
  //   );
  //   assert.sameMembers(result, selectors);
  //
  //   const huukMarket = await ethers.getContractAt(
  //     "HuukMarketFacet",
  //     diamondAddress
  //   );
  //   const a = await huukMarket.setA("hello");
  //   await a.wait();
  //
  //   const t = await huukMarket.getA();
  //   expect(t).to.equal("hello");
  // });
});
