pragma solidity ^0.8.0;

contract MockSotaExchange {
    function estimateToUSDT(address _paymentToken, uint256 _paymentAmount)
        external
        returns (uint256)
    {
        return _paymentAmount / 2;
    }

    function estimateFromUSDT(address _paymentToken, uint256 _usdtAmount)
        external
        returns (uint256)
    {
        return _usdtAmount * 2;
    }
}
