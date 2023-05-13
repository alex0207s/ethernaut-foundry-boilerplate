// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/04-Telephone/TelephoneFactory.sol";
import "src/levels/04-Telephone/TelephoneAttack.sol";

contract TelephoneTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testTelephoneHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        TelephoneFactory telephoneFactory = new TelephoneFactory();
        ethernaut.registerLevel(telephoneFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(telephoneFactory);
        Telephone ethernautTelephone = Telephone(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        TelephoneAttack attacker = new TelephoneAttack(ethernautTelephone);
        
        emit log_named_address("hacker address", hacker);
        emit log_named_address("the owner of the victim contract before exploit", ethernautTelephone.owner());
        attacker.attack();
        emit log_named_address("the owner of the victim contract after exploit", ethernautTelephone.owner());
        
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