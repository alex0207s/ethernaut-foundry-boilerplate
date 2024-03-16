// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/24-PuzzleWallet/PuzzleWalletFactory.sol";
import "src/levels/24-PuzzleWallet/AttackPuzzleWallet.sol";

contract PuzzleWalletTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(hacker, 0.002 ether);
    }

    function testPuzzleWalletHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        PuzzleWalletFactory puzzleWalletFactory = new PuzzleWalletFactory();
        ethernaut.registerLevel(puzzleWalletFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance{value: 0.001 ether}(puzzleWalletFactory);
        PuzzleProxy ethernautPuzzleProxy = PuzzleProxy(payable(levelAddress));
        PuzzleWallet puzzleWallet = PuzzleWallet(levelAddress);

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        AttackPuzzleWallet attacker = new AttackPuzzleWallet(ethernautPuzzleProxy, puzzleWallet);

        emit log_named_address("wallet owner before exploit:", puzzleWallet.owner());
        attacker.attack{value: 0.001 ether}();
        emit log_named_address("wallet owner after exploit:", puzzleWallet.owner());

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
