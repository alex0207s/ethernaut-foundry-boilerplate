// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; //change from 0.6.0

import 'openzeppelin-contracts/utils/math/SafeMath.sol';

contract Fallout {
  
  using SafeMath for uint256;
  mapping (address => uint) allocations;
  address payable public owner;


  /* constructor */
  function Fal1out() public payable {
    owner = payable(msg.sender); // change msg.sender to be a payable address
    allocations[owner] = msg.value;
  }

  modifier onlyOwner {
	        require(
	            msg.sender == owner,
	            "caller is not the owner"
	        );
	        _;
	    }

  function allocate() public payable {
    allocations[msg.sender] = allocations[msg.sender].add(msg.value);
  }

  function sendAllocation(address payable allocator) public {
    require(allocations[allocator] > 0);
    allocator.transfer(allocations[allocator]);
  }

  function collectAllocations() public onlyOwner {
    payable(msg.sender).transfer(address(this).balance); // change msg.sender to be a payable address
  }

  function allocatorBalance(address allocator) public view returns (uint) {
    return allocations[allocator];
  }
}