// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract MockERC20 is Initializable, ERC20BurnableUpgradeable, UUPSUpgradeable {
    uint256 private constant HARD_CAP = 100_000_000e18; // 100m token

    function initialize(string memory name_, string memory symbol_)
        public
        initializer
    {
        __MockERC20_init(name_, symbol_);
    }

    function __MockERC20_init(string memory name_, string memory symbol_)
        internal
        onlyInitializing
    {
        __ERC20_init(name_, symbol_);
        __ERC20Burnable_init();
        __MockERC20_init_unchained();
    }

    function __MockERC20_init_unchained() internal onlyInitializing {
        _mint(msg.sender, HARD_CAP);
    }

    function _authorizeUpgrade(address newImplementation) internal override {
        // Do something here.
    }

    uint256[50] private __gap;
}
