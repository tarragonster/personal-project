// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibDiamond } from "../libraries/LibDiamond.sol";
import "../interfaces/IERC721Holder.sol";

contract ERC721HolderFacet is IERC721Holder {
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    )  external override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
