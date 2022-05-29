export const Order1155Type = {
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

export const AcceptOfferSignatureType = {
  Bid: [
    { name: "amount", type: "uint256" },
    { name: "price", type: "uint256" },
    { name: "nonce", type: "uint256" },
    { name: "recipient", type: "address" },
    { name: "signature", type: "bytes" },
  ],
};

export const Order721Type = {
  TokenInfo: [
    { name: "owner", type: "address" },
    { name: "uri", type: "string" },
    { name: "royaltyFee", type: "uint256" },
    { name: "nonce", type: "uint256" },
  ],
};
