// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {RaffleScript} from "../script/Raffle.s.sol";
import {Raffle} from "../src/Raffle.sol";
import {console} from "../lib/forge-std/src/console.sol";

contract RaffleTest is Test {
    RaffleScript public dc;
    Raffle public raffle;

    function setUp() public {
        dc = new RaffleScript();
        dc.setUp();
        raffle = dc.run();
    }

    function testState() public view {
        assert(Raffle.State.Open == raffle.getState());
    }

    function testTimePassed()public view{
        (bool passed, uint256 time) = raffle.timePassed();
        assert(passed == false);
        console.log(time);
    }

    function testEntry()public payable{
        address user = makeAddr("saket");
        address user2 = makeAddr("sake");
        vm.deal(user, 10 ether);
        vm.deal(user2, 10 ether);

        vm.prank(user);
        raffle.enterRaffle{value: 1 ether}();
        vm.prank(user2);
        raffle.enterRaffle{value: 1 ether}();

        assert(raffle.getContestantLenght() == 2);

        console.log(raffle.getContestantLenght());
    }

    function testInterval()public view {
        assert(raffle.getInterval() == 28);
        console.log(raffle.getInterval());
    }
}
