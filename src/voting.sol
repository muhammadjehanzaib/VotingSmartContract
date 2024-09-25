//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract VotingSystem {
    enum VotingState {
        END,
        START
    }

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    address[] public voters;
    mapping(address => bool) isVoterRegistered;
    mapping(address => bool) haveVoted;
    address public owner;
    VotingState public votingState;
    uint256 public votingStartTime;
    uint256 public votingEndTime;
    Candidate[] public candidate;
    string public winner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not owner.");
        _;
    }

    function voterRegistration() public {
        require(!isVoterRegistered[msg.sender], "Already Registered!");
        isVoterRegistered[msg.sender] = true;
        voters.push(msg.sender);
    }

    function addCandidate(string memory _name) public onlyOwner {
        Candidate memory newCandidate = Candidate(_name, 0);
        candidate.push(newCandidate);
    }

    function getTotalCandidates() public view returns (uint256) {
        return candidate.length;
    }

    function getCandidate(uint256 _index) public view returns (string memory, uint256) {
        require(_index < candidate.length, "Candidate doesn't exist!");
        return (candidate[_index].name, candidate[_index].voteCount);
    }

    function startVoting() public onlyOwner {
        votingState = VotingState.START;
        votingStartTime = block.timestamp;
    }

    function endVoting() public onlyOwner returns (string memory) {
        votingState = VotingState.END;
        votingEndTime = block.timestamp;
        uint256 winnerIndex = 0;
        uint256 maxVotes = 0;
        // for (uint256 i = 0; i < candidate.length; i++) {
        //     for (uint256 j = 0; j < candidate.length; j++) {
        //         if (candidate[i].voteCount > candidate[j].voteCount) {
        //             winnerIndex = i;
        //         }
        //     }
        // }

        for (uint256 i = 0; i < candidate.length; i++) {
            if (candidate[i].voteCount > maxVotes) {
                maxVotes = candidate[i].voteCount;
                winnerIndex = i;
            }
        }
        return candidate[winnerIndex].name;
    }

    function vote(uint256 _candidate) public {
        require(votingState == VotingState.START, "Voting isn't started yet!");
        require(
            isVoterRegistered[msg.sender] && !haveVoted[msg.sender], "You are not registered for vote Or already voted."
        );
        candidate[_candidate].voteCount += 1;
        haveVoted[msg.sender] = true;
    }
}
