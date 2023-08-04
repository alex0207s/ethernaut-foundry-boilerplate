// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "src/core/Ethernaut-05.sol";
import "src/levels/19-AlienCodex/AlienCodexFactory.sol";
import "src/levels/19-AlienCodex/AttackAlienCodex.sol";

contract AlienCodexTest is DSTest {
    Ethernaut ethernaut;
    address hacker = address(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testAlienCodexHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        AlienCodexFactory alienCodexFactory = new AlienCodexFactory();
        ethernaut.registerLevel(alienCodexFactory);
        address levelAddress = ethernaut.createLevelInstance(alienCodexFactory);
        AlienCodex ethernautAlienCodex = AlienCodex(address(uint160(address(levelAddress))));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        AttackAlienCodex attacker = new AttackAlienCodex(ethernautAlienCodex);
        emit log_named_address("the owner of the victim contract before exploit", ethernautAlienCodex.owner());
        attacker.attack();
        emit log_named_address("the owner of the victim contract after exploit", ethernautAlienCodex.owner());

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
            address(uint160(address(levelAddress)))
        );
        assert(levelSuccessfullyPassed);
    }
}