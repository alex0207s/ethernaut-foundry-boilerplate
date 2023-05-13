// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/07-Force/ForceFactory.sol";
import "src/levels/07-Force/AttackForce.sol";

contract ForceTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);
  
    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(hacker, 1 ether);
    }

    function testForceHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        ForceFactory forceFactory = new ForceFactory();
        ethernaut.registerLevel(forceFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(forceFactory);
        Force ethernautForce = Force(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        AttackForce attacker = new AttackForce();

        emit log_named_uint("victim contract balance before exploit", address(ethernautForce).balance);
        attacker.attack{value: 1 ether}(levelAddress);
        emit log_named_uint("victim contract balance after exploit", address(ethernautForce).balance);
        
        assertGt(address(ethernautForce).balance, 0 ether);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}