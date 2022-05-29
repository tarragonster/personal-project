// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./LibStruct.sol";

library LibSign {
    bytes32 public constant ORDER_HASH =
        keccak256(
            "Order(uint256 tokenId,uint256 quantity,uint256 price,address paymentToken,address representative,uint256 nonce,bytes tokenSignature)"
        );

    function getOrderHash(LibStruct.LazyOrder memory _order)
        internal
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encode(
                    ORDER_HASH,
                    _order.token.id,
                    _order.quantity,
                    _order.price,
                    _order.paymentToken,
                    _order.representative,
                    _order.nonce,
                    keccak256(_order.token.signature)
                )
            );
    }

    //
    //    function newBid(LibStruct.CreateBidInput memory _input)
    //    public
    //    pure
    //    returns (LibStruct.Bid memory)
    //    {
    //        return
    //        LibStruct.Bid({
    //        bidder: _input._bidder,
    //        bidPrice: _input._price,
    //        quantity: _input._quantity,
    //        tokenId: _input._tokenId,
    //        tokenAddress: _input._tokenAddress,
    //        status: true,
    //        expTime: _input._expTime,
    //        paymentToken: address(0)
    //        });
    //    }

    bytes32 public constant BID_HASH =
        keccak256(
            "Bid(uint256 orderId,uint256 quantity,uint256 price,uint256 expTime,address paymentToken,address bidder,bytes orderSignature)"
        );

    function getBidHash(LibStruct.LazyBid memory _bid)
        internal
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encode(
                    BID_HASH,
                    _bid.lazyOrder.id,
                    _bid.quantity,
                    _bid.price,
                    _bid.expTime,
                    _bid.paymentToken,
                    _bid.bidder,
                    keccak256(_bid.lazyOrder.signature)
                )
            );
    }

    bytes32 public constant ACCEPT_BID_HASH =
        keccak256(
            "AcceptBid(uint256 bidId,uint256 quantity,uint256 nonce,bytes bidSignature)"
        );

    function getAcceptBidHash(LibStruct.LazyAcceptBid memory _lazyAcceptBid)
        internal
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encode(
                    ACCEPT_BID_HASH,
                    _lazyAcceptBid.lazyBid.id,
                    _lazyAcceptBid.quantity,
                    _lazyAcceptBid.nonce,
                    keccak256(_lazyAcceptBid.lazyBid.signature)
                )
            );
    }
}
