// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {Script} from "../lib/forge-std/src/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {NetworkConfig} from "./NetworkConfig.s.sol";
import {console} from "../lib/forge-std/src/console.sol";

contract RaffleScript is Script{
    NetworkConfig nc;
    Raffle rf;
    function setUp() public{
        nc = new NetworkConfig(block.chainid);
    }  

    function run() public returns(Raffle){
        NetworkConfig.NetworkConfiguration memory c = nc.getLocalChainConfiguration();
        vm.startBroadcast();
        rf = new Raffle(c.lotteryInterval, c.coordinator);
        vm.stopBroadcast();
        return rf;
    }
}