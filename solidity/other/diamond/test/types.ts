export const ERC1155Type = {
  TokenInfo: [
    { name: "owner", type: "address" },
    { name: "maxSupply", type: "uint256" },
    { name: "initialSupply", type: "uint256" },
    { name: "royaltyFee", type: "uint256" },
    { name: "uri", type: "string" },
    { name: "data", type: "bytes" },
    { name: "nonce", type: "uint256" },
  ],
};

export const OrderType = {
  Order: [
    { name: "tokenId", type: "uint256" },
    { name: "quantity", type: "uint256" },
    { name: "price", type: "uint256" },
    { name: "paymentToken", type: "address" },
    { name: "representative", type: "address" },
    { name: "nonce", type: "uint256" },
    { name: "tokenSignature", type: "bytes" },
  ],
};
export const BidType = {
  Bid: [
    { name: "orderId", type: "uint256" },
    { name: "quantity", type: "uint256" },
    { name: "price", type: "uint256" },
    { name: "expTime", type: "uint256" },
    { name: "paymentToken", type: "address" },
    { name: "bidder", type: "address" },
    { name: "orderSignature", type: "bytes" },
  ],
};
export const AcceptBidType = {
  AcceptBid: [
    { name: "bidId", type: "uint256" },
    { name: "quantity", type: "uint256" },
    { name: "nonce", type: "uint256" },
    { name: "bidSignature", type: "bytes" },
  ],
};

export const ERC721Type = {
  TokenInfo: [
    { name: "owner", type: "address" },
    { name: "uri", type: "string" },
    { name: "royaltyFee", type: "uint256" },
    { name: "nonce", type: "uint256" },
  ],
};
