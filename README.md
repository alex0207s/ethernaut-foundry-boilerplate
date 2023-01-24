# ethernaut-foundry-boilerplate

This repo is intended for beginners to play OpenZeppelin's [Ethernaut]('https://ethernaut.openzeppelin.com/') and write PoC (proof-of-concept) exploit codes with Foundry.

## Warnings - some challenges are removed due to compiler incompatibility

The following challenges are not part of this repo:

- [Alien Codex](https://ethernaut.openzeppelin.com/level/0x40055E69E7EB12620c8CCBCCAb1F187883301c30)
- [Motorbike](https://ethernaut.openzeppelin.com/level/0x9b261b23cE149422DE75907C6ac0C30cEc4e652A)

Those challenges rely on old version of solidity to showcase bugs/exploits. Therefore, we'll remove them to prevent compilation errors.

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
```

## Create your own solutions

Create a new test `XX-<LevelName>.t.sol` in the `test/` directory. </br></br>All of the test contract will follow the same template:

1. `setup()` function for initiating the main Ethernaut contract
2. `test<LevelName>Hack()` function for
   - Create a level instance
   - Execute the attack logic to solve challenge
   - Submit the solution and validate your result

Here's an example of a test contract

```solidity
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "src/levels/01-Fallback/FallbackFactory.sol";
import "src/core/Ethernaut.sol";

contract FallbackTest is DSTest {
    Vm vm = Vm(address(HEVM_ADDRESS));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 1 ether);
    }

    function testFallbackHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        FallbackFactory fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(fallbackFactory);
        Fallback ethernautFallback = Fallback(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // code the attack logic here

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

</br>All you need to do is to implement the attack logic to solve the challenge in the LEVEL ATTACK block of `test<LevelName>Hack()` function. You're allowed to create another attack contract if you needed.

## Run a Solution

```sh
forge test --match-contract <LevelName>Test -v
```

You can obtain more detailed information on the summary of passing and failing tests by using the -v flag to increase verbosity.

- **Level 2 (`-vv`)**: Logs emitted during tests are also displayed. That includes assertion errors from tests, showing information such as expected vs actual.
- **Level 3 (`-vvv`)**: Stack traces for failing tests are also displayed.
- **Level 4 (`-vvvv`)**: Stack traces for all tests are displayed, and setup traces for failing tests are displayed.
- **Level 5 (`-vvvvv`)**: Stack traces and setup traces are always displayed.

</br>

# How To Set Up This Project

## Create a new Forge project

```sh
forge init ethernaut-foundry-boilerplate
```

## Install libraries

```sh
forge install OpenZeppelin/openzeppelin-contracts
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
    'openzeppelin-contracts/=lib/openzeppelin-contracts/contracts/',
]

# See more config options https://github.com/foundry-rs/foundry/tree/master/config
```

then run

```sh
forge remappings > remappings.txt
```

## Copy the Ethernaut contract into `/src` folder

Create `core` and `levels` folders under the `src/` to put the main logic contract and the challenge of Ethernaut

```bash
└── src
   ├── core
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

- `/core`: it contains the two main logic contracts of the Ethernaut
  - `Ethernaut.sol` token from [here](https://github.com/OpenZeppelin/ethernaut/blob/master/contracts/contracts/Ethernaut.sol). But we add return value for each function of `Ethernaut.sol`
  - `Level.sol` token from [here](https://github.com/OpenZeppelin/ethernaut/blob/master/contracts/contracts/levels/base/Level.sol).

* `/levels`: it contains the all levels of the Ethernaut. For each level is composed of two contracts and can be found from [here](https://github.com/OpenZeppelin/ethernaut/tree/master/contracts/contracts/levels):
  - `<LevelName>.sol`
  - `<LevelName>Factory.sol`
