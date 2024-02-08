pragma solidity ^0.5.17;

contract Reentrancy {
    mapping(address => uint) public userRequests;
    address payable private receiver = address(0xBEeFbeefbEefbeEFbeEfbEEfBEeFbeEfBeEfBeef);

    constructor() public payable {}

    function request() public {
        (bool success, ) = receiver.call("");
        require(success);
        userRequests[msg.sender] += 1;
    }

}
