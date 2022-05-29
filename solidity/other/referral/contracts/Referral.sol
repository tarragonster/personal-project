// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

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
    mapping(address => address) private _referralData;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    function initialize(address _admin) public initializer { // Initializer modifier only allow this function run once
        __Referral_init(_admin);
    }

    function __Referral_init(address _admin) internal initializer {
        __Referral_init_unchained(_admin);
    }

    function __Referral_init_unchained(address _admin) internal initializer {
        _setupRole(ADMIN_ROLE, _admin);
    }

    modifier adminGuard() {
        require(hasRole(ADMIN_ROLE, _msgSender()), "must have admin role");
        _;
    }

    function setHuukMarket(address _marketAddress) public onlyOwner {
        huukMarket = _marketAddress;
    }

    function setReferral(address _user, address _ref)
    public
    onlyOwner
    returns (bool)
    {
        _referralData[_user] = _ref;
        return true;
    }

    function getReferral(address _user) public view returns (address) {
        if (_referralData[_user] == address(0)) {
            return huukMarket;
        }
        return _referralData[_user];
    }

    function _authorizeUpgrade(address newImplementation)
    internal
    override
    onlyOwner
    {}

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[48] private __gap;
}
