//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {Script} from "../lib/forge-std/src/Script.sol";
import {VRFCoordinatorV2_5Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

abstract contract CodeConstants {
    uint256 internal constant LOTTERY_INTERVAL = 20; //seconds
    uint256 internal constant LOCAL_CHAIN = 31337;

    uint96 internal constant BASE_FEE = 1000;
    uint96 internal constant GAS_PRICE = 1000;
    int256 internal constant WEI_PER_UNIT_LINK = 1000;

}

contract NetworkConfig is Script, CodeConstants{
    mapping (uint256 => string) public chainMapping;

    struct NetworkConfiguration {
        uint256 lotteryInterval;
        address coordinator;
    }

    NetworkConfiguration currentNetwork;

    constructor(uint256 chainId){
        if(chainId == LOCAL_CHAIN){
            setLocalChainConfiguration();
        }
    }

    function setLocalChainConfiguration() public {
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock mock = new VRFCoordinatorV2_5Mock(BASE_FEE, GAS_PRICE, WEI_PER_UNIT_LINK);
        vm.stopBroadcast();

        NetworkConfiguration memory nc = NetworkConfiguration(LOTTERY_INTERVAL, address(mock)) ;
        currentNetwork = nc;
    }

    function getLocalChainConfiguration()public view returns(NetworkConfiguration memory){
        return currentNetwork;
    }
}