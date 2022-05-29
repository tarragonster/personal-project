import "../Referral.sol";

contract Referralv3 is Referral {
    address public adminv2;

    function version() pure public returns (string memory) {
        return "V3!";
    }
}