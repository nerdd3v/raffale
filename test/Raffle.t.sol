// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {RaffleScript} from "../script/Raffle.s.sol";
import {Raffle} from "../src/Raffle.sol";

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

    // function testFuzz_SetNumber(uint256 x) public {

    // }
}
