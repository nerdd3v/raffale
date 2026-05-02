//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {VRFCoordinatorV2_5Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

abstract contract CodeConstants{
    uint256 internal constant LOTTERY_INTERVAL = 0;

    uint256 internal constant LOCAL_CHAIN_ID = 31337;
    uint256 internal constant MAINNET_CHAIN_ID = 1;
    uint256 internal constant SEPOLIA_CHAIN_ID = 11155111;

    uint96 internal constant BASE_FEE = 0.1 ether;
    uint96 internal constant GAS_PRICE = 1e9;
    int256 internal constant WEI_PER_UNIT_LINK = 4e15;

    address internal constant FOUNDRY_DEFAULT_ADDRESS = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
}

contract HelperConfig is Script, CodeConstants{
    //vrf coordinator
    struct NetworkConfig{
        uint256 lotteryInterval;
        address coordinator;
        uint256 subId;
    }

    mapping(uint256 chainId => NetworkConfig ) public chainMapping;

    constructor(uint256 chainId){
        if(chainId == LOCAL_CHAIN_ID){
            setLocalChainNetworkConfig(chainId);
        }
    }

    function setLocalChainNetworkConfig(uint256 chainId) public {
    // Only deploy the mock here
    VRFCoordinatorV2_5Mock mock = new VRFCoordinatorV2_5Mock(BASE_FEE, GAS_PRICE, WEI_PER_UNIT_LINK);

    // Don't create the sub here, just pass the coordinator address
    NetworkConfig memory nc = NetworkConfig(LOTTERY_INTERVAL, address(mock), 0); 
    chainMapping[chainId] = nc;
}

    function getLocalChainNetworkConfig(uint256 chainId) public view returns(NetworkConfig memory){
        return chainMapping[chainId];
    }
}