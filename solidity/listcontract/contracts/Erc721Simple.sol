// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Erc721Simple is ERC721Upgradeable {
    function initialize(string memory name_, string memory symbol_)
        public
        initializer
    {
        __Erc721Simple_init(name_, symbol_);
    }

    function __Erc721Simple_init(string memory name_, string memory symbol_)
        internal
        onlyInitializing
    {
        __ERC721_init_unchained(name_, symbol_);
        __Erc721Simple_init_unchained();
    }

    function __Erc721Simple_init_unchained() internal onlyInitializing {}
}
// https://eips.ethereum.org/EIPS/eip-721