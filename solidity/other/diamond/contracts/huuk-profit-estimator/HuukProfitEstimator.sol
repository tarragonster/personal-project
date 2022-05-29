// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "../interfaces/IHuukExchange.sol";
import "../interfaces/IHuukNFT.sol";

contract HuukProfitEstimator is OwnableUpgradeable, UUPSUpgradeable {
    address public huukMarket;
    address public huukExchangeContract;
    uint256 public xUser; // 2.5%
    uint256 public constant ZOOM_FEE = 10 ** 4;

    function initialize(address _huukMarket, address _huukExchangeContract)
    public
    initializer
    {
        __HuukProfitEstimator_init(_huukMarket, _huukExchangeContract);
    }

    function __HuukProfitEstimator_init(
        address _huukMarket,
        address _huukExchangeContract
    ) internal initializer {
        __Ownable_init_unchained();
        __HuukProfitEstimator_init_unchained(
            _huukMarket,
            _huukExchangeContract
        );
    }

    function __HuukProfitEstimator_init_unchained(
        address _huukMarket,
        address _huukExchangeContract
    ) internal initializer {
        huukMarket = _huukMarket;
        huukExchangeContract = _huukExchangeContract;
        xUser = 250;
    }

    modifier onlyMarket() {
        require(msg.sender == huukMarket, "Invalid-sender");
        _;
    }

    function setMarket(address _huukMarket) external onlyOwner {
        huukMarket = _huukMarket;
    }

    function setFee(uint256 _xUser) external onlyOwner {
        xUser = _xUser;
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

    function profitToCreator(
        address _nft,
        address _paymentToken,
        uint256 _tokenId,
        uint256 _amount,
        uint256 _price,
        uint256 _lastBuyPriceInUSD
    ) external view onlyMarket returns (uint256) {
        uint256 loyaltyFee = IHuukNFT(_nft).getRoyaltyFee(_tokenId);
        uint256 buyPriceInUSD = estimateUSDT(_paymentToken, _price);
        if (buyPriceInUSD > _lastBuyPriceInUSD) {
            uint256 totalSell = buyPriceInUSD * _amount * (ZOOM_FEE - xUser) / ZOOM_FEE;
            uint256 totalBuy = _lastBuyPriceInUSD * _amount * (ZOOM_FEE + xUser) / ZOOM_FEE;
            if (totalSell > totalBuy) {
                uint256 profitInUSDT = totalSell - totalBuy;
                return estimateToken(_paymentToken, profitInUSDT * loyaltyFee / ZOOM_FEE);
            }
        }
        return 0;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[48] private __gap;
}
