// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract GovernanceToken is ERC20Votes {
    constructor()
        ERC20("GovToken", "GOV")
        ERC20Permit("GovToken")
    {
        _mint(msg.sender, 1_000_000e18);
    }
}
