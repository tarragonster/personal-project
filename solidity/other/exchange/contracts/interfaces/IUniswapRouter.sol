// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

interface IUniswapRouter {
    function getAmountsOut(uint256 amountIn, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);
}