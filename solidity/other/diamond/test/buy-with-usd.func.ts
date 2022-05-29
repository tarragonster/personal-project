import { ethers } from "hardhat";
import { SetupContracts } from "./helper";
import { ERC1155Type, OrderType } from "./types";
import * as chai from "chai";
import chaiAsPromised from "chai-as-promised";
import { expect } from "chai";

chai.use(chaiAsPromised);

export const TestBuyWithUSD1155 = async (input: { totalAmount: number; orderQuantity: number; normalAmount: number }) => {
  const accounts = await ethers.getSigners();
  const owner = accounts[1];
  const sender = accounts[0];

  const contracts = await SetupContracts();
  const ax = await contracts.erc20Contract.approve(contracts.marketContract.address, ethers.utils.parseEther("10000"));
  await ax.wait();
  const ab = await contracts.operationFacet.whiteListOperator(sender.address, true);
  await ab.wait();
  const baseTokenValue = {
    owner: accounts[1].address,
    maxSupply: input.totalAmount,
    initialSupply: input.totalAmount,
    royaltyFee: 500,
    uri: "URI",
    data: [],
    nonce: 1,
  };
  const tokenSignature = await owner._signTypedData(contracts.contract1155Domain, ERC1155Type, baseTokenValue);

  const baseOrderValue = {
    quantity: input.orderQuantity,
    price: 100,
    paymentToken: contracts.erc20Contract.address,
    representative: sender.address,
    nonce: 1,
  };
  const token = {
    token: contracts.custom1155Contract.address,
    id: 0,
    isERC721: false,
    ...baseTokenValue,
    signature: tokenSignature,
  };
  const orderSignature = await owner._signTypedData(contracts.contractMarketDomain, OrderType, {
    tokenId: token.id,
    ...baseOrderValue,
    tokenSignature: tokenSignature,
  });

  const order = {
    id: 0,
    token: token,
    ...baseOrderValue,
    signature: orderSignature,
  };
  const a = await contracts.marketContract.lazyBuy(order, input.orderQuantity, accounts[3].address);
  await a.wait();

  const returnOrder = await contracts.marketContract.orders(0);

  expect(returnOrder.quantity).to.equal(order.quantity - input.orderQuantity);

  expect(await contracts.custom1155Contract.balanceOf(accounts[3].address, 1)).to.equal(input.orderQuantity);
};
export const TestBuy2TimeWithUSD1155 = async (input: { totalAmount: number; orderQuantity: number; normalAmount: number }) => {
  const accounts = await ethers.getSigners();
  const owner = accounts[1];
  const sender = accounts[0];

  const contracts = await SetupContracts();
  const ax = await contracts.erc20Contract.approve(contracts.marketContract.address, ethers.utils.parseEther("10000"));
  await ax.wait();
  const ab = await contracts.operationFacet.whiteListOperator(sender.address, true);
  await ab.wait();
  const baseTokenValue = {
    owner: accounts[1].address,
    maxSupply: input.totalAmount,
    initialSupply: input.totalAmount,
    royaltyFee: 500,
    uri: "URI",
    data: [],
    nonce: 1,
  };
  const tokenSignature = await owner._signTypedData(contracts.contract1155Domain, ERC1155Type, baseTokenValue);

  const baseOrderValue = {
    quantity: input.orderQuantity,
    price: 100,
    paymentToken: contracts.erc20Contract.address,
    representative: sender.address,
    nonce: 1,
  };
  const token = {
    token: contracts.custom1155Contract.address,
    id: 0,
    isERC721: false,
    ...baseTokenValue,
    signature: tokenSignature,
  };
  const orderSignature = await owner._signTypedData(contracts.contractMarketDomain, OrderType, {
    tokenId: token.id,
    ...baseOrderValue,
    tokenSignature: tokenSignature,
  });

  const order = {
    id: 0,
    token: token,
    ...baseOrderValue,
    signature: orderSignature,
  };
  const a = await contracts.marketContract.lazyBuy(order, input.orderQuantity, accounts[3].address);
  await a.wait();

  const returnOrder = await contracts.marketContract.orders(0);

  expect(returnOrder.quantity).to.equal(order.quantity - input.orderQuantity);

  expect(await contracts.custom1155Contract.balanceOf(accounts[3].address, 1)).to.equal(input.orderQuantity);
  const t = await contracts.marketContract.connect(accounts[1]);
  expect(t.buy(0, 1, contracts.erc20Contract.address, accounts[3].address)).to.be.rejectedWith("Operator");
  // const b = await contracts.marketContract.buy(
  //   0,
  //   1,
  //   contracts.erc20Contract.address,
  //   accounts[3].address
  // );
  // await b.wait();
};

export const TestNotAuthorizedBuyWithUSD1155 = async (input: { totalAmount: number; orderQuantity: number; normalAmount: number }) => {
  const accounts = await ethers.getSigners();
  const owner = accounts[1];
  const sender = accounts[0];

  const contracts = await SetupContracts();
  const ax = await contracts.erc20Contract.approve(contracts.marketContract.address, ethers.utils.parseEther("10000"));
  await ax.wait();
  const ab = await contracts.operationFacet.whiteListOperator(sender.address, true);
  await ab.wait();
  const baseTokenValue = {
    owner: accounts[4].address,
    maxSupply: input.totalAmount,
    initialSupply: input.totalAmount,
    royaltyFee: 500,
    uri: "URI",
    data: [],
    nonce: 1,
  };
  const tokenSignature = await owner._signTypedData(contracts.contract1155Domain, ERC1155Type, baseTokenValue);

  const baseOrderValue = {
    quantity: input.orderQuantity,
    price: 100,
    paymentToken: contracts.erc20Contract.address,
    representative: sender.address,
    nonce: 1,
  };
  const token = {
    token: contracts.custom1155Contract.address,
    id: 0,
    isERC721: false,
    ...baseTokenValue,
    signature: tokenSignature,
  };
  const orderSignature = await owner._signTypedData(contracts.contractMarketDomain, OrderType, {
    tokenId: token.id,
    ...baseOrderValue,
    tokenSignature: tokenSignature,
  });

  const order = {
    id: 0,
    token: token,
    ...baseOrderValue,
    signature: orderSignature,
  };
  const t = await contracts.marketContract.connect(accounts[1]);
  expect(t.lazyBuy(order, input.orderQuantity, accounts[3].address)).to.be.rejectedWith("Operator");
};
