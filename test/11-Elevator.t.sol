// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/11-Elevator/ElevatorFactory.sol";
import "src/levels/11-Elevator/AttackElevator.sol";

contract ElevatorTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testElevatorHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        ElevatorFactory elevatorFactory = new ElevatorFactory();
        ethernaut.registerLevel(elevatorFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(elevatorFactory);
        Elevator ethernautElevator = Elevator(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        emit log_named_string("top floor already? (before exploit)", ethernautElevator.top() ? "true" : "false");

        AttackElevator attacker = new AttackElevator(ethernautElevator);        
        attacker.attack();

        emit log_named_string("top floor already? (after exploit)", ethernautElevator.top() ? "true" : "false");
        assertTrue(ethernautElevator.top());

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