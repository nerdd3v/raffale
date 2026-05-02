//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "./NetworkConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract Deployment is Script{

    Raffle public rf;
    
    function run()public {
        HelperConfig config = new HelperConfig(block.chainid);
        HelperConfig.NetworkConfig memory nc = config.getLocalChainNetworkConfig(block.chainid);

        // vm.startBroadcast();
        nc.subId = VRFCoordinatorV2_5Mock(nc.coordinator).createSubscription();
        VRFCoordinatorV2_5Mock(nc.coordinator).fundSubscription(nc.subId, 100 ether);
        rf = new Raffle(nc.lotteryInterval, nc.coordinator, nc.subId);
        VRFCoordinatorV2_5Mock(nc.coordinator).addConsumer(nc.subId, address(rf));
        address newUser = makeAddr("saket");
        address newUser2 = makeAddr("sharma");
        address newUser3 = makeAddr("motki");
        address newUser4 = makeAddr("joker");
        vm.deal(newUser, 7e18);
        vm.deal(newUser2, 7e18);
        vm.deal(newUser3, 7e18);
        vm.deal(newUser4, 7e18);
        vm.prank(newUser);
        rf.enterRaffle{value: 1 ether}();
        vm.prank(newUser2);
        rf.enterRaffle{value: 1 ether}();
        vm.prank(newUser3);
        rf.enterRaffle{value: 1 ether}();
        vm.prank(newUser4);
        rf.enterRaffle{value: 1 ether}();
        uint256 rid = rf.performUpkeep();


        VRFCoordinatorV2_5Mock(nc.coordinator).fulfillRandomWords(rid, address(rf));
        address winner = rf.getWinner();

        console.log(winner);

        console.log("-----------");

        console.log(newUser);
        console.log("-----------");
        console.log(newUser2);

        // vm.stopBroadcast();
        // rf.performUpkeep();
    }
}