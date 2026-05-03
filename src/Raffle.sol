// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {VRFConsumerBaseV2} from
    "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
import {VRFCoordinatorV2Interface} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/interfaces/VRFCoordinatorV2Interface.sol";


error notEnoughEth();
error timeError();
error raffleNotOpen();
error noUpkeepNeeded(uint256 balance);

contract Raffle is VRFConsumerBaseV2 {
    enum State {
        Open,
        Closed
    }
    
    address private s_winner;
    uint256 private constant entryFeeInWei = 100;
    // address private immutable owner;
    address payable[] public contestants;
    uint256 private immutable lotteryInterval;
    uint256 private lastTimeStamp;
    uint256 private s_requestId;
    VRFCoordinatorV2Interface public coordinator;
    uint64 private _subId;
    uint32 public constant cgl = 20000;
    uint32 public constant nw = 7;

    uint16 public constant requestConfirmations =3;
    bytes32 public constant kh = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;

    State private state;

    event raffleEntered(address indexed player);
    event winnerDeclare(address indexed winner);

    constructor(uint256 _lotteryInterval, address _vrfCoordinator, uint64 subId) VRFConsumerBaseV2(_vrfCoordinator) {
        // owner = msg.sender;
        lotteryInterval = _lotteryInterval;
        lastTimeStamp = block.timestamp;
        coordinator = VRFCoordinatorV2Interface(_vrfCoordinator);
        state = State.Open;
        _subId = subId;
    }

    function enterRaffle() public payable {
        if (state != State.Open) {
            revert raffleNotOpen();
        }

        if (msg.value < entryFeeInWei) {
            revert notEnoughEth();
        }
        contestants.push(payable(msg.sender));

        emit raffleEntered(msg.sender);
    }

    function timePassed() public view returns (bool, uint256) {
        if ((block.timestamp - lastTimeStamp) >= lotteryInterval) {
            return (true, block.timestamp - lastTimeStamp);
        }
        return (false, block.timestamp - lastTimeStamp);
    }

    function getContestantLenght() public view returns (uint256) {
        return contestants.length;
    }

    function checkUpKeep(bytes memory /* checkdata */ )
        public
        view
        returns (bool upkeepNeeded, bytes memory /* checkData */ )
    {
        //function for automating the pick winner via chainlink automation contract
        (bool timeHasPassed,) = timePassed();
        bool isOpen = state == State.Open;
        bool contractHasBalance = address(this).balance > 0 ether;
        bool hasPlayers = contestants.length > 0;

        return (timeHasPassed && isOpen && contractHasBalance && hasPlayers, "");
    }

    function getState() public view returns (State) {
        return state;
    }

    function performUpkeep() public returns(uint256){
        (bool upkeepNeeded,) = checkUpKeep("");
        if (upkeepNeeded == false) {
            revert noUpkeepNeeded(address(this).balance);
        }
        state = State.Closed;

        uint256 request = coordinator.requestRandomWords(kh,_subId, requestConfirmations, cgl, nw);

        s_requestId = request;
        return s_requestId;
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        if (contestants.length == 0) {
            revert("no people in raffale");
        }
        uint256 winnerIndex = randomWords[0] % contestants.length;
        s_winner = contestants[winnerIndex];
        state = State.Open;
        lastTimeStamp = block.timestamp;

        (bool success,) = contestants[winnerIndex].call{value: address(this).balance}("");

        if (success) {
            emit winnerDeclare(contestants[winnerIndex]);
        } else {
            revert("the winner cannot be funded");
        }
        contestants = new address payable[](0);
    }

    function getInterval() public view returns (uint256) {
        return lotteryInterval;
    }

    function getWinner()public view returns(address){
        return s_winner;
    }
}


// raffle -> 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
// mock -> 0x5FbDB2315678afecb367f032d93F642f64180aa3