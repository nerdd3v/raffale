// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "../lib/forge-std/src/Script.sol";
import {VRFCoordinatorV2_5Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

abstract contract CodeConstants{
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /* VRF MOCK CONSTANTS */

    uint96 public constant baseFee = 0.1 ether; // 0.1 LINK
    uint96 public constant gasPriceLink = 1e9;  // 0.000000001 LINK per gas
    int256 public constant weiPerUnitLink = 4e8;
}

error UnknownChain(uint256 chainId);

contract NetworkConfig is CodeConstants, Script{

    struct forConstructor{
        uint256 lotteryInterval;
        address coordinator;
    }

    function getNetworkConfig(uint256 chainId)public  returns(forConstructor memory ){
        if(chainId == ETH_SEPOLIA_CHAIN_ID){
            return forConstructor({
                lotteryInterval: 20,
                coordinator:0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
        }
        else if(chainId == LOCAL_CHAIN_ID){
            vm.startBroadcast();
            VRFCoordinatorV2_5Mock mock = new VRFCoordinatorV2_5Mock(baseFee, gasPriceLink, weiPerUnitLink);
            vm.stopBroadcast();
            return forConstructor({
                lotteryInterval: 28,
                coordinator: address(mock)
            });
        }
        else{
            revert UnknownChain(block.chainid);
        }
    }
    
}