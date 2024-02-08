pragma solidity ^0.5.17;

contract Reentrancy {
    mapping(address => uint) public userRequests;

    constructor() public payable {}

    function request() public {
        (bool success, ) = msg.sender.call("");
        require(success);
        userRequests[msg.sender] += 1;
    }

}
