// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface IWrapped {
    function deposit() external payable returns (bool);

    function withdraw(uint256 _id) external returns (bool);
}
