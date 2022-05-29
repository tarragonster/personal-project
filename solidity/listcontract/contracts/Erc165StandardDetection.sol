// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

contract Erc165StandardDetection {
    function getIERC721UpInterfaceId()
        external
        pure
        returns (bytes4 interfaceId)
    {
        interfaceId = type(IERC721Upgradeable).interfaceId;
    }

    function getIERC1155UpInterfaceId()
        external
        pure
        returns (bytes4 interfaceId)
    {
        interfaceId = type(IERC1155Upgradeable).interfaceId;
    }

    function getIERC721UpAddressInterfaceId(address erc721Address) external view returns (bytes4 interfaceId, bool isErc721) {
        IERC721Upgradeable erc721Upgradeable  = IERC721Upgradeable(erc721Address);
        interfaceId = type(IERC721Upgradeable).interfaceId;
        isErc721 = erc721Upgradeable.supportsInterface(interfaceId);
    }
}

// Ref: https://eips.ethereum.org/EIPS/eip-165