// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/utils/ERC1155HolderUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import "../interfaces/IHuukReferral.sol";
import "../interfaces/IHuukExchange.sol";
import "../interfaces/IHuukNFT.sol";
import "../interfaces/IProfitEstimator.sol";

import "../libs/LibSign.sol";
import "../libs/LibStruct.sol";
import "../libs/LibError.sol";
import "../libs/LibFunc.sol";
import "hardhat/console.sol";
import "./IHuukMarketFacet.sol";
import "../diamond/libraries/LibDiamond.sol";

contract HuukMarketFacet is IHuukMarketFacet {
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
    uint256 public constant ZOOM_FEE = 10**4;
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using AddressUpgradeable for address;
    using AddressUpgradeable for address payable;

    event OrderCreated(
        uint256 indexed _orderId,
        address _tokenAddress,
        uint256 indexed _tokenId,
        uint256 indexed _quantity,
        uint256 _price,
        address _paymentToken
    );
    event Buy(
        uint256 _itemId,
        uint256 _quantity,
        address _paymentToken,
        uint256 _paymentAmount
    );
    event OrderCancelled(uint256 indexed _orderId);
    event OrderUpdated(uint256 indexed _orderId);
    event BidCreated(
        uint256 indexed _bidId,
        uint256 indexed _orderId,
        uint256 indexed _quantity,
        uint256 _price,
        address _paymentToken
    );
    event AcceptBid(uint256 indexed _bidId);
    event BidUpdated(uint256 indexed _bidId);
    event BidCancelled(uint256 indexed _bidId);

    function setSystemFee(
        uint256 _xUser,
        uint256 _xCreator,
        uint256 _yRefRate,
        uint256 _zProfitToCreator,
        uint256 _discountForBuyer,
        uint256 _discountForHuuk,
        uint256 _xPremium
    ) external override {
        LibDiamond.enforceIsContractOwner();
        LibDiamond._setSystemFee(
            _xUser,
            _xCreator,
            _yRefRate,
            _zProfitToCreator,
            _discountForBuyer,
            _discountForHuuk,
            _xPremium
        );
    }

    function getRefData(address _user) private view returns (address payable) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        address payable userRef = IHuukReferral(ds.referralContract)
            .getReferral(_user);
        return userRef;
    }

    function estimateUSDT(address _paymentToken, uint256 _paymentAmount)
        private
        view
        returns (uint256)
    {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        return
            IHuukExchange(ds.huukExchangeContract).estimateToUSDT(
                _paymentToken,
                _paymentAmount
            );
    }

    function estimateToken(address _paymentToken, uint256 _usdtAmount)
        private
        view
        returns (uint256)
    {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        return
            IHuukExchange(ds.huukExchangeContract).estimateFromUSDT(
                _paymentToken,
                _usdtAmount
            );
    }

    function createOrder(
        address _tokenAddress,
        address _paymentToken, // payment method
        uint256 _tokenId,
        uint256 _quantity, // total amount for sale
        uint256 _price // price of 1 nft
    ) external override returns (uint256 _orderId) {
        LibDiamond.whenNotPaused();
        LibStruct.LazyOrder memory _input = LibStruct.LazyOrder({
            id: 0,
            token: LibStruct.Token({
                owner: msg.sender,
                token: _tokenAddress,
                id: _tokenId,
                uri: "",
                initialSupply: 0,
                maxSupply: 0,
                royaltyFee: 0,
                nonce: 0,
                isERC721: false,
                signature: bytes("")
            }),
            quantity: _quantity,
            price: _price,
            paymentToken: _paymentToken,
            representative: address(0),
            nonce: 0,
            signature: bytes("")
        });
        return _createOrder(_input);
    }

    function cancelOrder(uint256 _orderId) external override {
        LibDiamond.whenNotPaused();
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        LibStruct.Order memory order = ds.orders[_orderId];
        require(
            order.owner == msg.sender && order.isOnSale,
            "order-owner-or-cancelled"
        );
        if (order.isERC721) {
            IERC721Upgradeable(order.tokenAddress).safeTransferFrom(
                address(this),
                order.owner,
                order.tokenId
            );
        } else {
            IERC1155Upgradeable(order.tokenAddress).safeTransferFrom(
                address(this),
                order.owner,
                order.tokenId,
                order.quantity,
                ""
                //                abi.encodePacked(
                //                    keccak256(
                //                        "onERC1155Received(address,address,uint256,uint256,bytes)"
                //                    )
                //                )
            );
        }
        order.quantity = 0;
        order.isOnSale = false;
        ds.orders[_orderId] = order;
        emit OrderCancelled(_orderId);
    }

    function updateOrder(
        uint256 _orderId,
        uint256 _quantity,
        uint256 _price
    ) external override {
        LibDiamond.whenNotPaused();
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        LibStruct.Order memory order = ds.orders[_orderId];
        require(
            order.owner == msg.sender && order.isOnSale,
            "order-owner-or-cancelled"
        );
        if (_quantity > order.quantity && !order.isERC721) {
            IERC1155Upgradeable(order.tokenAddress).safeTransferFrom(
                msg.sender,
                address(this),
                order.tokenId,
                _quantity - order.quantity,
                ""
            );
            order.quantity = _quantity;
        } else if (_quantity < order.quantity) {
            IERC1155Upgradeable(order.tokenAddress).safeTransferFrom(
                address(this),
                msg.sender,
                order.tokenId,
                order.quantity - _quantity,
                ""
                //                abi.encodePacked(
                //                    keccak256(
                //                        "onERC1155Received(address,address,uint256,uint256,bytes)"
                //                    )
                //                )
            );
            order.quantity = _quantity;
        }
        order.price = _price;
        ds.orders[_orderId] = order;
        emit OrderUpdated(_orderId);
    }

    function lazyBuy(LibStruct.LazyOrder calldata _order, uint256 _amount, address _receiver)
        external
        payable
        override
        returns (bool)
    {
        LibDiamond.whenNotPaused();
        require(_amount <= _order.quantity, "buy-amount");
        uint256 orderId = _createLazyOrder(_order);
        if (_receiver != address(0)) {
            LibDiamond.enforceIsOperator();
            return _updateOrderAfterMatch(
                _receiver,
                _order.paymentToken,
                orderId,
                _amount,
                _order.price
            );
        }
        return _buy(orderId, _amount, _order.paymentToken);
    }

    function _createLazyOrder(LibStruct.LazyOrder memory _order)
        internal
        returns (uint256)
    {
        if (_order.id > 0) return _order.id;
        uint256 tokenId = _createToken(_order.token);
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        require(msg.sender == _order.representative, "representative");
        require(!ds.executedOrder[_order.nonce], "nonce-order");
        ds.executedOrder[_order.nonce] = true;

        bytes32 ethTypedDataHash = LibDiamond._hashTypedDataV4(
            LibSign.getOrderHash(_order)
        );
        address owner = ECDSA.recover(ethTypedDataHash, _order.signature);
        require(owner == _order.token.owner, "order-signature");
        _order.token.id = tokenId;
        return _createOrder(_order);
    }

    function _createToken(LibStruct.Token memory _token)
        internal
        returns (uint256)
    {
        if (_token.id > 0) return _token.id;
        if (_token.isERC721) {
            return
                IHuuk721(_token.token).create(
                    _token.owner,
                    _token.uri,
                    _token.royaltyFee,
                    _token.nonce,
                    _token.signature
                );
        } else {
            return
                IHuuk1155(_token.token).create(
                    _token.owner,
                    _token.maxSupply,
                    _token.initialSupply,
                    _token.royaltyFee,
                    _token.uri,
                    bytes(""),
                    _token.nonce,
                    _token.signature
                );
        }
    }

    function _createOrder(LibStruct.LazyOrder memory _input)
        internal
        returns (uint256 _orderId)
    {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        require(ds.paymentMethod[_input.paymentToken], "payment");
        require(_input.quantity > 0, "quantity");
        bool isERC721 = IERC721Upgradeable(_input.token.token)
            .supportsInterface(_INTERFACE_ID_ERC721);
        uint256 balance;
        if (isERC721) {
            require(
                IERC721Upgradeable(_input.token.token).ownerOf(
                    _input.token.id
                ) == _input.token.owner,
                "ownership"
            );
            balance = 1;
            require(balance >= _input.quantity, "Insufficient-token-balance");
            IERC721Upgradeable(_input.token.token).safeTransferFrom(
                _input.token.owner,
                address(this),
                _input.token.id
            );
        } else {
            balance = IERC1155Upgradeable(_input.token.token).balanceOf(
                _input.token.owner,
                _input.token.id
            );
            require(balance >= _input.quantity, "token-balance");
            IERC1155Upgradeable(_input.token.token).safeTransferFrom(
                _input.token.owner,
                address(this),
                _input.token.id,
                _input.quantity,
                ""
            );
        }
        ds.totalOrders = ds.totalOrders + 1;
        LibStruct.Order memory newOrder = LibStruct.Order({
            isOnSale: true,
            owner: _input.token.owner,
            price: _input.price,
            quantity: _input.quantity,
            tokenId: _input.token.id,
            isERC721: isERC721,
            tokenAddress: _input.token.token,
            paymentToken: _input.paymentToken
        });
        ds.orders[ds.totalOrders] = newOrder;
        bytes32 _id = LibFunc.getOrderUnique(newOrder);
        ds.orderID[_id] = ds.totalOrders;
        emit OrderCreated(
            ds.totalOrders,
            newOrder.tokenAddress,
            newOrder.tokenId,
            newOrder.quantity,
            newOrder.price,
            newOrder.paymentToken
        );
        return ds.totalOrders;
    }

    function _buy(
        uint256 _orderId,
        uint256 _quantity,
        address _paymentToken
    ) internal returns (bool) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        LibStruct.Order memory order = ds.orders[_orderId];
        require(order.owner != address(0), "id");
        require(_paymentToken == order.paymentToken, "payment");
        require(order.isOnSale && order.quantity >= _quantity, "available");
        uint256 orderAmount = order.price * _quantity;
        uint256 exactPaymentAmount;
        if (ds.isHuukNFTPremiums[order.tokenAddress]) {
            exactPaymentAmount = (orderAmount * (ZOOM_FEE + ds.xPremium)) / ZOOM_FEE;
        } else {
            exactPaymentAmount = (orderAmount * (ZOOM_FEE + ds.xUser)) / ZOOM_FEE;
        }
        if (_paymentToken == ds.huuk && ds.discountForHuuk > 0) {
            exactPaymentAmount =
                exactPaymentAmount -
                ((orderAmount * ds.discountForHuuk) / ZOOM_FEE);
        }
        if (_paymentToken == address(0) && msg.value > 0) {
            require(msg.value >= exactPaymentAmount);
        } else {
            IERC20Upgradeable(_paymentToken).safeTransferFrom(
                msg.sender,
                address(this),
                exactPaymentAmount
            );
        }
        emit Buy(_orderId, _quantity, _paymentToken, exactPaymentAmount);
        return
            _match(
                msg.sender,
                _paymentToken,
                _orderId,
                _quantity,
                estimateToken(_paymentToken, order.price),
                orderAmount,
                getRefData(order.owner),
                getRefData(msg.sender)
            );
    }

    function buy(
        uint256 _orderId,
        uint256 _quantity,
        address _paymentToken,
        address _receiver
    ) external payable override returns (bool) {
        LibDiamond.whenNotPaused();
        if (_receiver != address(0)) {
            LibDiamond.enforceIsOperator();
            return _updateOrderAfterMatch(
                _receiver,
                _paymentToken,
                _orderId,
                _quantity,
                LibDiamond.diamondStorage().orders[_orderId].price
            );
        }
        return _buy(_orderId, _quantity, _paymentToken);
    }

    function lazyAcceptBid(LibStruct.LazyAcceptBid memory _lazyAcceptBid)
        external
        payable
        override
        returns (bool)
    {
        LibDiamond.whenNotPaused();
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        uint256 bidId = _createLazyBid(_lazyAcceptBid.lazyBid);
        require(!ds.executedAcceptBid[_lazyAcceptBid.nonce], "nonce-a");
        ds.executedAcceptBid[_lazyAcceptBid.nonce] = true;
        bytes32 ethTypedDataHash = LibDiamond._hashTypedDataV4(
            LibSign.getAcceptBidHash(_lazyAcceptBid)
        );
        address owner = ECDSA.recover(
            ethTypedDataHash,
            _lazyAcceptBid.signature
        );
        _lazyAcceptBid.lazyBid.id = bidId;
        return _acceptBid(_lazyAcceptBid, owner);
    }

    function _createLazyBid(LibStruct.LazyBid memory _lazyBid)
        internal
        returns (uint256)
    {
        if (_lazyBid.id > 0) return _lazyBid.id;
        uint256 orderId = _createLazyOrder(_lazyBid.lazyOrder);
        require(msg.sender == _lazyBid.bidder, "bidder");
        bytes32 ethTypedDataHash = LibDiamond._hashTypedDataV4(
            LibSign.getBidHash(_lazyBid)
        );
        address bidder = ECDSA.recover(ethTypedDataHash, _lazyBid.signature);
        require(msg.sender == bidder, "bidder");
        _lazyBid.lazyOrder.id = orderId;
        return _createBid(_lazyBid);
    }

    function _createBid(LibStruct.LazyBid memory _lazyBid)
        internal
        returns (uint256)
    {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        require(_lazyBid.quantity > 0, "quantity");
        require(ds.paymentMethod[_lazyBid.paymentToken], "payment");

        if (_lazyBid.paymentToken == address(0)) {
            require(msg.value >= _lazyBid.quantity * _lazyBid.price, "money");
        }

        LibStruct.Bid memory newBid = LibStruct.Bid({
            bidder: msg.sender,
            bidPrice: _lazyBid.price,
            quantity: _lazyBid.quantity,
            orderId: _lazyBid.lazyOrder.id,
            status: true,
            expTime: _lazyBid.expTime,
            paymentToken: _lazyBid.paymentToken // default native token
        });
        ds.totalBids = ds.totalBids + 1;
        ds.bids[ds.totalBids] = newBid;
        emit BidCreated(
            ds.totalBids,
            newBid.orderId,
            newBid.quantity,
            newBid.bidPrice,
            newBid.paymentToken
        );
        return ds.totalBids;
    }

    function _acceptBid(
        LibStruct.LazyAcceptBid memory _lazyAcceptBid,
        address _owner
    ) internal returns (bool) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        LibStruct.Bid memory bid = ds.bids[_lazyAcceptBid.lazyBid.id];
        uint256 exactPaymentAmount;
        LibStruct.Order memory order = ds.orders[bid.orderId];
        require(order.isOnSale, "cancelled");
        require(order.owner == _owner, "owner");
        require(
            order.quantity >= _lazyAcceptBid.quantity &&
                _lazyAcceptBid.quantity <= bid.quantity &&
                bid.status,
            "quantity-or-bid-cancelled"
        );
        uint256 orderAmount = bid.bidPrice * _lazyAcceptBid.quantity;
        if (ds.isHuukNFTPremiums[order.tokenAddress]) {
            exactPaymentAmount = (orderAmount * (ZOOM_FEE + ds.xPremium)) / ZOOM_FEE;
            // 1.015
        } else {
            exactPaymentAmount = (orderAmount * (ZOOM_FEE + ds.xUser)) / ZOOM_FEE;
            // 1.025
        }

    if (bid.paymentToken == ds.huuk) {
            exactPaymentAmount =
                exactPaymentAmount -
                ((orderAmount * ds.discountForHuuk) / ZOOM_FEE);
        }
        if (bid.paymentToken != address(0)) {
            IERC20Upgradeable(bid.paymentToken).safeTransferFrom(
                bid.bidder,
                address(this),
                exactPaymentAmount
            );
        }
        _match(
            bid.bidder,
            bid.paymentToken,
            bid.orderId,
            _lazyAcceptBid.quantity,
            bid.bidPrice,
            orderAmount,
            getRefData(order.owner),
            getRefData(bid.bidder)
        );
        emit AcceptBid(_lazyAcceptBid.lazyBid.id);
        return _updateBidAfterMatch(_lazyAcceptBid.lazyBid.id, _lazyAcceptBid.quantity);
    }

    function _updateBidAfterMatch(uint256 _bidId, uint256 _quantity)
        private
        returns (bool)
    {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        LibStruct.Bid storage bid = ds.bids[_bidId];
        bid.quantity -= _quantity;
        ds.bids[_bidId] = bid;
        return true;
    }

    function cancelBid(uint256 _bidId) external override {
        LibDiamond.whenNotPaused();
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        LibStruct.Bid memory bid = ds.bids[_bidId];
        require(bid.bidder == msg.sender, "bidder");
        if (bid.paymentToken == address(0)) {
            uint256 payBackAmount = bid.quantity * bid.bidPrice;
            payable(msg.sender).sendValue(payBackAmount);
        }
        bid.status = false;
        bid.quantity = 0;
        ds.bids[_bidId] = bid;
        emit BidCancelled(_bidId);
    }

    function updateBid(
        uint256 _bidId,
        uint256 _quantity,
        uint256 _bidPrice
    ) external override {
        LibDiamond.whenNotPaused();
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        LibStruct.Bid memory bid = ds.bids[_bidId];
        require(bid.bidder == msg.sender, "bidder");
        bid.quantity = _quantity;
        bid.bidPrice = _bidPrice;
        ds.bids[_bidId] = bid;
        emit BidUpdated(_bidId);
    }

    function _paid(
        address _token,
        address _to,
        uint256 _amount
    ) private {
        require(_to != address(0), "address");
        if (_token == address(0)) {
            payable(_to).sendValue(_amount);
        } else {
            IERC20Upgradeable(_token).safeTransfer(_to, _amount);
        }
    }

    function _match(
        address _buyer,
        address _paymentToken,
        uint256 _orderId,
        uint256 _quantity,
        uint256 _price,
        uint256 orderAmount,
        address payable sellerRef,
        address payable buyerRef
    ) private returns (bool) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        LibStruct.Order memory order = ds.orders[_orderId];
        uint256 amountToSeller = orderAmount;

        if (buyerRef != address(0)) {
            uint256 amountToBuyerRef;
            if (ds.isHuukNFTPremiums[order.tokenAddress]) {
                amountToBuyerRef = (orderAmount * ds.xPremium * (ZOOM_FEE - ds.yRefRate)) / (ZOOM_FEE**2);
            } else {
                amountToBuyerRef = (orderAmount * ds.xUser * (ZOOM_FEE - ds.yRefRate)) / (ZOOM_FEE**2);
            }
            _paid(_paymentToken, buyerRef, amountToBuyerRef);
            if (ds.discountForBuyer > 0) {
                // discount for buyer that have ref
                _paid(
                    _paymentToken,
                    _buyer,
                    (orderAmount * ds.discountForBuyer) / ZOOM_FEE
                );
            }
        }
        if (ds.isHuukNFTs[order.tokenAddress]) {
            address payable creator = payable(
                IHuukNFT(order.tokenAddress).getCreator(order.tokenId)
            );

            if (ds.isHuukNFTPremiums[order.tokenAddress]) {
                amountToSeller = amountToSeller - ((orderAmount * ds.xPremium) / ZOOM_FEE);
            } else {
                amountToSeller = amountToSeller - ((orderAmount * ds.xUser) / ZOOM_FEE);
            }
            if (sellerRef != address(0)) {
                if (ds.isHuukNFTPremiums[order.tokenAddress]) {
                    _paid(_paymentToken, sellerRef, (orderAmount * ds.xPremium * (ZOOM_FEE - ds.yRefRate)) / (ZOOM_FEE**2));
                } else {
                    _paid(_paymentToken, sellerRef, (orderAmount * ds.xUser * (ZOOM_FEE - ds.yRefRate)) / (ZOOM_FEE**2));
                }
            }

            if (order.owner == creator) {
                _paid(_paymentToken, order.owner, amountToSeller);
            } else {
                uint256 amountToCreator = IProfitEstimator(ds.profitSender).profitToCreator(
                    order.tokenAddress,
                    _paymentToken,
                    order.tokenId,
                    _quantity,
                    _price,
                    ds.lastBuyPriceInUSDT[order.owner][keccak256(abi.encodePacked(order.tokenAddress, order.tokenId))]
                );
                if (amountToCreator > 0) {
                    _paid(_paymentToken, creator, amountToCreator);
                }
                _paid(_paymentToken, order.owner, amountToSeller - amountToCreator);
            }
        } else {
            if (ds.isHuukNFTPremiums[order.tokenAddress]) {
                amountToSeller = amountToSeller - ((orderAmount * ds.xPremium) / ZOOM_FEE);
            } else {
                amountToSeller = amountToSeller - ((orderAmount * ds.xUser) / ZOOM_FEE);
            }
            if (sellerRef != address(0)) {
                if (ds.isHuukNFTPremiums[order.tokenAddress]) {
                    _paid(_paymentToken, sellerRef, (orderAmount * ds.xPremium * (ZOOM_FEE - ds.yRefRate)) / (ZOOM_FEE**2));
                } else {
                    _paid(_paymentToken, sellerRef, (orderAmount * ds.xUser * (ZOOM_FEE - ds.yRefRate)) / (ZOOM_FEE**2));
                }
            }
            _paid(_paymentToken, order.owner, amountToSeller);
        }

        return
            _updateOrderAfterMatch(
                _buyer,
                _paymentToken,
                _orderId,
                _quantity,
                _price
            );
    }

    function _updateOrderAfterMatch(
        address _buyer,
        address _paymentToken,
        uint256 _orderId,
        uint256 _quantity,
        uint256 _price
    ) private returns (bool) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();

        LibStruct.Order storage order = ds.orders[_orderId];
        if (order.isERC721) {
            IERC721Upgradeable(order.tokenAddress).safeTransferFrom(
                address(this),
                _buyer,
                order.tokenId
            );
        } else {
            IERC1155Upgradeable(order.tokenAddress).safeTransferFrom(
                address(this),
                _buyer,
                order.tokenId,
                _quantity,
                abi.encodePacked(
                    keccak256(
                        "onERC1155Received(address,address,uint256,uint256,bytes)"
                    )
                )
            );
        }
        order.quantity -= _quantity;
        ds.orders[_orderId].quantity = order.quantity;
        ds.lastBuyPriceInUSDT[_buyer][keccak256(abi.encodePacked(order.tokenAddress, order.tokenId))] = estimateUSDT(
            _paymentToken,
            _price
        );
        return true;
    }

    function setHuukContract(address _huuk) external override returns (bool) {
        LibDiamond.enforceIsContractOwner();
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.huuk = _huuk;
        return true;
    }

    function addHuukNFTs(address _huukNFT, bool _isHuukNFT)
        external
        override
        returns (bool)
    {
        LibDiamond.enforceIsOperator();
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.isHuukNFTs[_huukNFT] = _isHuukNFT;
        return true;
    }

    function addHuukNFTPremiums(address _huukNFTPremium, bool _isHuukNFTPremium)
        external
        override
        returns (bool)
    {
        LibDiamond.enforceIsOperator();
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.isHuukNFTPremiums[_huukNFTPremium] = _isHuukNFTPremium;
        return true;
    }

    function setReferralContract(address _referralContract)
        external
        override
        returns (bool)
    {
        LibDiamond.enforceIsContractOwner();
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.referralContract = _referralContract;
        return true;
    }

    function setHuukExchangeContract(address _huukExchangeContract)
        external
        override
        returns (bool)
    {
        LibDiamond.enforceIsContractOwner();
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.huukExchangeContract = _huukExchangeContract;
        return true;
    }

    function setProfitSenderContract(address _profitSender)
        external
        override
        returns (bool)
    {
        LibDiamond.enforceIsContractOwner();
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.profitSender = _profitSender;
        return true;
    }

    function setPaymentMethod(address _token, bool _status)
        external
        override
        returns (bool)
    {
        LibDiamond.enforceIsContractOwner();
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.paymentMethod[_token] = _status;
        if (_token != address(0)) {
            IERC20Upgradeable(_token).approve(msg.sender, type(uint256).max);
            IERC20Upgradeable(_token).approve(address(this), type(uint256).max);
        }
        return true;
    }

    function orders(uint256 _orderId)
        external
        view
        override
        returns (LibStruct.Order memory)
    {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        return ds.orders[_orderId];
    }
}
