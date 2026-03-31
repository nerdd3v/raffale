// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

abstract contract CodeConstants{
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}

error UnknownChain(uint256 chainId);

contract NetworkConfig is CodeConstants{


    struct Network {
        address coordinatorContract;
    }

    function getNetworkConfig()public view returns(Network memory ){
        if(block.chainid == ETH_SEPOLIA_CHAIN_ID){
            return Network({
                coordinatorContract:0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
        }
        else if(block.chainid == LOCAL_CHAIN_ID){
            return Network({
                coordinatorContract: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
        }
        else{
            revert UnknownChain(block.chainid);
        }
    }
    
}