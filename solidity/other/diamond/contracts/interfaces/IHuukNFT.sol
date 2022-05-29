// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface IHuukNFT {
    function getCreator(uint256 _id) external view returns (address);

    function getRoyaltyFee(uint256 _id) external view returns (uint256);
}

interface IHuuk721 is IHuukNFT {
    function create(
        address _owner,
        string calldata _tokenURI,
        uint256 _royaltyFee,
        uint256 _nonce,
        bytes calldata _signature
    ) external returns (uint256 tokenId);
}

interface IHuuk1155 is IHuukNFT {
    function create(
        address _owner,
        uint256 _maxSupply,
        uint256 _initialSupply,
        uint256 _royaltyFee,
        string memory _uri,
        bytes memory _data,
        uint256 _nonce,
        bytes memory _signature
    ) external returns (uint256 tokenId);
}
