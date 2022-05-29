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
import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";

import "../interfaces/IHuukReferral.sol";
import "../interfaces/IHuukExchange.sol";
import "../interfaces/IHuukNFT.sol";
import "../interfaces/IProfitEstimator.sol";
import "../libs/LibStruct.sol";
import "../migration/IMigrationFacet.sol";

contract HuukMarketNew is
Initializable,
ReentrancyGuardUpgradeable,
ERC721HolderUpgradeable,
ERC1155HolderUpgradeable,
OwnableUpgradeable,
PausableUpgradeable,
EIP712Upgradeable,
UUPSUpgradeable
{
    using AddressUpgradeable for address;
    using AddressUpgradeable for address payable;
    using SafeERC20Upgradeable for IERC20Upgradeable;

    uint256 public constant ZOOM_FEE = 10 ** 4;
    uint256 public totalOrders;
    uint256 public totalBids;

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
    mapping(uint256 => bool) public executed;

    struct Order {
        address owner;
        address tokenAddress;
        address paymentToken;
        uint256 tokenId;
        uint256 quantity;
        uint256 price; // price of 1 NFT in paymentToken
        bool isOnsale; // true: on sale, false: cancel
        bool isERC721;
    }

    struct CreateOrderInput {
        address _owner;
        address _tokenAddress;
        address _paymentToken; // payment method
        uint256 _tokenId;
        uint256 _quantity; // total amount for sale
        uint256 _price; // price of 1 nft
    }

    struct CreateBidInput {
        address _tokenAddress;
        address _paymentToken; // payment method
        address _bidder;
        uint256 _tokenId;
        uint256 _quantity; // total amount for sale
        uint256 _price; // price of 1 nft
        uint256 _expTime;
    }

    struct Bid {
        address bidder;
        address paymentToken;
        address tokenAddress;
        uint256 tokenId;
        uint256 bidPrice;
        uint256 quantity;
        uint256 expTime;
        bool status; // 1: available | 2: done | 3: reject
    }

    mapping(uint256 => Order) public orders;
    mapping(bytes32 => uint256) private orderID;
    mapping(uint256 => Bid) public bids;
    mapping(address => mapping(bytes32 => uint256)) lastBuyPriceInUSDT; // lastbuy price of NFT with id = keccak256(address, id) from user in USD
    mapping(address => mapping(uint256 => uint256)) public amountFirstSale;

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
        address _tokenAddress,
        uint256 indexed _tokenId,
        uint256 indexed _quantity,
        uint256 _price,
        address _paymentToken
    );
    event AcceptBid(uint256 indexed _bidId);
    event BidUpdated(uint256 indexed _bidId);
    event BidCancelled(uint256 indexed _bidId);

    // manager

    address public huuk;
    address public referralContract;
    address public huukExchangeContract;
    address public profitSender;

    // FEE
    uint256 public xUser; // 2.5%
    uint256 public xCreator;
    uint256 public yRefRate; // 50%
    uint256 public zProfitToCreator; // 10% profit
    uint256 public discountForBuyer;
    uint256 public discountForHuuk; // discount for user who made payment in huuk
    mapping(address => bool) public paymentMethod;
    mapping(address => bool) public isHuukNFTs;
    mapping(address => bool) public isOperator;

    modifier onlyOperator() {
        require(isOperator[msg.sender], "operator");
        _;
    }

    struct AcceptBidInput {
        address _owner;
        uint256 _bidId;
        uint256 _quantity;
    }

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
    }

    struct LazyOrder {
        Token token;
        address paymentToken;
        uint256 price;
        uint256 amount;
    }

    bytes32 public constant BID_HASH =
    keccak256(
        "Bid(uint256 amount,uint256 price,uint256 nonce,address recipient,bytes signature)"
    );

    struct LazyBid {
        uint256 amount;
        uint256 price;
        uint256 nonce;
        bytes signature;
        bytes bidSignature;
    }

    function _authorizeUpgrade(address newImplementation)
    internal
    override
    onlyOwner
    {}

    function balance(address _tokenAddress) public view returns (uint256 accountBalance)
    {
        if (_tokenAddress == address(0)) {
            accountBalance = address(this).balance;
        } else {
            accountBalance = IERC20Upgradeable(_tokenAddress).balanceOf(address(this));
        }
    }

    /// withdraw allows the owner to transfer out the balance of the contract.
    function withdrawFunds(address payable _beneficiary, address _tokenAddress) external onlyOwner {
        uint256 _withdrawAmount;
        if (_tokenAddress == address(0)) {
            _beneficiary.transfer(address(this).balance);
            _withdrawAmount = address(this).balance;
        } else {
            _withdrawAmount = IERC20Upgradeable(_tokenAddress).balanceOf(address(this));
            IERC20Upgradeable(_tokenAddress).transfer(_beneficiary, _withdrawAmount);
        }
    }

    function transferNFTs(address _receiver) external onlyOwner {
        uint256 i;
        for (i = 0; i < totalOrders; i ++) {
            Order memory order = orders[i];
            if (order.isERC721) {
                IERC721Upgradeable(order.tokenAddress).safeTransferFrom(
                    address(this),
                    _receiver,
                    order.tokenId
                );
            } else {
                IERC1155Upgradeable(order.tokenAddress).safeTransferFrom(
                    address(this),
                    _receiver,
                    order.tokenId,
                    order.quantity,
                    abi.encodePacked(
                        keccak256(
                            "onERC1155Received(address,address,uint256,uint256,bytes)"
                        )
                    )
                );
            }
        }
    }

    function transferData(address _receiver) external {
        LibStruct.Migrate memory ds;
        ds.totalOrders = totalOrders;
        ds.totalBids = totalBids;
        ds.huuk = huuk;
        ds.referralContract = referralContract;
        ds.huukExchangeContract = huukExchangeContract;
        ds.profitSender = profitSender;
        ds.xUser = xUser;
        ds.xCreator = xCreator;
        ds.yRefRate = yRefRate;
        ds.zProfitToCreator = zProfitToCreator;
        ds.discountForBuyer = discountForBuyer;
        ds.discountForHuuk = discountForHuuk;
        ds.xPremium = xPremium;
        IMigrationFacet(_receiver).migrateData(ds);
        uint256 i;
        if (totalOrders > 0) {
            Order memory order = orders[0];
            if (order.owner == address(0)) {
                order = orders[totalOrders];
            }
            LibStruct.Order memory o = LibStruct.Order({
            owner : order.owner,
            tokenAddress : order.tokenAddress,
            paymentToken : order.paymentToken,
            tokenId : order.tokenId,
            quantity : order.quantity,
            price : order.price,
            isOnSale : order.isOnsale,
            isERC721 : order.isERC721});
            IMigrationFacet(_receiver).migrateOrder(totalOrders, o, isHuukNFTs[order.tokenAddress], isHuukNFTPremiums[order.tokenAddress]);
        }
        for (i = 1; i < totalOrders; i ++) {
            Order memory order = orders[i];
            LibStruct.Order memory o = LibStruct.Order({
            owner : order.owner,
            tokenAddress : order.tokenAddress,
            paymentToken : order.paymentToken,
            tokenId : order.tokenId,
            quantity : order.quantity,
            price : order.price,
            isOnSale : order.isOnsale,
            isERC721 : order.isERC721});
            IMigrationFacet(_receiver).migrateOrder(i, o, isHuukNFTs[order.tokenAddress], isHuukNFTPremiums[order.tokenAddress]);
        }
        //        for (i = 0; i < totalBids; i ++) {
        //            Bid memory bid = bids[i];
        //            bytes32 id = keccak256(
        //                abi.encodePacked(bid.tokenAddress, bid.tokenId, _input.owner)
        //            );
        //            ds.orderID[id] = id;
        //            LibStruct.Bid memory b = LibStruct.Bid({
        //            bidder : bid.bidder,
        //            paymentToken : bid.paymentToken,
        //            orderId : bid.orderId,
        //            bidPrice : bid.bidPrice,
        //            quantity : bid.quantity,
        //            expTime : bid.expTime,
        //            status : bid.status
        //            });
        //            IMigrationFacet(_receiver).migrateBid(i, bid);
        //        }
    }

    uint256[48] private __gap;
    uint256 public xPremium;
    mapping(address => bool) public isHuukNFTPremiums;
}
