// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "../libs/LibStruct.sol";

interface IMigrationFacet {
    function migrateData(LibStruct.Migrate memory _input) external returns (bool);
//    function migrateBid(uint256 _id, LibStruct.Bid memory _input) external returns (bool);
    function migrateOrder(uint256 _id, LibStruct.Order memory _input, bool _isHuukNFT,bool _isHuukNFTPremiums) external returns (bool);
}
