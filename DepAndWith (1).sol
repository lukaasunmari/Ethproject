// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract DepWithEthOnPolygon {

    mapping(address => uint) depositedAddresses;


    function deposit() public payable {
        require(msg.value > 0, "You can't deposit zero");
        require(msg.sender != address(0), "address not valid");

        (bool sent, ) = address(this).call{value: msg.value}("");

        require(sent, "Failed to send Ether");

        depositedAddresses[msg.sender] += msg.value; 
    }

    function withdraw(uint amount) public payable{

        require(amount <= depositedAddresses[msg.sender], "insufficient balance");

        depositedAddresses[msg.sender] -= amount; 

        (bool sent, ) = payable(msg.sender).call{value: amount}("");

        require(sent, "Failed to withdraw Ether");
    }

    function  getBalance() public view returns (uint) {
        return depositedAddresses[msg.sender];
    }

    receive() external payable {}
}