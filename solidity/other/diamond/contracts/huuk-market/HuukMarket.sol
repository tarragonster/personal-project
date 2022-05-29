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

contract HuukMarket is
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

    uint256 public constant ZOOM_FEE = 10**4;
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

    function initialize(string memory _name, string memory _version)
        public
        initializer
    {
        __HuukMarket_init(_name, _version);
    }

    function __HuukMarket_init(string memory _name, string memory _version)
        internal
        onlyInitializing
    {
        __ReentrancyGuard_init_unchained();
        __HuukMarket_init_unchained();
        __ERC721Holder_init_unchained();
        __ERC1155Holder_init_unchained();
        __Ownable_init_unchained();
        __Pausable_init_unchained();
        __EIP712_init_unchained(_name, _version);
    }

    function __HuukMarket_init_unchained() internal onlyInitializing {
        isOperator[msg.sender] = true;
        xUser = 250;
        xCreator = 1500;
        yRefRate = 5000;
        zProfitToCreator = 5000;
        discountForBuyer = 50;
        discountForHuuk = 100;
    }

    modifier onlyOperator() {
        require(isOperator[msg.sender], "operator");
        _;
    }

    function whiteListOperator(address _operator, bool _whitelist)
        external
        onlyOwner
    {
        isOperator[_operator] = _whitelist;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unPause() public onlyOwner {
        _unpause();
    }

    function setSystemFee(
        uint256 _xUser,
        uint256 _xCreator,
        uint256 _yRefRate,
        uint256 _zProfitToCreator,
        uint256 _discountForBuyer,
        uint256 _discountForHuuk,
        uint256 _xPremium
    ) external onlyOwner {
        _setSystemFee(
            _xUser,
            _xCreator,
            _yRefRate,
            _zProfitToCreator,
            _discountForBuyer,
            _discountForHuuk,
            _xPremium
        );
    }

    function _setSystemFee(
        uint256 _xUser,
        uint256 _xCreator,
        uint256 _yRefRate,
        uint256 _zProfitToCreator,
        uint256 _discountForBuyer,
        uint256 _discountForHuuk,
        uint256 _xPremium
    ) internal {
        xUser = _xUser;
        xCreator = _xCreator;
        yRefRate = _yRefRate;
        zProfitToCreator = _zProfitToCreator;
        discountForBuyer = _discountForBuyer;
        discountForHuuk = _discountForHuuk;
        xPremium = _xPremium;
    }

    function getRefData(address _user) private view returns (address payable) {
        address payable userRef = IHuukReferral(referralContract).getReferral(
            _user
        );
        return userRef;
    }

    function estimateUSDT(address _paymentToken, uint256 _paymentAmount)
        private
        view
        returns (uint256)
    {
        return
            IHuukExchange(huukExchangeContract).estimateToUSDT(
                _paymentToken,
                _paymentAmount
            );
    }

    function estimateToken(address _paymentToken, uint256 _usdtAmount)
        private
        view
        returns (uint256)
    {
        return
            IHuukExchange(huukExchangeContract).estimateFromUSDT(
                _paymentToken,
                _usdtAmount
            );
    }

    function _createOrder(CreateOrderInput memory _input)
        internal
        whenNotPaused
        returns (uint256 _orderId)
    {
        require(
            paymentMethod[_input._paymentToken],
            "payment"
        );
        require(_input._quantity > 0, "quantity");
        bool isERC721 = IERC721Upgradeable(_input._tokenAddress)
            .supportsInterface(_INTERFACE_ID_ERC721);
        uint256 balance;
        if (isERC721) {
             balance = (IERC721Upgradeable(_input._tokenAddress).ownerOf(_input._tokenId) == _input._owner) ? 1 : 0;
             require(balance >= _input._quantity, "Insufficient-token-balance");

            IERC721Upgradeable(_input._tokenAddress).safeTransferFrom( _input._owner, address(this),_input._tokenId);
        } else {
            balance = IERC1155Upgradeable(_input._tokenAddress).balanceOf(
                _input._owner,
                _input._tokenId
            );
            require(balance >= _input._quantity, "token-balance");
            IERC1155Upgradeable(_input._tokenAddress).safeTransferFrom(
                _input._owner,
                address(this),
                _input._tokenId,
                _input._quantity,
                "0x"
            );
        }
        Order memory newOrder = Order({
            isOnsale: true,
            owner: _input._owner,
            price: _input._price,
            quantity: _input._quantity,
            tokenId: _input._tokenId,
            isERC721: isERC721,
            tokenAddress: _input._tokenAddress,
            paymentToken: _input._paymentToken
        });

        orders[totalOrders] = newOrder;
        emit OrderCreated(
            totalOrders,
            _input._tokenAddress,
            _input._tokenId,
            _input._quantity,
            _input._price,
            _input._paymentToken
        );
        bytes32 _id = keccak256(
            abi.encodePacked(_input._tokenAddress, _input._tokenId, _input._owner)
        );
        orderID[_id] = totalOrders;
        totalOrders = totalOrders + 1;
        return totalOrders - 1;
    }

    function createOrder(
        address _tokenAddress,
        address _paymentToken, // payment method
        uint256 _tokenId,
        uint256 _quantity, // total amount for sale
        uint256 _price // price of 1 nft
    ) external whenNotPaused returns (uint256 _orderId) {
        CreateOrderInput memory input = CreateOrderInput({
            _owner: msg.sender,
            _tokenAddress: _tokenAddress,
            _paymentToken: _paymentToken, // payment method
            _tokenId: _tokenId,
            _quantity: _quantity, // total amount for sale
            _price: _price
        });
        return _createOrder(input);
    }

    function _buy(
        uint256 _orderId,
        uint256 _quantity,
        address _paymentToken
    ) internal whenNotPaused returns (bool) {
        Order memory order = orders[_orderId];
        require(order.owner != address(0), "order-id");
        require(
            paymentMethod[_paymentToken],
            "payment"
        );
        require(
            order.isOnsale && order.quantity >= _quantity,
            "available"
        );
        uint256 orderAmount = order.price * _quantity;
        uint256 exactPaymentAmount;
        if (_paymentToken == order.paymentToken) {
            if (isHuukNFTPremiums[order.tokenAddress]) {
                exactPaymentAmount = (orderAmount * (ZOOM_FEE + xPremium)) / ZOOM_FEE;
            } else {
                exactPaymentAmount = (orderAmount * (ZOOM_FEE + xUser)) / ZOOM_FEE;
            }
        } else {
            orderAmount = estimateToken(_paymentToken, orderAmount);
            if (isHuukNFTPremiums[order.tokenAddress]) {
                exactPaymentAmount = (orderAmount * (ZOOM_FEE + xPremium)) / ZOOM_FEE;
            } else {
                exactPaymentAmount = (orderAmount * (ZOOM_FEE + xUser)) / ZOOM_FEE;
            }
        }
        if (_paymentToken == huuk && discountForHuuk > 0) {
            exactPaymentAmount =
                exactPaymentAmount -
                ((orderAmount * discountForHuuk) / ZOOM_FEE);
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
        address _paymentToken
    ) external payable whenNotPaused returns (bool) {
        return _buy(_orderId, _quantity, _paymentToken);
    }

    function _createBid(CreateBidInput memory _input)
        internal
        returns (uint256 _bidId)
    {
        require(_input._quantity > 0, "quantity");
        require(
            paymentMethod[_input._paymentToken],
            "payment"
        );
        Bid memory newBid = Bid({
            bidder: _input._bidder,
            bidPrice: _input._price,
            quantity: _input._quantity,
            tokenId: _input._tokenId,
            tokenAddress: _input._tokenAddress,
            status: true,
            expTime: _input._expTime,
            paymentToken: address(0)
        });
        if (msg.value > 0) {
            require(
                msg.value >= _input._quantity * _input._price,
                "amount"
            );
        } else {
            newBid.paymentToken = _input._paymentToken;
        }
        bids[totalBids] = newBid;
        _bidId = totalBids;
        totalBids = totalBids + 1;
        emit BidCreated(
            _bidId,
            _input._tokenAddress,
            _input._tokenId,
            _input._quantity,
            _input._price,
            newBid.paymentToken
        );
        return _bidId;
    }

    struct AcceptBidInput {
        address _owner;
        uint256 _bidId;
        uint256 _quantity;
    }

    function _acceptBid(AcceptBidInput memory _input) internal returns (bool) {
        Bid memory bid = bids[_input._bidId];
        uint256 exactPaymentAmount;
        bytes32 _id = keccak256(
            abi.encodePacked(bid.tokenAddress, bid.tokenId, _input._owner)
        );
        uint256 orderId = orderID[_id];
        Order memory order = orders[orderId];
        require(
            order.owner == _input._owner && order.isOnsale,
            "order-owner-or-cancelled"
        );
        require(
            order.quantity >= _input._quantity &&
                _input._quantity <= bid.quantity &&
                bid.status,
            "quantity-or-bid-cancelled"
        );
        uint256 orderAmount = bid.bidPrice * _input._quantity;
        if (isHuukNFTPremiums[order.tokenAddress]) {
            exactPaymentAmount = (orderAmount * (ZOOM_FEE + xPremium)) / ZOOM_FEE;
            // 1.015
        } else {
            exactPaymentAmount = (orderAmount * (ZOOM_FEE + xUser)) / ZOOM_FEE;
            // 1.025
        }

        if (bid.paymentToken == huuk) {
            exactPaymentAmount =
                exactPaymentAmount -
                ((orderAmount * discountForHuuk) / ZOOM_FEE);
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
            orderId,
            _input._quantity,
            bid.bidPrice,
            orderAmount,
            getRefData(order.owner),
            getRefData(bid.bidder)
        );
        emit AcceptBid(_input._bidId);
        return _updateBid(_input._bidId, _input._quantity);
    }

    function cancelOrder(uint256 _orderId) external whenNotPaused {
        Order memory order = orders[_orderId];
        require(
            order.owner == msg.sender && order.isOnsale,
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
        "0x"
//                abi.encodePacked(
//                    keccak256(
//                        "onERC1155Received(address,address,uint256,uint256,bytes)"
//                    )
//                )
            );
        }
        order.quantity = 0;
        order.isOnsale = false;
        orders[_orderId] = order;
        emit OrderCancelled(_orderId);
    }

    function cancelBid(uint256 _bidId) external whenNotPaused nonReentrant {
        Bid memory bid = bids[_bidId];
        require(bid.bidder == msg.sender, "bidder");
        if (bid.paymentToken == address(0)) {
            uint256 payBackAmount = bid.quantity * bid.bidPrice;
            payable(msg.sender).sendValue(payBackAmount);
        }
        bid.status = false;
        bid.quantity = 0;
        bids[_bidId] = bid;
        emit BidCancelled(_bidId);
    }

    function updateOrder(
        uint256 _orderId,
        uint256 _quantity,
        uint256 _price
    ) external whenNotPaused {
        Order memory order = orders[_orderId];
        require(
            order.owner == msg.sender && order.isOnsale,
            "order-owner-or-cancelled"
        );
        if (_quantity > order.quantity && !order.isERC721) {
            IERC1155Upgradeable(order.tokenAddress).safeTransferFrom(
                msg.sender,
                address(this),
                order.tokenId,
                _quantity - order.quantity,
                "0x"
            );
            order.quantity = _quantity;
        } else if (_quantity < order.quantity) {
            IERC1155Upgradeable(order.tokenAddress).safeTransferFrom(
                address(this),
                msg.sender,
                order.tokenId,
                order.quantity - _quantity,
                abi.encodePacked(
                    keccak256(
                        "onERC1155Received(address,address,uint256,uint256,bytes)"
                    )
                )
            );
            order.quantity = _quantity;
        }
        order.price = _price;
        orders[_orderId] = order;
        emit OrderUpdated(_orderId);
    }

    function updateBid(
        uint256 _bidId,
        uint256 _quantity,
        uint256 _bidPrice
    ) external whenNotPaused {
        Bid memory bid = bids[_bidId];
        require(bid.bidder == msg.sender, "bidder");
        bid.quantity = _quantity;
        bid.bidPrice = _bidPrice;
        bids[_bidId] = bid;
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

    function _updateBid(uint256 _bidId, uint256 _quantity)
        private
        returns (bool)
    {
        Bid memory bid = bids[_bidId];
        bid.quantity = bid.quantity - _quantity;
        bids[_bidId] = bid;
        return true;
    }

    function _updateOrder(
        address _buyer,
        address _paymentToken,
        uint256 _orderId,
        uint256 _quantity,
        uint256 _price,
        bytes32 _id
    ) private returns (bool) {
        Order memory order = orders[_orderId];
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
        order.quantity = order.quantity - _quantity;
        orders[_orderId].quantity = order.quantity;
        lastBuyPriceInUSDT[_buyer][_id] = estimateUSDT(_paymentToken, _price);
        return true;
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
        Order memory order = orders[_orderId];
        uint256 amountToSeller = orderAmount;

        if (buyerRef != address(0)) {
            uint256 amountToBuyerRef;
            if (isHuukNFTPremiums[order.tokenAddress]) {
                amountToBuyerRef = (orderAmount * xPremium * (ZOOM_FEE - yRefRate)) / (ZOOM_FEE**2);
            } else {
                amountToBuyerRef = (orderAmount * xUser * (ZOOM_FEE - yRefRate)) / (ZOOM_FEE**2);
            }
            _paid(_paymentToken, buyerRef, amountToBuyerRef);
            if (discountForBuyer > 0) {
                // discount for buyer that have ref
                _paid(_paymentToken, _buyer, (orderAmount * discountForBuyer) / ZOOM_FEE);
            }
        }

        if (isHuukNFTs[order.tokenAddress]) {
            address payable creator = payable(IHuukNFT(order.tokenAddress).getCreator(order.tokenId));
            if (isHuukNFTPremiums[order.tokenAddress]) {
                amountToSeller = amountToSeller - ((orderAmount * xPremium) / ZOOM_FEE);
            } else {
                amountToSeller = amountToSeller - ((orderAmount * xUser) / ZOOM_FEE);
            }
            if (sellerRef != address(0)) {
                if (isHuukNFTPremiums[order.tokenAddress]) {
                    _paid(_paymentToken, sellerRef, (orderAmount * xPremium * (ZOOM_FEE - yRefRate)) / (ZOOM_FEE**2));
                } else {
                    _paid(_paymentToken, sellerRef, (orderAmount * xUser * (ZOOM_FEE - yRefRate)) / (ZOOM_FEE**2));
                }
            }

            if (order.owner == creator) {
                _paid(_paymentToken, order.owner, amountToSeller);
            } else {
                uint256 amountToCreator = IProfitEstimator(profitSender).profitToCreator(
                    order.tokenAddress,
                    _paymentToken,
                    order.tokenId,
                    _quantity,
                    _price,
                    lastBuyPriceInUSDT[order.owner][keccak256(abi.encodePacked(order.tokenAddress, order.tokenId))]
                );
                if (amountToCreator > 0) {
                    _paid(_paymentToken, creator, amountToCreator);
                }
                _paid(_paymentToken, order.owner, amountToSeller - amountToCreator);
            }
        } else {
            if (isHuukNFTPremiums[order.tokenAddress]) {
                amountToSeller = amountToSeller - ((orderAmount * xPremium) / ZOOM_FEE);
            } else {
                amountToSeller = amountToSeller - ((orderAmount * xUser) / ZOOM_FEE);
            }
            if (sellerRef != address(0)) {
                if (isHuukNFTPremiums[order.tokenAddress]) {
                    _paid(_paymentToken, sellerRef, (orderAmount * xPremium * (ZOOM_FEE - yRefRate)) / (ZOOM_FEE**2));
                } else {
                    _paid(_paymentToken, sellerRef, (orderAmount * xUser * (ZOOM_FEE - yRefRate)) / (ZOOM_FEE**2));
                }
            }
            _paid(_paymentToken, order.owner, amountToSeller);
        }

        return
            _updateOrder(
                _buyer,
                _paymentToken,
                _orderId,
                _quantity,
                _price,
                keccak256(abi.encodePacked(order.tokenAddress, order.tokenId))
            );
    }

    function setHuukContract(address _huuk) public onlyOwner returns (bool) {
        huuk = _huuk;
        return true;
    }

    function addHuukNFTs(address _huukNFT, bool _isHuukNFT)
        external
        onlyOperator
        returns (bool)
    {
        isHuukNFTs[_huukNFT] = _isHuukNFT;

        return true;
    }

    function addHuukNFTPremiums(address _huukNFTPremium, bool _isHuukNFTPremium)
    external
    onlyOperator
    returns (bool)
    {
        isHuukNFTPremiums[_huukNFTPremium] = _isHuukNFTPremium;

        return true;
    }

    function setReferralContract(address _referralContract)
        public
        onlyOwner
        returns (bool)
    {
        referralContract = _referralContract;
        return true;
    }

    function setHuukExchangeContract(address _huukExchangeContract)
        public
        onlyOwner
        returns (bool)
    {
        huukExchangeContract = _huukExchangeContract;
        return true;
    }

    function setProfitSenderContract(address _profitSender)
        public
        onlyOwner
        returns (bool)
    {
        profitSender = _profitSender;
        return true;
    }

    function setPaymentMethod(address _token, bool _status)
        public
        onlyOwner
        returns (bool)
    {
        paymentMethod[_token] = _status;
        if (_token != address(0)) {
            IERC20Upgradeable(_token).approve(msg.sender, type(uint256).max);
            IERC20Upgradeable(_token).approve(address(this), type(uint256).max);
        }
        return true;
    }

    /// lazymint Order

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

    function lazyBuy(
        LazyOrder calldata _order,
        uint256 _amount,
        address _receiver,
        bytes calldata _signature
    ) external payable whenNotPaused returns (bool) {
        require(_amount <= _order.amount, "buy-amount");

        uint256 tokenId = _createToken(_order.token, _signature);

        CreateOrderInput memory input = CreateOrderInput({
            _owner: _order.token.owner,
            _tokenAddress: _order.token.token,
            _paymentToken: _order.paymentToken, // payment method
            _tokenId: tokenId,
            _quantity: _order.amount, // total amount for sale
            _price: _order.price
        });
        uint256 orderId = _createOrder(input);
        if (_receiver != address(0)) {
            require(isOperator[msg.sender], "Operator");
            return _updateOrder(
                _receiver,
                _order.paymentToken,
                orderId,
                _amount,
                _order.price,
                keccak256(abi.encodePacked(_order.token.token, tokenId))
            );
        }
        return _buy(orderId, _amount, _order.paymentToken);
    }

    struct LazyBid {
        uint256 amount;
        uint256 price;
        uint256 nonce;
        bytes signature;
        bytes bidSignature;
    }

    function lazyBid(LazyOrder calldata _order, LazyBid calldata _lazyBid)
        external
        payable
        whenNotPaused
        returns (bool){
        require(!executed[_lazyBid.nonce], "nonce-bid");
        executed[_lazyBid.nonce] = true;
        require(
            _recoverBid(
                _lazyBid.amount,
                _lazyBid.price,
                _lazyBid.nonce,
                msg.sender,
                _lazyBid.signature,
                _lazyBid.bidSignature
            ) == _order.token.owner,
            "signature"
        );

        uint256 tokenId = _createToken(_order.token, _lazyBid.signature);

        bytes32 id = keccak256(
            abi.encodePacked(_order.token.token, tokenId, _order.token.owner)
        );
        uint256 orderId = orderID[id];
        Order memory order = orders[orderId];
        if (order.owner != _order.token.owner || !order.isOnsale) {
            CreateOrderInput memory input = CreateOrderInput({
                _owner: _order.token.owner,
                _tokenAddress: _order.token.token,
                _paymentToken: _order.paymentToken, // payment method
                _tokenId: tokenId,
                _quantity: _order.amount, // total amount for sale
                _price: _order.price
            });
            _createOrder(input);
        }
        CreateBidInput memory createBidInput = CreateBidInput({
            _tokenAddress: _order.token.token,
            _paymentToken: _order.paymentToken,
            _tokenId: tokenId,
            _quantity: _lazyBid.amount,
            _price: _lazyBid.price,
            _expTime: type(uint256).max,
            _bidder: msg.sender
        });
        uint256 bidId = _createBid(createBidInput);
        AcceptBidInput memory acceptBidInput = AcceptBidInput({
            _owner: _order.token.owner,
            _bidId: bidId,
            _quantity: _lazyBid.amount
        });
        return _acceptBid(acceptBidInput);
    }

    function _createToken(Token memory _token, bytes calldata _signature)
        internal
        whenNotPaused
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
                    _signature
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
                    _signature
                );
        }
    }

    function _recoverBid(
        uint256 _amount,
        uint256 _price,
        uint256 _nonce,
        address _recipient,
        bytes memory _signature,
        bytes memory _bidSignature
    ) internal view returns (address) {
        bytes32 ethTypedDataHash = _hashTypedDataV4(
            _getBidHash(_amount, _price, _nonce, _recipient, _signature)
        );
        address signer = ECDSAUpgradeable.recover(
            ethTypedDataHash,
            _bidSignature
        );
        return signer;
    }

    function _getBidHash(
        uint256 _amount,
        uint256 _price,
        uint256 _nonce,
        address _recipient,
        bytes memory _signature
    ) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    BID_HASH,
                    _amount,
                    _price,
                    _nonce,
                    _recipient,
                    keccak256(_signature)
                )
            );
    }


    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}

    uint256[48] private __gap;
    uint256 public xPremium;
    mapping(address => bool) public isHuukNFTPremiums;
}
