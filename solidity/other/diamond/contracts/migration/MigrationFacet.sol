// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./IMigrationFacet.sol";
import "../diamond/libraries/LibDiamond.sol";


contract MigrationFacet is IMigrationFacet {
    function migrateData(LibStruct.Migrate memory _input) external override returns (bool) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.totalOrders = _input.totalOrders;
        ds.totalBids = _input.totalBids;
        ds.huuk = _input.huuk;
        ds.referralContract = _input.referralContract;
        ds.huukExchangeContract = _input.huukExchangeContract;
        ds.profitSender = _input.profitSender;
        ds.xUser = _input.xUser;
        ds.xCreator = _input.xCreator;
        ds.yRefRate = _input.yRefRate;
        ds.zProfitToCreator = _input.zProfitToCreator;
        ds.discountForBuyer = _input.discountForBuyer;
        ds.discountForHuuk = _input.discountForHuuk;
        ds.xPremium = _input.xPremium;
        return true;
    }


    function migrateOrder(uint256 _id, LibStruct.Order memory _input, bool _isHuukNFT, bool _isHuukNFTPremiums) external returns (bool){
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.orders[_id] = _input;
        bytes32 id = keccak256(
            abi.encodePacked(_input.tokenAddress, _input.tokenId, _input.owner)
        );
        ds.orderID[id] = _id;
        if (_isHuukNFT) {
            ds.isHuukNFTs[_input.tokenAddress] = true;
        }
        if (_isHuukNFTPremiums) {
            ds.isHuukNFTPremiums[_input.tokenAddress] = true;
        }
        return true;
    }

//    function migrateBid(uint256 _id, LibStruct.Bid memory _input) external returns (bool){
//        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
//        ds.bids[_id] = _input;
//        return true;
//    }

}
