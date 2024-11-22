// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Parent Contract
contract ParentContract {
    address public owner;

    // Constructor
    constructor() {
        owner = msg.sender; // Set contract creator as owner
    }

    // Public function to get owner
    function getOwner() public view returns (address) {
        return owner;
    }

    // Internal function to get balance of the owner
    function _getBalance() internal view returns (uint) {
        return owner.balance; // Return owner's balance
    }

    // Transfer ownership with error handling
    function transferOwnership(address newOwner) public {
        require(newOwner != address(0), "New owner address invalid");
        owner = newOwner;
    }
}

// Child Contract inheriting ParentContract
contract ChildContract is ParentContract {

    // Payable function to accept Ether
    function deposit() public payable {
        // Function to receive Ether
    }

    // Public function to show the owner's balance by calling the internal function
    function showOwnerBalance() public view returns (uint) {
        return _getBalance(); // Access internal function from the parent contract
    }

    // Struct to define a Person
    struct Person {
        string name;
        uint age;
    }

    // Mapping to associate an address with a Person
    mapping(address => Person) public people;

    // Function to add a person to the mapping
    function addPerson(string memory _name, uint _age) public {
        people[msg.sender] = Person(_name, _age);
    }

    // Enum to define Status with Active and Inactive
    enum Status { Active, Inactive }

    // Fixed-size array
    uint[5] public fixedArray = [1, 2, 3, 4, 5];

    // Dynamic array to store values
    uint[] public dynamicArray;

    // Special arrays (bytes and string)
    bytes public byteArray;
    string public textString = "Hello, Solidity";

    // Function to add to the dynamic array
    function addToArray(uint _value) public {
        dynamicArray.push(_value);
    }
}
