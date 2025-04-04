// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VaultWithTimelock {
    address public timelock;
    mapping(address => uint256) public balances;

    event Deposit(address indexed user, uint256 amount);
    event Recovered(address indexed from, address indexed to, uint256 amount);

    constructor(address _timelock) {
        timelock = _timelock;
    }

    modifier onlyTimelock() {
        require(msg.sender == timelock, "Not authorized");
        _;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function recover(address from, address to) external onlyTimelock {
        uint256 amount = balances[from];
        require(amount > 0, "Nothing to recover");

        balances[from] = 0;
        balances[to] += amount;

        emit Recovered(from, to, amount);
    }
}
