// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MerkleTree {
    bytes32[] public leaves; // Array of leaf hashes
    bytes32 public merkleRoot; // Store the Merkle root

    // Add new leaf (hashed) to the leaves array
    function addLeaf(string memory _leaf) public {
        leaves.push(keccak256(bytes(_leaf)));
    }

    // Function to construct the Merkle Tree and compute Merkle Root
    function generateMerkleRoot() public {
        require(leaves.length > 0, "No leaves available");
        uint n = leaves.length;
        bytes32[] memory currentLevel = leaves;

        // Continue hashing pairs of nodes until one hash (the root) remains
        while (n > 1) {
            uint nextLevelLength = n / 2;
            if (n % 2 == 1) {
                nextLevelLength++;
            }
            bytes32[] memory nextLevel = new bytes32[](nextLevelLength);
            
            // Hash pairs of nodes
            for (uint i = 0; i < n / 2; i++) {
                nextLevel[i] = keccak256(abi.encodePacked(currentLevel[2 * i], currentLevel[2 * i + 1]));
            }

            // If there is an odd number of elements, promote the last one
            if (n % 2 == 1) {
                nextLevel[nextLevelLength - 1] = currentLevel[n - 1];
            }

            // Move to the next level
            currentLevel = nextLevel;
            n = nextLevelLength;
        }

        // The final root hash
        merkleRoot = currentLevel[0];
    }

    // Verify whether a string is part of the Merkle Tree
    function verify(string memory leafString) public view returns (bool) {
        require(leaves.length > 0, "Merkle Tree not generated");

        bytes32 leaf = keccak256(bytes(leafString));
        uint index = findLeafIndex(leaf);
        require(index < leaves.length, "Leaf not found");

        bytes32 computedHash = leaf;
        uint n = leaves.length;
        bytes32[] memory currentLevel = leaves;

        // Recompute the Merkle root starting from the leaf
        while (n > 1) {
            uint nextLevelLength = n / 2;
            if (n % 2 == 1) {
                nextLevelLength++;
            }
            bytes32[] memory nextLevel = new bytes32[](nextLevelLength);

            for (uint i = 0; i < n / 2; i++) {
                bytes32 left = currentLevel[2 * i];
                bytes32 right = currentLevel[2 * i + 1];

                if (i == index / 2) {
                    computedHash = (index % 2 == 0)
                        ? keccak256(abi.encodePacked(computedHash, right))
                        : keccak256(abi.encodePacked(left, computedHash));
                }

                nextLevel[i] = keccak256(abi.encodePacked(left, right));
            }

            if (n % 2 == 1) {
                bytes32 last = currentLevel[n - 1];
                nextLevel[nextLevelLength - 1] = last;

                if (index == n - 1) {
                    computedHash = keccak256(abi.encodePacked(last));
                }
            }

            currentLevel = nextLevel;
            n = nextLevelLength;
            index = index / 2;
        }

        return computedHash == merkleRoot;
    }

    // Helper function to find the index of a leaf
    function findLeafIndex(bytes32 leaf) internal view returns (uint) {
        for (uint i = 0; i < leaves.length; i++) {
            if (leaves[i] == leaf) {
                return i;
            }
        }
        revert("Leaf not found");
    }
}
