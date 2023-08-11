// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/18-MagicNumber/MagicNumberFactory.sol";
import "src/levels/18-MagicNumber/AttackMagicNumber.sol";

contract MagicNumberTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testMagicNumberHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        MagicNumFactory magicNumFactory = new MagicNumFactory();
        ethernaut.registerLevel(magicNumFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(magicNumFactory);
        MagicNum ethernautMagicNumber = MagicNum(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        AttackMagicNumber attacker = new AttackMagicNumber();

        address solver = attacker.deploy();
        ethernautMagicNumber.setSolver(solver);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
