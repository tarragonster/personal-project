
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract HuukReferral is Initializable, OwnableUpgradeable, UUPSUpgradeable, AccessControlUpgradeable {

    mapping(address => address) public refs; //a use code of b -> refs[a] = b

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    function initialize() public initializer {
        // Initializer modifier only allow this function run once
        __Referral_init();
    }

    function __Referral_init() internal initializer {
        __Referral_init_unchained();
    }

    function __Referral_init_unchained() internal initializer {
        _setupRole(ADMIN_ROLE, _msgSender());
    }

    modifier adminGuard() {
        require(hasRole(ADMIN_ROLE, _msgSender()), "must have admin role");
        _;
    }

    function setReferral(address[] memory _users, address[] memory _refs)
    public
    adminGuard
    {
        require(_users.length == _refs.length, 'Invalid-length');
        for (uint256 i = 0; i < _users.length; i++) {
            refs[_users[i]] = _refs[i];
        }
    }

    function getReferral(address _user) public view returns (address) {
        return refs[_user];
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