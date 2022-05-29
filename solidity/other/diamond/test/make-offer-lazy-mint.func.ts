import { ethers } from "hardhat";
import { SetupContracts } from "./helper";
import { AcceptBidType, BidType, ERC1155Type, ERC721Type, OrderType } from "./types";
import * as chai from "chai";
import chaiAsPromised from "chai-as-promised";
import { expect } from "chai";

chai.use(chaiAsPromised);
export const MaxUnixTimeStamp = 2147483647;
export const TestSingleMakeOfferLazyMint1155 = async (input: { supply: number; orderQuantity: number; offerPrice: number; offerQuantity: number; acceptQuantity: number }) => {
  const accounts = await ethers.getSigners();
  const contracts = await SetupContracts();
  const ax = await contracts.erc20Contract.approve(contracts.marketContract.address, ethers.utils.parseEther("10000"));
  await ax.wait();
  const owner = accounts[1];
  const sender = accounts[0];

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

  const baseBidValue = {
    quantity: input.offerQuantity,
    price: input.offerPrice,
    expTime: MaxUnixTimeStamp,
    paymentToken: contracts.erc20Contract.address,
    bidder: sender.address,
  };

  const bidSignature = await sender._signTypedData(contracts.contractMarketDomain, BidType, {
    orderId: order.id,
    ...baseBidValue,
    orderSignature: orderSignature,
  });

  const lazyBid = {
    id: 0,
    lazyOrder: order,
    ...baseBidValue,
    signature: bidSignature,
  };

  const baseAcceptBidValue = {
    quantity: input.acceptQuantity,
    nonce: 1,
  };

  const acceptBidSignature = await owner._signTypedData(contracts.contractMarketDomain, AcceptBidType, {
    bidId: lazyBid.id,
    ...baseAcceptBidValue,
    bidSignature: bidSignature,
  });

  const lazyAcceptBid = {
    lazyBid: lazyBid,
    ...baseAcceptBidValue,
    signature: acceptBidSignature,
  };

  if (input.offerQuantity > order.quantity) {
    expect(contracts.marketContract.lazyAcceptBid(lazyAcceptBid)).to.be.rejectedWith();
    return;
  }
  const a = await contracts.marketContract.lazyAcceptBid(lazyAcceptBid);
  await a.wait();

  const returnOrder = await contracts.marketContract.orders(1);
  expect(returnOrder.quantity).to.equal(input.orderQuantity - input.acceptQuantity);

  expect(await contracts.custom1155Contract.balanceOf(owner.address, 1)).to.equal(input.supply - input.orderQuantity);
  return contracts;
};

// eslint-disable-next-line camelcase
export const TestMultipleAccept_MakeOfferLazyMint1155 = async (input: {
  supply: number;
  orderQuantity: number;
  offerPrice: number;
  offerQuantity: number;
  acceptQuantity: number[];
}) => {
  const accounts = await ethers.getSigners();
  const owner = accounts[1];
  // const sender = accounts[0];
  const contracts: any = await TestSingleMakeOfferLazyMint1155({
    supply: input.supply,
    orderQuantity: input.orderQuantity,
    offerPrice: input.offerPrice,
    offerQuantity: input.offerQuantity,
    acceptQuantity: input.acceptQuantity[0],
  });

  const acceptBid = {
    lazyBid: {
      id: 0,
      lazyOrder: {
        id: 0,
        token: {
          token: "0xa85233C63b9Ee964Add6F2cffe00Fd84eb32338f",
          id: 0,
          isERC721: false,
          owner: "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
          maxSupply: 100,
          initialSupply: 100,
          royaltyFee: 500,
          uri: "URI",
          data: [],
          nonce: 1,
          signature: "0x6b3b882403031cb2a1f429c2df708a9c7bbf2ac333a4731dfca4e4d7b035f58d141b72f695fdf20d81c36819502c7307cbe81b45f6204437dfebfc459eedfc181c",
        },
        quantity: 20,
        price: 100,
        paymentToken: "0xc3e53F4d16Ae77Db1c982e75a937B9f60FE63690",
        representative: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
        nonce: 1,
        signature: "0x0010630ec6bdd2fac18ea8f3e00c33031cb5411c6a48d8f544eef209a52d53440daf4524fb25051c4275bd499c4307d9e0702fd33ca0c29426f56fbab22fc3f21b",
      },
      quantity: 10,
      price: 20,
      expTime: 2147483647,
      paymentToken: "0xc3e53F4d16Ae77Db1c982e75a937B9f60FE63690",
      bidder: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
      signature: "0xfc4f072d2a97385876914694d7543db0f757ab9c3cee508531710091bfd810c852dedd6283b48e707cbce3d1aaa8d6784d592696deb3cf776644a21f3aa3f7f41c",
    },
    quantity: 10,
    nonce: 1,
    signature: "0x2ec43ab49a586d9470107a63c9d11eafba0ced3e447c918c907597af442aebcb40d0365eec300289a9b2eb0ef39951e4a05f784083b395d3d2f1eb01ab25eab41c",
  };

  acceptBid.lazyBid.id = 1;

  const baseAcceptBidValue = {
    quantity: input.acceptQuantity[1],
    nonce: 2,
  };

  const acceptBidSignature = await owner._signTypedData(contracts.contractMarketDomain, AcceptBidType, {
    bidId: acceptBid.lazyBid.id,
    ...baseAcceptBidValue,
    bidSignature: acceptBid.lazyBid.signature,
  });
  const lazyAcceptBid = {
    lazyBid: acceptBid.lazyBid,
    ...baseAcceptBidValue,
    signature: acceptBidSignature,
  };
  //
  // if (input.offerQuantity > order.quantity) {
  //   expect(
  //     contracts.marketContract.lazyAcceptBid(lazyAcceptBid)
  //   ).to.be.rejectedWith();
  //   return;
  // }
  const a = await contracts.marketContract.lazyAcceptBid(lazyAcceptBid);
  await a.wait();

  const returnOrder = await contracts.marketContract.orders(1);

  expect(returnOrder.quantity).to.equal(input.orderQuantity - input.acceptQuantity[1] - input.acceptQuantity[0]);
};
export const TestMakeOfferLazyMint721 = async (input: { offerPrice: number }) => {
  const accounts = await ethers.getSigners();
  const contracts = await SetupContracts();
  const ax = await contracts.erc20Contract.approve(contracts.marketContract.address, ethers.utils.parseEther("10000"));
  await ax.wait();
  const owner = accounts[1];
  const sender = accounts[0];

  const baseTokenValue = {
    owner: owner.address,
    maxSupply: 1,
    initialSupply: 1,
    royaltyFee: 500,
    uri: "URI",
    data: [],
    nonce: 1,
  };

  const tokenSignature = await owner._signTypedData(contracts.contract721Domain, ERC721Type, baseTokenValue);

  const baseOrderValue = {
    quantity: 1,
    price: 100,
    paymentToken: contracts.erc20Contract.address,
    representative: sender.address,
    nonce: 1,
  };

  const token = {
    token: contracts.custom721Contract.address,
    id: 0,
    isERC721: true,
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

  const baseBidValue = {
    quantity: 1,
    price: input.offerPrice,
    expTime: MaxUnixTimeStamp,
    paymentToken: contracts.erc20Contract.address,
    bidder: sender.address,
  };

  const bidSignature = await sender._signTypedData(contracts.contractMarketDomain, BidType, {
    orderId: order.id,
    ...baseBidValue,
    orderSignature: orderSignature,
  });

  const lazyBid = {
    id: 0,
    lazyOrder: order,
    ...baseBidValue,
    signature: bidSignature,
  };

  const baseAcceptBidValue = {
    quantity: 1,
    nonce: 1,
  };

  const acceptBidSignature = await owner._signTypedData(contracts.contractMarketDomain, AcceptBidType, {
    bidId: lazyBid.id,
    ...baseAcceptBidValue,
    bidSignature: bidSignature,
  });

  const lazyAcceptBid = {
    lazyBid: lazyBid,
    ...baseAcceptBidValue,
    signature: acceptBidSignature,
  };

  const a = await contracts.marketContract.lazyAcceptBid(lazyAcceptBid);
  await a.wait();

  const returnOrder = await contracts.marketContract.orders(1);

  expect(returnOrder.quantity).to.equal(0);

  expect(await contracts.custom721Contract.ownerOf(1)).to.equal(sender.address);
};
