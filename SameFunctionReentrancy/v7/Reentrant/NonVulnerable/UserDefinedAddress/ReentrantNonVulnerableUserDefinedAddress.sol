pragma solidity ^0.7.6;

contract Reentrancy {
    mapping(address => uint) public userRequests;

    constructor() payable {}

    function request() public {
        (bool success,) = msg.sender.call("");
        require(success);
        userRequests[msg.sender] += 1;
    }

}
