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

    function run()public{
        vm.startBroadcast();
            networkConfiguration = configContract.getNetworkConfig(block.chainid);
        vm.stopBroadcast();
    }
}