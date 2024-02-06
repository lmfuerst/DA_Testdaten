// based on https://github.com/uni-due-syssec/eth-reentrancy-attack-patterns/blob/master/create-based.sol (Sereum researchers)
pragma solidity ^0.7.6;

abstract contract IntermediaryCallback {
    function registerIntermediary(address what) public virtual payable;
}

contract Intermediary {
    // this contract just holds the funds until the owner comes along and
    // withdraws them.

    Bank bank;
    address owner;
    uint amount;

    constructor(Bank _bank, address _owner, uint _amount) {
        bank = _bank;
        amount = _amount;
        owner = _owner;

        // this contract wants to register itself with its new owner, so it
        // calls the new owner (i.e. the attacker). This passes control to an
        // untrusted third-party contract.
        IntermediaryCallback(owner).registerIntermediary(address(this));
    }

    function withdraw() public {
        if (msg.sender == owner) {
            payable(msg.sender).transfer(amount);
        }
    }
    
    fallback() external payable {}
}

contract Bank {
    mapping (address => uint) balances;
    mapping (address => Intermediary) subs;

    function getBalance(address a) public view returns(uint) {
        return balances[a];
    }

    function withdraw(uint amount) public {
        if (balances[msg.sender] >= amount) {
            balances[msg.sender] -= amount;
            subs[msg.sender] = new Intermediary(this, msg.sender, amount);
            payable(address(subs[msg.sender])).transfer(amount);
        }
    }
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
}
