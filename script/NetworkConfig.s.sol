// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {Script} from "../lib/forge-std/src/Script.sol";
import {VRFCoordinatorMock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorMock.sol";

abstract contract CodeConstants{
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}

error UnknownChain(uint256 chainId);

contract NetworkConfig is CodeConstants, Script{

    struct Network{
        address coordinator;
    }

    struct forConstructor{
        uint256 lotteryInterval;
        uint256 lastTimeStamp;
        address coordinator;
    }

    function getNetworkConfig(uint256 chainId)public view returns(forConstructor memory ){
        if(chainId == ETH_SEPOLIA_CHAIN_ID){
            
            return forConstructor({
                lotteryInterval: 20,
                lastTimeStamp: block.timestamp,
                coordinator:0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
        }
        else if(chainId == LOCAL_CHAIN_ID){
            return forConstructor({
                lotteryInterval: 20,
                lastTimeStamp: block.timestamp,
                coordinator:0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
        }
        else{
            revert UnknownChain(block.chainid);
        }
    }
    
}