// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract TToken is ERC20 {
    constructor() ERC20("WBNB", "WBNB") {
        _mint(msg.sender, 10000000 * 10 ** decimals());
    }
}