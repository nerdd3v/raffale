//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {Script} from "lib/forge-std/src/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {NetworkConfig} from "./NetworkConfig.s.sol";

contract RaffleScript is Script{
    Raffle public raffle;
    NetworkConfig.Network private config;

    function setUp()public{
        NetworkConfig nc = new NetworkConfig();
        config = nc.getNetworkConfig(block.chainid);
    }

    function run()public{
        vm.startBroadcast();
        raffle = new Raffle(20, config.coordinatorContract);
        vm.stopBroadcast();
    }
    function deployRaffle()public view returns(Raffle){
        return raffle;
    }
}