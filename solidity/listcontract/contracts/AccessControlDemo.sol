// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract AccessControlDemo is
    Initializable,
    AccessControlEnumerableUpgradeable,
    UUPSUpgradeable
{
    bytes32 public constant VERIFIED_ROLE =
        keccak256(abi.encodePacked("VERIFIED_ROLE"));

    function initialize() public initializer {
        __AccessControlDemo_init();
    }

    function __AccessControlDemo_init() internal onlyInitializing {
        __AccessControlEnumerable_init_unchained();
        __AccessControlDemo_init_unchained();
        __UUPSUpgradeable_init_unchained();
    }

    function __AccessControlDemo_init_unchained() internal onlyInitializing {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function grantAdminRole(address _adminAddress)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _grantRole(DEFAULT_ADMIN_ROLE, _adminAddress);
    }

    function revokeAdminRole(address _adminAddress)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _revokeRole(DEFAULT_ADMIN_ROLE, _adminAddress);
    }

    function grantVerifiedUser(address _verifiedUser)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _grantRole(VERIFIED_ROLE, _verifiedUser);
    }

    function revokeVerifiedUser(address _verifiedUser)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _revokeRole(VERIFIED_ROLE, _verifiedUser);
    }

    function add(uint256 numA, uint256 numB)
        public
        view
        onlyRole(VERIFIED_ROLE)
        returns (uint256)
    {
        return numA + numB;
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        // Do something here.
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[45] private __gap;
}
