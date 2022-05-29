// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

library LibStruct {
    struct Migrate {
        uint256 totalOrders;
        uint256 totalBids;
        address huuk;
        address referralContract;
        address huukExchangeContract;
        address profitSender;
        uint256 xUser;
        uint256 xCreator;
        uint256 yRefRate;
        uint256 zProfitToCreator;
        uint256 discountForBuyer;
        uint256 discountForHuuk;
        uint256 xPremium;

//        mapping(uint256 => bool) executed;
//        mapping(uint256 => Order) orders;
//        mapping(bytes32 => uint256) orderID;
//        mapping(uint256 => Bid) bids;
//        mapping(address => mapping(bytes32 => uint256)) lastBuyPriceInUSDT;
//        mapping(address => mapping(uint256 => uint256)) amountFirstSale;

//        mapping(address => bool) paymentMethod;
//        mapping(address => bool) isHuukNFTs;
//        mapping(address => bool) isOperator;
//        mapping(address => bool) isHuukNFTPremiums;
    }

    struct Order {
        address owner;
        address paymentToken;
        address tokenAddress;
        uint256 tokenId;
        uint256 quantity;
        uint256 price; // price of 1 NFT in paymentToken
        bool isOnSale; // true: on sale, false: cancel
        bool isERC721;
    }
    //    struct CreateBidInput {
    //        address _tokenAddress;
    //        address _paymentToken; // payment method
    //        address _bidder;
    //        uint256 _tokenId;
    //        uint256 _quantity; // total amount for sale
    //        uint256 _price; // price of 1 nft
    //        uint256 _expTime;
    //    }

    struct Token {
        address owner;
        address token;
        uint256 id;
        string uri;
        uint256 initialSupply;
        uint256 maxSupply;
        uint256 royaltyFee;
        uint256 nonce;
        bool isERC721;
        bytes signature;
    }

    struct LazyOrder {
        Token token; // [new Token] token.id = 0
        uint256 id;
        uint256 quantity;
        uint256 price;
        address paymentToken;
        address representative;
        uint256 nonce;
        bytes signature; // [Old Token] token.id + paymentToken + ... + (token.signature = "")
        // [New Token] (token.id = 0) + paymentToken + ... + token.signature
    }

    struct LazyBid {
        LazyOrder lazyOrder;
        uint256 id;
        address bidder;
        uint256 quantity;
        uint256 price;
        address paymentToken;
        uint256 expTime;
        bytes signature;
    }

    struct LazyAcceptBid {
        LazyBid lazyBid;
        uint256 nonce;
        uint256 quantity;
        bytes signature;
    }

    struct Bid {
        address bidder;
        address paymentToken;
        uint256 orderId;
        //        address tokenAddress;
        uint256 bidPrice;
        uint256 quantity;
        uint256 expTime;
        bool status; // 1: available | 2: done | 3: reject
    }

    struct AcceptBid {
        uint256 bidId; // not used in sign
        uint256 nonce;
        uint256 price;
        address paymentToken;
        uint256 tokenId; // = 0
        address tokenAddress;
        bytes tokenSignature; // use when bidId = 0, not check when bidId != 0
        uint256 quantity;
        bytes signature;
    }
}
