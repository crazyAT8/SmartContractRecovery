// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RecoverableERC20Wrapper is ERC20Burnable, Ownable {
    IERC20 public immutable underlyingToken;

    event Wrapped(address indexed user, uint256 amount);
    event Unwrapped(address indexed user, uint256 amount);
    event Recovered(address indexed from, address indexed to, uint256 amount);

    constructor(IERC20 _underlying) ERC20("Wrapped Token", "wTOKEN") {
        underlyingToken = _underlying;
    }

    // Wrap original token and mint wTOKEN
    function wrap(uint256 amount) external {
        require(underlyingToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        _mint(msg.sender, amount);
        emit Wrapped(msg.sender, amount);
    }

    // Burn wTOKEN and return original token
    function unwrap(uint256 amount) external {
        _burn(msg.sender, amount);
        require(underlyingToken.transfer(msg.sender, amount), "Transfer failed");
        emit Unwrapped(msg.sender, amount);
    }

    // DAO or trusted admin can recover tokens
    function recover(address from, address to, uint256 amount) external onlyOwner {
        _burn(from, amount);
        _mint(to, amount);
        emit Recovered(from, to, amount);
    }
}
