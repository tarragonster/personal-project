// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "../interfaces/IHuukReferral.sol";
import "../interfaces/IHuukExchange.sol";
import "./LibStruct.sol";

library LibFunc {
    function getRefData(address _referralContract, address _user)
        internal
        view
        returns (address payable)
    {
        address payable userRef = IHuukReferral(_referralContract).getReferral(
            _user
        );
        return userRef;
    }

    function getERC1155Data() public pure returns (bytes memory) {
        return
            abi.encodePacked(
                keccak256(
                    "onERC1155Received(address,address,uint256,uint256,bytes)"
                )
            );
    }

    function getTokenUnique(LibStruct.Token memory _token)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_token.token, _token.id));
    }

    function getOrderUnique(LibStruct.Order memory _order)
        internal
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked(
                    _order.tokenAddress,
                    _order.tokenId,
                    _order.owner
                )
            );
    }

    function estimateUSDT(
        address _exchangeContract,
        address _paymentToken,
        uint256 _paymentAmount
    ) internal view returns (uint256) {
        return
            IHuukExchange(_exchangeContract).estimateToUSDT(
                _paymentToken,
                _paymentAmount
            );
    }

    function estimateToken(
        address _exchangeContract,
        address _paymentToken,
        uint256 _usdtAmount
    ) internal view returns (uint256) {
        return
            IHuukExchange(_exchangeContract).estimateFromUSDT(
                _paymentToken,
                _usdtAmount
            );
    }
}
