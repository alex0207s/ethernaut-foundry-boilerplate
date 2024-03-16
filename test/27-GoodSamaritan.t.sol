// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/27-GoodSamaritan/GoodSamaritanFactory.sol";
import "src/levels/27-GoodSamaritan/AttackGoodSamaritan.sol";

contract GoodSamaritanTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testGoodSamaritanHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        GoodSamaritanFactory goodSamaritanFactory = new GoodSamaritanFactory();
        ethernaut.registerLevel(goodSamaritanFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(goodSamaritanFactory);
        GoodSamaritan ethernautGoodSamaritan = GoodSamaritan(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        emit log_named_uint("hacker's balance before exploit", ethernautGoodSamaritan.coin().balances(hacker));
        AttackGoodSamaritan attacker = new AttackGoodSamaritan(ethernautGoodSamaritan);
        attacker.attack();
        emit log_named_uint("hacker's balance after exploit", ethernautGoodSamaritan.coin().balances(address(hacker)));

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
