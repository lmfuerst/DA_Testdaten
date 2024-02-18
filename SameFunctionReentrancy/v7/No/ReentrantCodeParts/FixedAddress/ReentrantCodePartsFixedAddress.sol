pragma solidity ^0.7.6;

contract Reentrancy {
    mapping(address => bool) private userBalances;
    address payable private receiver = payable(address(0xBEeFbeefbEefbeEFbeEfbEEfBEeFbeEfBeEfBeef));
    bool public lock = false;

    constructor() payable {}

    modifier nonReentrant() {
        require(lock == false);
        lock = true;
        _;
        lock = false;
    }

    function withdrawBalance() public nonReentrant {
        require(!userBalances[msg.sender]);
        (bool success,) = receiver.call{value: 500000}("");
        require(success);
        userBalances[msg.sender] = true;
    }

}
