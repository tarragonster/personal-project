// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "../interfaces/uniswap/IUniswapRouter.sol";

// uniswapRouter 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506
// USDT 0xc2132D05D31c914a87C6611C10748AEb04B58e8F
// WMATIC 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270
// other

contract HuukExchange is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    address public uniswapRouter;
    address public USDT;
    address public wrapped;

    function initialize(
        address _uniswapRouter,
        address _USDT,
        address _wrapped
    ) public virtual initializer {
        __HuukExchange_init(_uniswapRouter, _USDT, _wrapped);
    }

    function __HuukExchange_init(
        address _uniswapRouter,
        address _USDT,
        address _wrapped
    ) internal onlyInitializing {
        __Ownable_init_unchained();
        __HuukExchange_init_unchained(_uniswapRouter, _USDT, _wrapped);
    }

    function __HuukExchange_init_unchained(
        address _uniswapRouter,
        address _USDT,
        address _wrapped
    ) internal onlyInitializing {
        uniswapRouter = _uniswapRouter;
        USDT = _USDT;
        wrapped = _wrapped;
    }

    function changeRouter(address _newRouter) external onlyOwner {
        uniswapRouter = _newRouter;
    }

    /**
     * @dev get path for exchange ETH->BNB->USDT via Pancake
     */
    function getPathFromTokenToUSDT(address token)
        private
        view
        returns (address[] memory)
    {
        if (token == wrapped) {
            address[] memory path = new address[](2);
            path[0] = wrapped;
            path[1] = USDT;
            return path;
        } else {
            address[] memory path = new address[](3);
            path[0] = token;
            path[1] = wrapped;
            path[2] = USDT;
            return path;
        }
    }

    function getPathFromUsdtToToken(address token)
        private
        view
        returns (address[] memory)
    {
        if (token == wrapped) {
            address[] memory path = new address[](2);
            path[0] = USDT;
            path[1] = wrapped;
            return path;
        } else {
            address[] memory path = new address[](3);
            path[0] = USDT;
            path[1] = wrapped;
            path[2] = token;
            return path;
        }
    }

    function estimateToUSDT(address _paymentToken, uint256 _paymentAmount)
        public
        view
        returns (uint256)
    {
        uint256[] memory amounts;
        uint256 result;
        if (_paymentToken != USDT) {
            address[] memory path;
            uint256 amountIn = _paymentAmount;
            if (_paymentToken == address(0)) {
                path = getPathFromTokenToUSDT(wrapped);
                amounts = IUniswapRouter(uniswapRouter).getAmountsOut(
                    amountIn,
                    path
                );
                result = amounts[1];
            } else {
                path = getPathFromTokenToUSDT(_paymentToken);
                amounts = IUniswapRouter(uniswapRouter).getAmountsOut(
                    amountIn,
                    path
                );
                result = amounts[2];
            }
        } else {
            result = _paymentAmount;
        }
        return result;
    }

    function estimateFromUSDT(address _paymentToken, uint256 _usdtAmount)
        public
        view
        returns (uint256)
    {
        uint256[] memory amounts;
        uint256 result;
        if (_paymentToken != USDT) {
            address[] memory path;
            uint256 amountIn = _usdtAmount;
            if (_paymentToken == address(0)) {
                path = getPathFromUsdtToToken(wrapped);
                amounts = IUniswapRouter(uniswapRouter).getAmountsOut(
                    amountIn,
                    path
                );
                result = amounts[1];
            } else {
                path = getPathFromUsdtToToken(_paymentToken);
                amounts = IUniswapRouter(uniswapRouter).getAmountsOut(
                    amountIn,
                    path
                );
                result = amounts[2];
            }
        } else {
            result = _usdtAmount;
        }
        return result;
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {
        // Do something here.
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[45] private __gap;
}
