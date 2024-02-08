pragma solidity ^0.6.12;

contract Reentrancy {
    mapping(address => uint) public userRequests;
    address payable private receiver = payable(address(0xBEeFbeefbEefbeEFbeEfbEEfBEeFbeEfBeEfBeef));

    constructor() public payable {}

    function request() public {
        (bool success,) = receiver.call("");
        require(success);
        userRequests[msg.sender] += 1;
    }

}
