pragma solidity ^0.8.0;

contract Reentrancy {
    mapping(address => bool) public userCalled;
	uint public userRequests;
	address public winner;
	address payable private receiver = payable(address(0xBEeFbeefbEefbeEFbeEfbEEfBEeFbeEfBeEfBeef));

    constructor() payable {}

    function request() public {
		// the 100th address to call the contract wins
		require(userRequests < 100);
        require(!userCalled[msg.sender]);
		
        userRequests += 1;
		if (userRequests == 100) {
            (bool success,) = receiver.call("winner()");
			require(success);
			winner = msg.sender;
		} else {
			(bool success,) = receiver.call("loser()");
			require(success);
		}
        
        userCalled[msg.sender] = true;
    }

}