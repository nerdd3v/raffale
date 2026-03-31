//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {Script} from "lib/forge-std/src/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {NetworkConfig} from "./NetworkConfig.s.sol";

contract RaffleScript is Script{
    Raffle public raffle;
    NetworkConfig private configContract;
    NetworkConfig.forConstructor private networkConfiguration;
    function setup()public{
        configContract = new NetworkConfig();
    }

    function run()public returns(Raffle){
        vm.startBroadcast();
            networkConfiguration = configContract.getNetworkConfig(block.chainid);
            raffle = new Raffle({
                _lotteryInterval: networkConfiguration.lotteryInterval,
                _vrfCoordinator: networkConfiguration.coordinator
            });
        vm.stopBroadcast();
        return raffle;
    }
}