// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface IOperation {
    function whiteListOperator(address _operator, bool _whitelist) external;

    function pause() external;

    function paused() external view returns (bool);

    function unPause() external;
}
