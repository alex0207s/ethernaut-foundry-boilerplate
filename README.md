# ethernaut-foundry-boilerplate

This repo is intended for beginners to play OpenZeppelin's [Ethernaut]('https://ethernaut.openzeppelin.com/') and write PoC (proof-of-concept) exploit codes with Foundry.

-   [x] Level01 Fallback
-   [x] Level02 Fallout
-   [x] Level03 Coin Flip
-   [x] Level04 Telephone
-   [x] Level05 Token
-   [x] Level06 Delegation
-   [x] Level07 Force
-   [x] Level08 Vault
-   [x] Level09 King
-   [x] Level10 Re-entrancy
-   [x] Level11 Elevator
-   [x] Level12 Privacy
-   [x] Level13 Gatekeeper One
-   [x] Level14 Gatekeeper Two
-   [x] Level15 Naught Coin
-   [x] Level16 Preservation
-   [x] Level17 Recovery
-   [x] Level18 MagicNumber
-   [x] Level19 Alien Codex
-   [x] Level20 Denial
-   [x] Level21 Shop
-   [x] Level22 Dex
-   [x] Level23 Dex Two
-   [x] Level24 Puzzle Wallet
-   [x] Level25 Motorbike
-   [x] Level26 DoubleEntryPoint
-   [x] Level27 Good Samaritan
-   [x] Level28 Gatekeeper Three
-   [x] Level29 Switch

## ~~Warnings - some challenges are removed due to compiler incompatibility~~

~~The following challenges are not part of this repo:~~

~~- [Alien Codex](https://ethernaut.openzeppelin.com/level/0x40055E69E7EB12620c8CCBCCAb1F187883301c30)~~

~~- [Motorbike](https://ethernaut.openzeppelin.com/level/0x9b261b23cE149422DE75907C6ac0C30cEc4e652A)~~

~~Those challenges rely on old version of solidity to showcase bugs/exploits. Therefore, we'll remove them to prevent compilation errors.~~

# Getting Started

## Install & Update Foundry

```sh
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

## Clone repo

```sh
git@github.com:alex0207s/ethernaut-foundry-boilerplate.git
cd ethernaut-foundry-boilerplate
forge install
```

## Create your own solutions

create a new test file `XX-<LevelName>.t.sol` in the `test/` directory. </br></br>Here's an example of a test contract for challenge 1 Fallback

```solidity
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/core/Ethernaut.sol";
import "src/levels/01-Fallback/FallbackFactory.sol";

contract FallbackTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address hacker = vm.addr(1); // generate the random address with given private key

    function setUp() public {
        ethernaut = new Ethernaut();

        // set hacker's balance to 1 Ether, use it when you need!
        // vm.deal(hacker, 1 ether);
    }

    function testFallbackHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        FallbackFactory fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
        vm.startPrank(hacker);
        address levelAddress = ethernaut.createLevelInstance(fallbackFactory);
        Fallback ethernautFallback = Fallback(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // implement your solution here

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
```

1. `setup()` function for initiating the main Ethernaut contract
2. `test<LevelName>Hack()` function for
    - Creating a level instance
    - Executing the attack logic to solve challenge
    - Submitting the solution and validating your result

</br>All you need to do is to implement your own PoC to solve the challenge in the **LEVEL ATTACK** block of `test<LevelName>Hack()` function. You are allowed to create a malicious contract to exploit vulnerable contracts if you need to.

## Run a Solution

```sh
forge test --match-contract <LevelName>Test -v
```

You can obtain more detailed information on the summary of passing and failing tests by using the -v flag to increase verbosity.

-   **Level 2 (`-vv`)**: Logs emitted during tests are also displayed. That includes assertion errors from tests, showing information such as expected vs actual.
-   **Level 3 (`-vvv`)**: Stack traces for failing tests are also displayed.
-   **Level 4 (`-vvvv`)**: Stack traces for all tests are displayed, and setup traces for failing tests are displayed.
-   **Level 5 (`-vvvvv`)**: Stack traces and setup traces are always displayed.

## Checkout my solution

I have placed the solutions of each challenge in the [solution](https://github.com/alex0207s/ethernaut-foundry-boilerplate/tree/solution) branch. You can access them with the following command:

```sh
git checkout -b solution origin/solution
```

</br>

# How To Set Up This Project

## Create a new Forge project

```sh
forge init ethernaut-foundry-boilerplate
```

## Install Libraries

```sh
forge install OpenZeppelin/openzeppelin-contracts
forge install openzeppelin-contracts-06=OpenZeppelin/openzeppelin-contracts@v3.4.0
```

## Remapping

Edit the `foundry.toml` file,

```toml
[profile.default]
src = 'src'
out = 'out'
libs = ['lib']
remappings = [
    'ds-test/=lib/forge-std/lib/ds-test/src/',
    'forge-std/=lib/forge-std/src/',
    'openzeppelin-contracts-06/=lib/openzeppelin-contracts-06/contracts/',
    'openzeppelin-contracts/=lib/openzeppelin-contracts/contracts/',
]

# See more config options https://github.com/foundry-rs/foundry/tree/master/config
```

Then run

```sh
forge remappings > remappings.txt
```

## Copy the Ethernaut contract into `/src` folder

Create `core` and `levels` folders under the `src/` to put the main logic contract and the challenge of Ethernaut

We add `Ethernaut-05.sol`, `Level-05.sol`, `Ethernaut-06.sol`, `Level-06.sol` for challenge 19 Alien Codex and challenge 25 Motorbike

```bash
└── src
   ├── core
   │   ├── Ethernaut-05.sol
   │   │
   │   ├── Level-05.sol
   │   │
   │   ├── Ethernaut-06.sol
   │   │
   │   ├── Level-06.sol
   │   │
   │   ├── Ethernaut.sol
   │   │
   │   └── Level.sol
   │
   └── levels
       └── XX-<LevelName>
            ├── <LevelName>.sol
            │
            └── <LevelName>Factory.sol
```

-   `/core`: it contains the six main logic contracts of the Ethernaut
    -   `Ethernaut.sol` token from [here](https://github.com/OpenZeppelin/ethernaut/blob/master/contracts/contracts/Ethernaut.sol). But we add return value for each function of `Ethernaut.sol`
    -   `Level.sol` token from [here](https://github.com/OpenZeppelin/ethernaut/blob/master/contracts/contracts/levels/base/Level.sol).
    -   `Ethernaut-05.sol` same from `Ethernaut.sol` but for supporting the challenge 19 Alien Codex
    -   `Level-05.sol` same from `Level.sol` but for supporting the challenge 19 Alien Codex
    -   `Ethernaut-06.sol` same from `Ethernaut.sol` but for supporting the challenge 25 Motorbike
    -   `Level-06.sol` same from `Level.sol` but for supporting the challenge 25 Motorbike

*   `/levels`: it contains the all levels of the Ethernaut. For each level is composed of two contracts and can be found from [here](https://github.com/OpenZeppelin/ethernaut/tree/master/contracts/contracts/levels):
    -   `<LevelName>.sol`
    -   `<LevelName>Factory.sol`
