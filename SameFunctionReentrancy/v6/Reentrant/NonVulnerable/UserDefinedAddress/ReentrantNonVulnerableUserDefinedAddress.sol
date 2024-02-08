pragma solidity ^0.6.12;

contract Reentrancy {
    mapping(address => uint) public userRequests;

    constructor() public payable {}

    function request() public {
        (bool success,) = msg.sender.call("");
        require(success);
        userRequests[msg.sender] += 1;
    }

}
