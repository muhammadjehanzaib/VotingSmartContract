//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {VotingSystem} from "../src/voting.sol";

contract DeployVoting is Script {
    VotingSystem public votingSystem;

    function run() external returns (VotingSystem) {
        vm.startBroadcast();
        votingSystem = new VotingSystem();
        vm.stopBroadcast();
        return votingSystem;
    }
}
