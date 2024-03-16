// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./DoubleEntryPoint.sol";

contract DetectionBot is IDetectionBot {
    address immutable cryptoVault;

    constructor(address _cryptoVault) {
        cryptoVault = _cryptoVault;
    }

    function handleTransaction(address user, bytes calldata msgData) external {
        // skip the first 4 bytes, because it's a function signatures
        (,, address originSender) = abi.decode(msgData[4:], (address, uint256, address));

        // prevent anyone from transferring the underlying token out of the vault
        if (originSender == cryptoVault) {
            IForta(msg.sender).raiseAlert(user);
        }
    }
}
