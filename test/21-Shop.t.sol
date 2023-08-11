// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/21-Shop/ShopFactory.sol";
import "src/levels/21-Shop/AttackShop.sol";

contract ShopTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testShopHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        ShopFactory shopFactory = new ShopFactory();
        ethernaut.registerLevel(shopFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(shopFactory);
        Shop ethernautShop = Shop(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        AttackBuyer attacker = new AttackBuyer(ethernautShop);
        emit log_named_uint("the price before exploit", ethernautShop.price());
        attacker.attack();
        emit log_named_uint("the price after exploit", ethernautShop.price());

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
