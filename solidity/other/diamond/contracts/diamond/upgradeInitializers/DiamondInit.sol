// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/******************************************************************************\
* Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
* EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
*
* Implementation of a diamond.
/******************************************************************************/

import {LibDiamond} from "../libraries/LibDiamond.sol";
import {IDiamondLoupe} from "../interfaces/IDiamondLoupe.sol";
import {IDiamondCut} from "../interfaces/IDiamondCut.sol";
import {IERC173} from "../interfaces/IERC173.sol";
import {IERC165} from "../interfaces/IERC165.sol";
import {IERC1155Holder} from "../interfaces/IERC1155Holder.sol";
import {IERC721Holder} from "../interfaces/IERC721Holder.sol";
import {IERC165} from "../interfaces/IERC165.sol";
import "../../huuk-market-2535/IHuukMarketFacet.sol";
import "../../huuk-market-2535/Operation/IOperation.sol";

// It is exapected that this contract is customized if you want to deploy your diamond
// with data from a deployment script. Use the init function to initialize state variables
// of your diamond. Add parameters to the init function if you need to.

contract DiamondInit {

    // You can add parameters to this function in order to pass in 
    // data to set your own state variables
    function init() external {
        // adding ERC165 data
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.supportedInterfaces[type(IERC165).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;
        ds.supportedInterfaces[type(IERC173).interfaceId] = true;
        ds.supportedInterfaces[type(IOperation).interfaceId] = true;
        ds.supportedInterfaces[type(IHuukMarketFacet).interfaceId] = true;
        ds.supportedInterfaces[type(IERC1155Holder).interfaceId] = true;
        ds.supportedInterfaces[type(IERC721Holder).interfaceId] = true;
        ds.supportedInterfaces[type(IHuukMarketFacet).interfaceId] = true;

        // *********** init *********
        ds._paused = false;


        // EIP712
        LibDiamond._EIP712_init("HuukMarket_name", "Market_version_1.0");
        // add your own state variables 
        // EIP-2535 specifies that the `diamondCut` function takes two optional 
        // arguments: address _init and bytes calldata _calldata
        // These arguments are used to execute an arbitrary function using delegatecall
        // in order to set state variables in the diamond during deployment or an upgrade
        // More info here: https://eips.ethereum.org/EIPS/eip-2535#diamond-interface 
    }


}