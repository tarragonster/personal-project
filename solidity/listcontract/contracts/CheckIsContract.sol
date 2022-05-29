// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

interface ICheckIsContract {
    function isContractCode(address contractAddress) external view returns(bool isContract);
    function isContractAssembly(address contractAddress) external view returns(bool isContract);
    function isContractOpenzeppelin(address contractAddress) external view returns(bool isContract);
    function protectedNumber(address addr) external view returns(uint256 pNumber);
}


contract UnableToCheckContract {
    bool public isContract;
    uint256 public pNumber;

    constructor(address addr) {
        ICheckIsContract iCheckIsContract = ICheckIsContract(addr);
        isContract = iCheckIsContract.isContractAssembly(address(this));
        pNumber = iCheckIsContract.protectedNumber(address(this));
    }
}

contract CheckIsContract {
    using AddressUpgradeable for address;

    function isContractCode(address contractAddress) external view returns(bool isContract) {
        isContract = contractAddress.code.length > 0;
    }

    function isContractAssembly(address contractAddress) public view returns(bool isContract) {
        uint256 size;
        assembly { size := extcodesize(contractAddress) }
        isContract = size > 0;
    }

    function isContractOpenzeppelin(address contractAddress) external view returns(bool isContract) {
        isContract = contractAddress.isContract();
    }

    modifier noContractAddress(address addr) {
        require(!isContractAssembly(addr), "sorry no contractAddress allowed!");
        _;
    }

    function protectedNumber(address addr) external view noContractAddress(addr) returns(uint256 pNumber) { //https://ethereum.stackexchange.com/questions/54867/pass-parameter-to-access-modifier
        pNumber = 15;
    }
    // tx.origin could be used to prevent other contract call this contract --- http://web.archive.org/web/20200814122922/https://ethereum.stackexchange.com/questions/50238/tx-origin-to-block-contracts-from-call-my-game/50249#50249
}