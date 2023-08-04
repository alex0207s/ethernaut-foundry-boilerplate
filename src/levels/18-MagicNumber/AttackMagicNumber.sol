// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttackMagicNumber {
    function deploy() external returns(address addr) {
        /*
        Run time code - return 42
        // 1. Store 42 to memory
        PUSH1 0x2a -> 602a
        PUSH1 0 -> 6000
        MSTORE -> 52

        // 2. Return 32 bytes from memory
        PUSH1 0x20 -> 6020
        PUSH1 0 -> 6000
        RETURN -> f3

        602a60005260206000f3

        Creation code - return runtime code
        // 1. Store run time code to memory
        PUSH10 0X602a60005260206000f3 -> 69602a60005260206000f3
        PUSH1 0 -> 6000
        MSTORE -> f3

        // 2. Return 10 bytes from memory starting at offset 22
        PUSH1 0x0a -> 600a
        PUSH1 0x16 -> 6016
        RETURN -> f3
        
        69602a60005260206000f3600052600a6016f3
        */
        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";
        
        assembly {
            // create(value, offset, size)
            addr := create(0, add(bytecode, 0x20), 0x13)
        }
        
        require(addr != address(0), "fail to create a contract");
    }
}