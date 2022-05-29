pragma solidity ^0.8.0;

import "./Controller.sol";

contract SOTAReferral is Controller {
    mapping(address => address) public refs; //a use code of b -> refs[a] = b
    mapping(address => mapping(address => uint256)) public expTime;

    function setReferral(address[] memory _users, address[] memory _refs)
        public
        onlyOperator
    {
        require(_users.length == _refs.length, "Invalid-length");
        for (uint256 i = 0; i < _users.length; i++) {
            refs[_users[i]] = _refs[i];
        }
    }

    function getReferral(address _user) external view returns (address) {
        return refs[_user];
    }
}
