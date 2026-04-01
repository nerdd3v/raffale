//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {Script} from "lib/forge-std/src/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {NetworkConfig} from "./NetworkConfig.s.sol";

contract RaffleScript is Script{
    Raffle public raffle;
    
}