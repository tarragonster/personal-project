// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface IHuukReferral {
    function getReferral(address user) external view returns (address payable);
}
