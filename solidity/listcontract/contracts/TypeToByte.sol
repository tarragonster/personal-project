// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

contract TypeToByte {
    function uint16ToDecimal() public pure returns (uint16) {
        return type(uint16).max;
        // 65535
    }

    function uint16ToByte() public pure returns (bytes memory) {
        return abi.encodePacked(type(uint16).max); //convert everything into bytes
        // 0xffff
    }

    function uint16ToHashByte32() public pure returns (bytes32) {
        return keccak256(abi.encodePacked(type(uint16).max)); // take bytes as input and convert to bytes32 hash
    }

    //START encode and encodepacked
    // input "AAA"-"BBB" & "AA"-"ABBB" -> demo collision
    function encode(string memory textA, string memory textB)
        public
        pure
        returns (bytes memory)
    {
        return abi.encode(textA, textB); // encode data into bytes
    }

    function encodePacked(string memory textA, string memory textB)
        public
        pure
        returns (bytes memory)
    {
        return abi.encodePacked(textA, textB); // encode data into bytes and compress it
    }

    function decode(bytes memory encodedText) public pure returns (string memory textA, string memory textB) {
        (textA,  textB) = abi.decode(encodedText, (string, string)); // can not decode abi.encodePacked(arg);
    }

    function collision(string memory textA, string memory textB)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(textA, textB)); // yield same result for "AAA"-"BBB" & "AA"-"ABBB"
    }

    function resolveCollision(
        string memory textA,
        uint256 numA,
        string memory textB
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(textA, numA, textB)); // yield different result for "AAA"-"12"-"BBB" & "AA"-"12"-"ABBB"
        // should include different type in between input to avoid collision
    }

    //END encode and encodepacked
}
