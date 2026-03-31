//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {Script} from "lib/forge-std/src/Script.sol";
import {Raffle} from "../src/Raffle.sol";

contract RaffleScript is Script{
    Raffle public raffle;
    function setUp()public{}

    function run()public{
        vm.startBroadcast();
        raffle = new Raffle(20, 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B);
        vm.stopBroadcast();
    }
    function deployRaffle()public view returns(Raffle){
        return raffle;
    }
}