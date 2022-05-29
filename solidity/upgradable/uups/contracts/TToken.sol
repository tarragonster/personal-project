// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// inheriting UUPSUpgradeable to add 'upgradeTo' function
// inheriting UUPSUpgradeable must overwrite _authorizeUpgrade implement
contract TToken is Initializable, ERC20Upgradeable, UUPSUpgradeable, OwnableUpgradeable {
    function initialize() public initializer { // Initializer modifier only allow this function run once
        __ERC20_init("TToken", "TT"); // to use with initializable
        __Ownable_init(); // https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/access/OwnableUpgradeable.sol

        _mint(msg.sender, 10000000 * 10 ** decimals());
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {

    }
}

contract TTokenV2 is TToken {
    uint fee;

    function version() pure public returns (string memory) {
        return "V2!";
    }
}

contract TTokenV3 is TToken {
    uint tax;

    function version() pure public returns (string memory) {
        return "V3!";
    }
}