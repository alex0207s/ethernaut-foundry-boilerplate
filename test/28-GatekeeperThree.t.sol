// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/28-GatekeeperThree/GatekeeperThreeFactory.sol";
import "src/levels/28-GatekeeperThree/AttackGatekeeperThree.sol";

contract GatekeeperThreeTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = tx.origin;

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(hacker, 0.0011 ether);
    }

    function testGatekeeperThreeHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        GatekeeperThreeFactory gatekeeperThreeFactory = new GatekeeperThreeFactory();
        ethernaut.registerLevel(gatekeeperThreeFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(gatekeeperThreeFactory);
        GatekeeperThree ethernautGatekeeperThree = GatekeeperThree(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        emit log_named_address("the entrant of gatekeeper before exploit", ethernautGatekeeperThree.entrant());
        AttackGatekeeperThree attacker = new AttackGatekeeperThree(ethernautGatekeeperThree);
        attacker.attack{value: 0.0011 ether}();
        emit log_named_address("the entrant of gatekeeper after exploit", ethernautGatekeeperThree.entrant());

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