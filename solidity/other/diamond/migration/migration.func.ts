import { ethers, upgrades } from "hardhat";
import { SetupContracts } from "./helper";
import { Order1155Type } from "./types";
import * as chai from "chai";
import chaiAsPromised from "chai-as-promised";
import { expect } from "chai";
import { HuukMarketNew } from "../typechain";
import * as diamondHelper from "../test/helper";
import { FacetCutAction, getSelectors } from "../scripts/libraries/diamond";

chai.use(chaiAsPromised);

export const TestMigration = async (input: { buyAmount: number; supply: number; orderAmount: number }) => {
  const accounts = await ethers.getSigners();
  const contracts: any = await TestSingleBuyLazyMint1155(input);
  const diamondContracts: any = await diamondHelper.SetupContracts();
  const HuukMarketNew = await ethers.getContractFactory("HuukMarketNew");
  const huukMarketNew: HuukMarketNew = (await upgrades.upgradeProxy(contracts.marketContract.address, HuukMarketNew)) as any;
  await huukMarketNew.deployed();
  console.log("HuukMarketOld deployed to:", contracts.marketContract.address);
  console.log("HuukMarketNew deployed to:", huukMarketNew.address);

  console.log("~~~~~~~~~~~~~Test Withdraw~~~~~~~~~~~~~~~~");

  const t = await huukMarketNew.balance(ethers.constants.AddressZero);
  console.log("Contract's Balance of Native Token: ", t);
  const tx = await huukMarketNew.balance(contracts.erc20Contract.address);
  console.log("Contract's Balance of ERC ", contracts.erc20Contract.address, " ", tx);
  let tx1 = await huukMarketNew.withdrawFunds(accounts[0].address, ethers.constants.AddressZero, { gasLimit: 800000 });
  await tx1.wait();
  expect(await huukMarketNew.balance(ethers.constants.AddressZero)).to.equal(0);
  console.log("Native token: Success");
  tx1 = await huukMarketNew.withdrawFunds(accounts[0].address, contracts.erc20Contract.address, { gasLimit: 800000 });
  await tx1.wait();
  expect(await huukMarketNew.balance(contracts.erc20Contract.address)).to.equal(0);
  console.log(contracts.erc20Contract.address, ": Success");
  console.log("~~~~~~~~~~~~~Test Transfer NFTs~~~~~~~~~~~~~~~~");
  const amount = await contracts.custom1155Contract.balanceOf(contracts.marketContract.address, 1);
  console.log("Old contract: ", amount);
  console.log("New contract: ", await contracts.custom1155Contract.balanceOf(diamondContracts.marketContract.address, 1));

  tx1 = await huukMarketNew.transferNFTs(diamondContracts.marketContract.address, { gasLimit: 800000 });
  await tx1.wait();
  console.log("Old contract: ", await contracts.custom1155Contract.balanceOf(contracts.marketContract.address, 1));
  expect(await contracts.custom1155Contract.balanceOf(contracts.marketContract.address, 1)).to.equal(0);
  console.log("New contract: ", await contracts.custom1155Contract.balanceOf(diamondContracts.marketContract.address, 1));
  expect(await contracts.custom1155Contract.balanceOf(diamondContracts.marketContract.address, 1)).to.equal(amount);
  console.log("~~~~~~~~~~~~~Test Transfer Data~~~~~~~~~~~~~~~~");
  const diamondCutFacet = await ethers.getContractAt("DiamondCutFacet", diamondContracts.marketContract.address);
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
  tx1 = await huukMarketNew.transferData(diamondContracts.marketContract.address, { gasLimit: 800000 });
  await tx1.wait();
  expect((await huukMarketNew.orders(0)).quantity).to.equal((await diamondContracts.marketContract.orders(1)).quantity);
};

export const TestSingleBuyLazyMint1155 = async (input: { buyAmount: number; supply: number; orderAmount: number }) => {
  const accounts = await ethers.getSigners();
  const contracts = await SetupContracts();
  const value = {
    owner: accounts[1].address,
    maxSupply: input.supply,
    initialSupply: input.supply,
    royaltyFee: 500,
    uri: "URI",
    nonce: 1,
  };

  const sign = await accounts[1]._signTypedData(contracts.contract1155Domain, Order1155Type, { ...value, data: [] });

  const order = {
    token: {
      token: contracts.custom1155Contract.address,
      id: 0,
      isERC721: false,
      ...value,
    },
    paymentToken: contracts.erc20Contract.address,
    price: 100,
    amount: input.orderAmount,
  };
  const ap = await contracts.erc20Contract.approve(contracts.marketContract.address, ethers.utils.parseEther("10000"));
  await ap.wait();

  if (input.buyAmount > order.amount) {
    expect(contracts.marketContract.lazyBuy(order, input.buyAmount, ethers.constants.AddressZero, sign)).to.be.rejectedWith();
    return;
  }
  const a = await contracts.marketContract.lazyBuy(order, input.buyAmount, ethers.constants.AddressZero, sign);
  await a.wait();

  const returnOrder = await contracts.marketContract.orders(0);
  expect(returnOrder.quantity).to.equal(order.amount - input.buyAmount);
  expect(await contracts.custom1155Contract.balanceOf(accounts[0].address, 1)).to.equal(input.buyAmount);
  return contracts;
};
