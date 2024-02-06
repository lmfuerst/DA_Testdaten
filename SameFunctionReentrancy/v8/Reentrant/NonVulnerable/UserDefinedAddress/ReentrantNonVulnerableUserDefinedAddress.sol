pragma solidity ^0.8.0;

contract Reentrancy {
    mapping(address => uint) public userRequests;

    constructor() payable {}

    function request() public {
        (bool success,) = msg.sender.call("");
        require(success);
        userRequests[msg.sender] += 1;
    }

}