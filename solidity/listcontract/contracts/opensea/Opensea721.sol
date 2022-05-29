// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

pragma solidity ^0.8;

contract Opensea721 is ERC721, Ownable {
    constructor() ERC721("MyToken", "MTK") {}

    function mintToken(address player, uint256 tokenId) public {
        _mint(player, tokenId);
    }

    function changeTokenName(string memory name, string memory symbol) public {
        ERC721(name, symbol);
    }
}