// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery_ {
    // Array to store addresses of participants
    address[] public participants;

    // Address of the contract manager
    address public manager;

    // Minimum amount required to enter the lottery
    uint public entryFee;

    // Constructor to initialize the manager and entry fee
    constructor(uint _entryFee) {
        manager = msg.sender; // Contract deployer is the manager
        entryFee = _entryFee; // Set entry fee (in wei)
    }

    // Modifier to restrict access to manager-only functions
    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    // Function for participants to enter the lottery
    function enterLottery() public payable {
        // Check if the entry fee is met
        require(msg.value >= entryFee, "Insufficient entry fee");

        // Add the participant's address to the array
        participants.push(msg.sender);
    }

    // Function to randomly pick a winner (manager-only)
    function pickWinner() public onlyManager {
        require(participants.length > 0, "No participants in the lottery");

        // Generate a pseudo-random number
        uint randomIndex = random() % participants.length;

        // Select the winner
        address winner = participants[randomIndex];

        // Transfer the prize pool to the winner
        payable(winner).transfer(address(this).balance);

        // Reset the lottery
        while (participants.length > 0) {
            participants.pop();
        }
    }

    // Helper function to generate a pseudo-random number
    function random() private view returns (uint) {
    return uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, participants)));
}



    // Function to get the list of participants
    function getParticipants() public view returns (address[] memory) {
        return participants;
    }

    // Function to get the contract's balance (prize pool)
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
