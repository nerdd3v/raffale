// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {VRFConsumerBaseV2Plus} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";


error notEnoughEth();
error notEnoughTimePassed();

contract Counter is VRFConsumerBaseV2Plus{
    
    uint256 private constant entryFeeInUSD = 5;
    address private immutable priceFeed;
    address private immutable c_owner;
    address payable[] private contestants;
    uint256 private immutable interval;
    uint256 private lastTimeStamp;

    constructor(address _priceFeed, uint256 _interval, address vrfCoordinator)VRFConsumerBaseV2Plus(vrfCoordinator){
        priceFeed = _priceFeed;
        c_owner = msg.sender;
        interval = _interval;
        lastTimeStamp = block.timestamp;
    }

    function getterFeed()public view returns(AggregatorV3Interface){
        return AggregatorV3Interface(priceFeed);
    }

    function enterRaffle()public payable{

        if(msg.value < calculateETH2USD()){
            revert notEnoughEth();
        }
        contestants.push(payable(msg.sender));
        emit raffleEntered(msg.sender);
    }

    function calculateETH2USD()public view returns(uint256){
        AggregatorV3Interface feed = getterFeed();

        (,int256 result,,,) = feed.latestRoundData();

        // eth -> usd
        // 1 eth -> 3000 usd
        // x eth -> 5 usd
        uint256 answer = (entryFeeInUSD * 1e18) / uint256( result);
        return answer;
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords)internal override{
        
    }

    function pickWinner()public {
        if((block.timestamp - lastTimeStamp) < interval){
            revert notEnoughTimePassed();
        }

    }

    event raffleEntered(
        address indexed contenstant
    );
}
