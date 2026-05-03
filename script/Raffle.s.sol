//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "./NetworkConfig.s.sol";
import {VRFCoordinatorV2Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2Mock.sol";

contract Deployment is Script{

    Raffle public rf;
    
    function run()public returns(Raffle){
        HelperConfig config = new HelperConfig(block.chainid);
        HelperConfig.NetworkConfig memory nc = config.getLocalChainNetworkConfig(block.chainid);

        vm.startBroadcast();
        nc.subId = VRFCoordinatorV2Mock(nc.coordinator).createSubscription();
        VRFCoordinatorV2Mock(nc.coordinator).fundSubscription(nc.subId, 10 ether);
        rf = new Raffle(nc.lotteryInterval, nc.coordinator, nc.subId);
        VRFCoordinatorV2Mock(nc.coordinator).addConsumer(nc.subId, address(rf));
        vm.stopBroadcast();

        return rf;
    }
}