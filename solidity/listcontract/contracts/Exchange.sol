// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./interfaces/IUniswapRouter.sol";

pragma solidity ^0.8;

contract Exchange is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    address public uniswapRouter;
    address public USDT;
    address public wrappedToken;

    function initialize(
        address _uniswapRouter,
        address _USDT,
        address _wrappedToken
    ) public virtual initializer {
        __Exchange_init(_uniswapRouter, _USDT, _wrappedToken);
    }

    function __Exchange_init(
        address _uniswapRouter,
        address _USDT,
        address _wrappedToken
    ) internal onlyInitializing {
        __Exchange_init_unchained(_uniswapRouter, _USDT, _wrappedToken);
        __Ownable_init_unchained();
        __UUPSUpgradeable_init_unchained();
    }

    function __Exchange_init_unchained(
        address _uniswapRouter,
        address _USDT,
        address _wrappedToken
    ) internal onlyInitializing {
        uniswapRouter = _uniswapRouter;
        USDT = _USDT;
        wrappedToken = _wrappedToken;
    }

    /**
     * @dev get path for exchange ETH->BNB->USDT via Pancake
     */
    function getPathFromTokenToUSDT(address token)
        private
        view
        returns (address[] memory)
    {
        if (token == wrappedToken) {
            address[] memory path = new address[](2);
            path[0] = wrappedToken;
            path[1] = USDT;
            return path;
        } else {
            address[] memory path = new address[](3);
            path[0] = token;
            path[1] = wrappedToken;
            path[2] = USDT;
            return path;
        }
    }

    function getPathFromUsdtToToken(address token)
        private
        view
        returns (address[] memory)
    {
        if (token == wrappedToken) {
            address[] memory path = new address[](2);
            path[0] = USDT;
            path[1] = wrappedToken;
            return path;
        } else {
            address[] memory path = new address[](3);
            path[0] = USDT;
            path[1] = wrappedToken;
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
                path = getPathFromTokenToUSDT(wrappedToken);
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
                path = getPathFromUsdtToToken(wrappedToken);
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

    uint256[50] private __gap;
}
