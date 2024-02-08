pragma solidity ^0.4.26;

contract Reentrancy {
    mapping(address => uint) public userRequests;

    function Reentrancy() payable {}

    function request() public {
        bool success = msg.sender.call("");
        require(success);
        userRequests[msg.sender] += 1;
    }

}
