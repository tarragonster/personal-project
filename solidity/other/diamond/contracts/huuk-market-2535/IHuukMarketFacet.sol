// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "../libs/LibStruct.sol";

interface IHuukMarketFacet {
    function setSystemFee(
        uint256 _xUser,
        uint256 _xCreator,
        uint256 _yRefRate,
        uint256 _zProfitToCreator,
        uint256 _discountForBuyer,
        uint256 _discountForHuuk,
        uint256 _xPremium
    ) external;

    function createOrder(
        address _tokenAddress,
        address _paymentToken, // payment method
        uint256 _tokenId,
        uint256 _quantity, // total amount for sale
        uint256 _price // price of 1 nft
    ) external returns (uint256 _orderId);

    function cancelOrder(uint256 _orderId) external;

    function updateOrder(
        uint256 _orderId,
        uint256 _quantity,
        uint256 _price
    ) external;

    function lazyBuy(LibStruct.LazyOrder calldata _order, uint256 _amount, address _receiver)
        external
        payable
        returns (bool);

    function buy(
        uint256 _orderId,
        uint256 _quantity,
        address _paymentToken,
        address _receiver
    ) external payable returns (bool);

    function lazyAcceptBid(LibStruct.LazyAcceptBid memory _lazyAcceptBid)
        external
        payable
        returns (bool);

    function cancelBid(uint256 _bidId) external;

    function updateBid(
        uint256 _bidId,
        uint256 _quantity,
        uint256 _bidPrice
    ) external;

    function setHuukContract(address _huuk) external returns (bool);

    function addHuukNFTs(address _huukNFT, bool _isHuukNFT)
        external
        returns (bool);

    function addHuukNFTPremiums(address _huukNFTPremium, bool _isHuukNFTPremium)
        external
        returns (bool);

    function setReferralContract(address _referralContract)
        external
        returns (bool);

    function setHuukExchangeContract(address _huukExchangeContract)
        external
        returns (bool);

    function setProfitSenderContract(address _profitSender)
        external
        returns (bool);

    function setPaymentMethod(address _token, bool _status)
        external
        returns (bool);

    function orders(uint256 _orderId)
        external
        view
        returns (LibStruct.Order memory);
}
