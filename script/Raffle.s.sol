// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {Script} from "../lib/forge-std/src/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {NetworkConfig} from "./NetworkConfig.s.sol";
import {console} from "../lib/forge-std/src/console.sol";

contract RaffleSript is Script{
    function setUp() public{
        Raffle rf;
    }

    function run() public {
        NetworkConfig nc = new NetworkConfig(block.chainid);
        NetworkConfig.NetworkConfiguration memory c = nc.getLocalChainConfiguration();

        console.log(c.coordinator);
    }
}