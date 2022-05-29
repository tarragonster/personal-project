import { ethers } from "hardhat";
import { SetupContracts } from "./helper";
import { ERC1155Type, ERC721Type, OrderType } from "./types";
import * as chai from "chai";
import chaiAsPromised from "chai-as-promised";
import { expect } from "chai";

chai.use(chaiAsPromised);

export const TestSingleBuyLazyMint1155 = async (input: { buyAmount: number; supply: number; orderQuantity: number }) => {
  const accounts = await ethers.getSigners();
  const owner = accounts[1];
  const sender = accounts[0];

  const contracts = await SetupContracts();
  const ax = await contracts.erc20Contract.approve(contracts.marketContract.address, ethers.utils.parseEther("10000"));
  await ax.wait();

  const baseTokenValue = {
    owner: owner.address,
    maxSupply: input.supply,
    initialSupply: input.supply,
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
  if (input.buyAmount > order.quantity) {
    expect(contracts.marketContract.lazyBuy(order, input.buyAmount, ethers.constants.AddressZero)).to.be.rejectedWith();
    return;
  }
  const a = await contracts.marketContract.lazyBuy(order, input.buyAmount, ethers.constants.AddressZero);
  await a.wait();

  const returnOrder = await contracts.marketContract.orders(1);

  expect(returnOrder.quantity).to.equal(order.quantity - input.buyAmount);

  expect(await contracts.custom1155Contract.balanceOf(sender.address, 1)).to.equal(input.buyAmount);
};
export const TestMultipleLazyMint1155 = async (input: { buyAmount: number[]; supply: number; orderQuantity: number }) => {
  const accounts = await ethers.getSigners();
  const owner = accounts[1];
  const sender = accounts[0];
  const contracts = await SetupContracts();
  const ax = await contracts.erc20Contract.approve(contracts.marketContract.address, ethers.utils.parseEther("10000"));
  await ax.wait();
  const baseTokenValue = {
    owner: owner.address,
    maxSupply: input.supply,
    initialSupply: input.supply,
    royaltyFee: 500,
    uri: "URI",
    data: [],
    nonce: 1,
  };

  const tokenSignature = await owner._signTypedData(contracts.contract1155Domain, ERC1155Type, baseTokenValue);

  const baseOrderValue = {
    price: 100,
    quantity: input.orderQuantity,
    paymentToken: contracts.erc20Contract.address,
    representative: sender.address,
    nonce: 1,
  };

  const orderSignature = await owner._signTypedData(contracts.contractMarketDomain, OrderType, {
    ...baseOrderValue,
    tokenId: 0,
    tokenSignature: tokenSignature,
  });

  const order = {
    id: 0,
    token: {
      token: contracts.custom1155Contract.address,
      id: 0,
      isERC721: false,
      ...baseTokenValue,
      signature: tokenSignature,
    },
    ...baseOrderValue,
    signature: orderSignature,
  };

  let left = order.quantity;
  for (let i = 0; i < input.buyAmount.length; i++) {
    const amount = input.buyAmount[i];
    let a;
    if (i === 0) {
      if (amount > left) {
        expect(contracts.marketContract.lazyBuy(order, amount, ethers.constants.AddressZero)).to.be.rejectedWith();
        return contracts;
      }
      a = await contracts.marketContract.lazyBuy(order, amount, ethers.constants.AddressZero);
    } else {
      if (amount > left) {
        expect(contracts.marketContract.buy(1, amount, contracts.erc20Contract.address, ethers.constants.AddressZero)).to.be.rejectedWith();
        return contracts;
      }
      a = await contracts.marketContract.buy(1, amount, contracts.erc20Contract.address, ethers.constants.AddressZero);
    }
    await a.wait();
    left -= amount;
  }

  const returnOrder = await contracts.marketContract.orders(1);

  expect(returnOrder.quantity).to.equal(left);

  expect(await contracts.custom1155Contract.balanceOf(sender.address, 1)).to.equal(order.quantity - left);
  return contracts;
};

export const TestMultiOrderInLazyMint1155 = async (input: { buyAmount: number[][]; supply: number; orderQuantity: number[] }) => {
  const contracts = await TestMultipleLazyMint1155({
    buyAmount: input.buyAmount[0],
    supply: input.supply,
    orderQuantity: input.orderQuantity[0],
  });
  return contracts;
};

export const TestLazyMint721 = async (input: {}) => {
  const accounts = await ethers.getSigners();
  const contracts = await SetupContracts();
  const ax = await contracts.erc20Contract.approve(contracts.marketContract.address, ethers.utils.parseEther("10000"));
  await ax.wait();
  const owner = accounts[1];
  const sender = accounts[0];

  const baseTokenValue = {
    owner: owner.address,
    royaltyFee: 500,
    uri: "URI",
    nonce: 1,
  };

  const tokenSignature = await owner._signTypedData(contracts.contract721Domain, ERC721Type, baseTokenValue);

  const baseOrderValue = {
    price: 100,
    quantity: 1,
    paymentToken: contracts.erc20Contract.address,
    representative: sender.address,
    nonce: 1,
  };

  const orderSignature = await owner._signTypedData(contracts.contractMarketDomain, OrderType, {
    ...baseOrderValue,
    tokenId: 0,
    tokenSignature: tokenSignature,
  });

  const order = {
    id: 0,
    token: {
      token: contracts.custom721Contract.address,
      id: 0,
      isERC721: true,
      initialSupply: 1,
      maxSupply: 1,
      ...baseTokenValue,
      signature: tokenSignature,
    },
    ...baseOrderValue,
    signature: orderSignature,
  };

  const a = await contracts.marketContract.lazyBuy(order, 1, ethers.constants.AddressZero);
  await a.wait();

  // expect(await contracts.custom721Contract.ownerOf(1)).to.equal(sender.address);
};
