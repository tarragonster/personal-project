// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

contract Caller {
    uint256 public numberC;
    function setAddNumber(Callee addr, uint256 numberA, uint256 numberB) public {
        numberC = addr.setTestNum(numberA, numberB);
    }
}

contract Callee {
    uint256 public testNum;
    function setAddNumber(uint256 _numberA, uint256 _numberB) public pure returns (uint256 numberC) {
        numberC = _numberA + _numberB;
    }

    function setTestNum(uint256 _numberA, uint256 _numberB) public returns (uint256 numberC) {
        testNum = _numberA + _numberB;
        numberC = _numberA + _numberB;
    }
}