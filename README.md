
# Voting System Smart Contract

## Overview

This Solidity smart contract implements a basic voting system that allows users to register, vote for candidates, and determine the winner at the end of the voting period. The owner of the contract can start and end the voting process, while voters can register themselves and cast votes.

## Features

- **Voter Registration**: Users can register as voters.
- **Candidate Management**: The owner can add candidates for the election.
- **Voting Process**: Voting can be started and ended by the owner.
- **Voting**: Registered voters can vote for a candidate, but only once.
- **Result Declaration**: After the voting ends, the winner is declared based on the candidate with the highest votes.

## Functions

1. **voterRegistration()**
   - Allows users to register as voters.
   - Requires that the user hasn’t already registered.
   - Adds the user to the list of voters.

2. **addCandidate(string memory _name)**
   - Only the contract owner can add candidates.
   - Requires a name for the candidate.

3. **getTotalCandidates()**
   - Returns the total number of candidates.

4. **getCandidate(uint256 _index)**
   - Returns the name and vote count of a candidate by index.
   - Requires a valid candidate index.

5. **startVoting()**
   - Only the contract owner can start the voting process.
   - Records the start time of the voting process.

6. **endVoting()**
   - Only the contract owner can end the voting process.
   - Declares the winner based on the candidate with the highest vote count.

7. **vote(uint256 _candidateIndex)**
   - Allows registered users to vote for a candidate by their index.
   - Requires the user to be registered and not have voted yet.
   - The candidate must exist.

## Installation

1. **Prerequisites**
   - Install [Foundry](https://book.getfoundry.sh/getting-started/installation).

2. **Cloning the Repo**
   Clone the project repository and navigate into it:
   ```bash
   git clone https://github.com/your/repository.git
   cd repository
   ```

3. **Build the Project**
   After navigating into the project directory, run:
   ```bash
   forge build
   ```

4. **Deploying the Contract (Optional)**
   You can use a local Ethereum environment such as Anvil, which is included in Foundry, or a testnet like Goerli.

   - **Start Anvil (Local Blockchain)**:
     ```bash
     anvil
     ```

   - **Deploy the Contract**:
     Create a `script/Deploy.s.sol` file and add:
     ```solidity
     // SPDX-License-Identifier: MIT
     pragma solidity 0.8.19;

     import "forge-std/Script.sol";
     import "../src/VotingSystem.sol";

     contract DeployVotingSystem is Script {
         function run() external {
             vm.startBroadcast();
             new VotingSystem();
             vm.stopBroadcast();
         }
     }
     ```

     Run the deploy script:
     ```bash
     forge script script/Deploy.s.sol --fork-url http://localhost:8545 --broadcast
     ```

## How to Use

1. **Register as a Voter**:
   Call the `voterRegistration` function to register the sender as a voter.
   ```solidity
   VotingSystem.voterRegistration()
   ```

2. **Add Candidates (Only Owner)**:
   Call the `addCandidate` function to add a candidate. This function can only be called by the contract owner.
   ```solidity
   VotingSystem.addCandidate("Alice")
   ```

3. **Start Voting (Only Owner)**:
   Start the voting process by calling the `startVoting` function.
   ```solidity
   VotingSystem.startVoting()
   ```

4. **Cast a Vote**:
   After the voting process has started, registered voters can vote by calling the `vote` function, passing the index of the candidate they want to vote for.
   ```solidity
   VotingSystem.vote(0) // Voting for the first candidate
   ```

5. **End Voting and Declare the Winner (Only Owner)**:
   Once voting has ended, the owner can call the `endVoting` function, which calculates and returns the name of the candidate with the highest votes.
   ```solidity
   VotingSystem.endVoting()
   ```

## Testing

- To run tests, you can write your test cases in the `test` folder.
- You can run all tests with:
  ```bash
  forge test
  ```

## Future Improvements

- Implement time-based restrictions for voting start and end.
- Add role-based access control for better security.
- Emit events for important actions such as candidate addition, voting, and result declaration.

## License

This project is licensed under the MIT License.
