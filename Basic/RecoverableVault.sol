// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RecoverableVault {
    address public admin;
    mapping(address => uint256) public balances;

    event Deposit(address indexed user, uint256 amount);
    event Recovered(address indexed from, address indexed to, uint256 amount);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    // Emergency recovery function
    function recover(address from, address to) external onlyAdmin {
        uint256 amount = balances[from];
        require(amount > 0, "No funds to recover");

        balances[from] = 0;
        balances[to] += amount;

        emit Recovered(from, to, amount);
    }

    // Optional: Change admin (e.g., to a multisig later)
    function setAdmin(address newAdmin) external onlyAdmin {
        admin = newAdmin;
    }
}
