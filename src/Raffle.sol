// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {VRFConsumerBaseV2Plus} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {IVRFCoordinatorV2Plus} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/dev/interfaces/IVRFCoordinatorV2Plus.sol";
import {VRFV2PlusClient} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

error notEnoughEth();
error timeError();

contract Raffle is VRFConsumerBaseV2Plus{
    
    enum State {Open, Closed}
    uint256 private constant entryFeeInWei = 100;
    // address private immutable owner;
    address payable[] contestants;
    uint256 private immutable lotteryInterval;
    uint256 private lastTimeStamp;
    uint256 private s_requestId;
    IVRFCoordinatorV2Plus public coordinator;
    // uint256 public rw;

    State private state; 


    event raffleEntered(address indexed player);
    event winnerDeclare(address indexed winner);

    constructor(uint256 _lotteryInterval, address _vrfCoordinator)VRFConsumerBaseV2Plus(_vrfCoordinator){
        // owner = msg.sender;
        lotteryInterval = _lotteryInterval;
        lastTimeStamp = block.timestamp;
        coordinator = IVRFCoordinatorV2Plus(_vrfCoordinator);
        state = State.Open;
    }

    function enterRaffle()public payable{
        if(msg.value < entryFeeInWei){
            revert notEnoughEth();
        }
        contestants.push(payable(msg.sender));

        emit raffleEntered(msg.sender);
    }

    function pickWinner()public {
        if(block.timestamp - lastTimeStamp < lotteryInterval){
            revert timeError();
        }
        state = State.Closed;

        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient.RandomWordsRequest({
            keyHash: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
            subId: 43613802726724484435274018080008737583135228260117101033074813529169333276170,
            requestConfirmations: 3,
            callbackGasLimit: 200000,
            numWords: 1,
            extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({
                nativePayment: false
            }))
        });

        uint256 requestId = coordinator.requestRandomWords(request);

        s_requestId = requestId;
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override{
        if (contestants.length == 0){
            revert("no people in raffale");
        }
        uint256 winnerIndex = randomWords[0] % contestants.length;
        lastTimeStamp = block.timestamp;
        emit winnerDeclare(contestants[winnerIndex]);
        state = State.Open;

        (bool success,) = contestants[winnerIndex].call{value: address(this).balance}("");
        contestants = new address payable[](0);
    }


}
