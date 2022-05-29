pragma solidity ^0.8;

contract TestSimple {
    mapping(uint256 => Test) public tests;
    uint256 count = 0;

    struct Test {
        address text1;
        address text2;
        bool boolparam;
    }

    function creatTest(address test1, address test2) public {
        uint256 current_count = count++;
        Test memory test = Test({
            text1: test1,
            text2: test2,
            boolparam: false
        });
        tests[current_count] = test;
    }

    function getText1(uint256 num) public view returns(uint256) {
        uint256 track;
        if(tests[num].text1 != tests[num].text2) {
            track = 1;
        } else {
            track = 2;
        }

        return track;
    }
}