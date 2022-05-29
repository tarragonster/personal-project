// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract Referral is
    Initializable,
    OwnableUpgradeable,
    AccessControlUpgradeable,
    PausableUpgradeable,
    UUPSUpgradeable
{
    using AddressUpgradeable for address;
    using StringsUpgradeable for uint256;

    address public huukMarket;
    mapping(address => address) private referralData;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    function initialize(address _admin) public initializer { // Initializer modifier only allow this function run once
        __Referral_init(_admin);

    }

    function __Referral_init(address _admin) internal initializer {
        __Ownable_init_unchained();
        __Pausable_init_unchained();
        __AccessControl_init_unchained();
        __Referral_init_unchained(_admin);
    }

    function __Referral_init_unchained(address _admin) internal initializer {
        _setupRole(ADMIN_ROLE, _msgSender());
    }

    modifier adminGuard() {
        require(hasRole(ADMIN_ROLE, _msgSender()), "must have admin role");
        _;
    }

    function _authorizeUpgrade(address newImplementation) internal override adminGuard {}

    function pause() public virtual adminGuard {
        _pause();
    }

    function unpause() public virtual adminGuard {
        _unpause();
    }


    function setHuukMarket(address _marketAddress) public adminGuard {
        huukMarket = _marketAddress;
    }

    function setReferral(address _user, address _ref) public adminGuard returns(bool){
        referralData[_user] = _ref;
        return true;
    }

    function getReferral(address _user) public view returns(address){
        if (referralData[_user] == address (0)) {
            return huukMarket;
        }
        return referralData[_user];
    }
}