//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {DeployVoting} from "../script/voting.s.sol";
import {VotingSystem} from "../src/voting.sol";
import {Test} from "forge-std/Test.sol";

contract TestVotingSystem is Test {
    DeployVoting public deployVoitng;
    VotingSystem public votingSystem;
    address public voter = makeAddr("voter");
    address public voter1 = makeAddr("voter1");
    address public voter2 = makeAddr("voter2");

    function setUp() external {
        deployVoitng = new DeployVoting();
        // vm.prank(voter);
        votingSystem = deployVoitng.run();
    }

    function testStartVoting() public {
        vm.prank(msg.sender);
        votingSystem.startVoting();

        assert(votingSystem.votingStartTime() > 0);
        assert(votingSystem.votingState() == VotingSystem.VotingState.START);
    }

    function testVoterRegistrationAndVote() public {
        //Arrange
        vm.startPrank(msg.sender);
        votingSystem.addCandidate("Ali");
        votingSystem.addCandidate("Wali");
        votingSystem.startVoting();
        vm.stopPrank();
        //Act
        vm.startPrank(voter);
        votingSystem.voterRegistration();
        votingSystem.vote(0);
        vm.stopPrank();

        vm.startPrank(voter1);
        votingSystem.voterRegistration();
        votingSystem.vote(1);
        vm.stopPrank();

        vm.startPrank(voter2);
        votingSystem.voterRegistration();
        votingSystem.vote(0);
        vm.stopPrank();

        //Assert
        assert(votingSystem.votingState() == VotingSystem.VotingState.START);
        // Decompose the tuple returned by candidate()
        (, uint256 voteCount) = votingSystem.candidate(0);
        (, uint256 voteCount1) = votingSystem.candidate(1);

        assert(voteCount == 2);
        vm.expectRevert();
        assert(voteCount1 == 2);
        assert(voteCount1 == 1);
    }

    function testCheckWinner() public {
        //Arrange
        vm.startPrank(msg.sender);
        votingSystem.addCandidate("Ali");
        votingSystem.addCandidate("Wali");
        votingSystem.startVoting();
        vm.stopPrank();
        //Act
        vm.startPrank(voter);
        votingSystem.voterRegistration();
        votingSystem.vote(0);
        vm.stopPrank();

        vm.startPrank(voter1);
        votingSystem.voterRegistration();
        votingSystem.vote(1);
        vm.stopPrank();

        vm.startPrank(voter2);
        votingSystem.voterRegistration();
        votingSystem.vote(0);
        vm.stopPrank();

        // Assert 

        vm.prank(msg.sender);
        string memory winner = votingSystem.endVoting();

        assert(keccak256(abi.encodePacked(winner)) == keccak256(abi.encodePacked("Ali")));

    }
}
