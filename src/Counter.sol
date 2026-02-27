// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// eth -> usd

error notEnoughEth();
error notEnoughTimePassed();

contract Counter {
    
    uint256 private constant entryFeeInUSD = 5;
    address private immutable priceFeed;
    address private immutable owner;
    address payable[] private contestants;
    uint256 private immutable interval;
    uint256 private lastTimeStamp;

    constructor(address _priceFeed, uint256 _interval){
        priceFeed = _priceFeed;
        owner = msg.sender;
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

    function pickWinner()public {
        if((block.timestamp - lastTimeStamp) > interval){
            revert notEnoughTimePassed();
        }
    }

    event raffleEntered(
        address indexed contenstant
    );
}
