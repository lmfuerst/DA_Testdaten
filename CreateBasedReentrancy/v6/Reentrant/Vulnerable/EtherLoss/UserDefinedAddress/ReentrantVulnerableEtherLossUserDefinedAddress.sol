// based on https://github.com/uni-due-syssec/eth-reentrancy-attack-patterns/blob/master/create-based.sol (Sereum researchers)
pragma solidity ^0.6.12;

abstract contract IntermediaryCallback {
    function registerIntermediary(address what) public virtual payable;
}

contract Intermediary {
    // this contract just holds the funds until the owner comes along and
    // withdraws them.

    address owner;
    Bank bank;
    uint amount;

    constructor(Bank _bank, address _owner, uint _amount) public {
        owner = _owner;
        bank = _bank;
        amount = _amount;

        // this contract wants to register itself with its new owner, so it
        // calls the new owner (i.e. the attacker). This passes control to an
        // untrusted third-party contract.
        IntermediaryCallback(_owner).registerIntermediary(address(this));
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
            // The new keyword creates a new contract (in this case of type
            // Intermediary). This is implemented on the EVM level with the CREATE
            // instruction. CREATE immediately runs the constructor of the
            // contract. i.e this must be seen as an external call to another
            // contract.
            // Even though the contract can be considered "trusted", it can
            // perform further problematic actions (e.g. more external calls)
            subs[msg.sender] = new Intermediary(this, msg.sender, amount);
            // state update **after** the CREATE
            balances[msg.sender] -= amount;
            payable(address(subs[msg.sender])).transfer(amount);
        }
    }
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
}
