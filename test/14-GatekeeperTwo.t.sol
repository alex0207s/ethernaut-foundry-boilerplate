// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/14-GatekeeperTwo/GatekeeperTwoFactory.sol";
import "src/levels/14-GatekeeperTwo/AttackGatekeeperTwo.sol";


contract GatekeeperTwoTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testGatekeeperTwoHack() public {    
        /////////////////
        // LEVEL SETUP //
        /////////////////
        GatekeeperTwoFactory gatekeeperTwoFactory = new GatekeeperTwoFactory();
        ethernaut.registerLevel(gatekeeperTwoFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(gatekeeperTwoFactory);
        GatekeeperTwo ethernautGatekeeperTwo = GatekeeperTwo(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        emit log_named_address("entrant address before exploit", ethernautGatekeeperTwo.entrant());
        AttackGatekeeperTwo attacker = new AttackGatekeeperTwo(ethernautGatekeeperTwo);
        emit log_named_address("entrant address after exploit", ethernautGatekeeperTwo.entrant());
        assertEq(ethernautGatekeeperTwo.entrant(), tx.origin, "entrant address is not equal to tx.origin");

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