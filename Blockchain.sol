// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    // Variable Declaration
    address public manager;
    address payable[] public participants;

    constructor()
    {
        manager = msg.sender; //global variable -> it wil assign the address when deplyoed 
    }

    receive() external payable
    {   require(msg.value == 1 ether); // check weather the transferring ethers are 1 or not
        participants.push(payable(msg.sender)); // it will pay to the manager 
    }

    function getBalance() public view returns(uint)
    {   
        require(msg.sender == manager,"You are not the manager"); // it will check you are manager or not
        return address(this).balance; // it will check the Total balance
    }

    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
        // It will generate any Random number 
    }

    function selectWinner() public
    {
        require(msg.sender == manager); // check weather you are manager or not

        require(participants.length >=3); // checking that if number of participants are greater than 3

        uint r = random(); // generate the random value

        uint index = r%participants.length; // provide the winner index in participants array

        address payable winner = participants[index]; // it will give the address of the winner

        winner.transfer(getBalance()); // will transer all the winning money

        participants = new address payable[](0); // will make the participants array to zero
    }

}