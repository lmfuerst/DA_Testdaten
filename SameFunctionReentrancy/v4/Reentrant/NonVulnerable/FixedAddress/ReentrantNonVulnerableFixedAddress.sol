pragma solidity ^0.4.26;

contract Reentrancy {
    mapping(address => uint) public userRequests;
	address private receiver = address(0xBEeFbeefbEefbeEFbeEfbEEfBEeFbeEfBeEfBeef);

    function Reentrancy() payable {}

    function request() public {
        bool success = receiver.call("");
        require(success);
        userRequests[msg.sender] += 1;
    }

}