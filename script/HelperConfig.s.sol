// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

import {MockV3Aggregator} from "../test/Mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    networkConfig public activeNetwork;
    uint8 constant DECIMAL = 8;
    int256 constant ANSWER = 2658e8;
    constructor() {
        if (block.chainid == 11155111) {
            activeNetwork = getSepoliaConfig();
        } else {
            activeNetwork = getAnvilConfig();
        }
    }
    struct networkConfig {
        address pricefeed;
    }
    function getSepoliaConfig() public pure returns (networkConfig memory) {
        networkConfig memory networkconfig = networkConfig({
            pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return (networkconfig);
    }

    function getAnvilConfig() public returns (networkConfig memory) {
        if (activeNetwork.pricefeed != address(0)) {
            return activeNetwork;
        }
        vm.startBroadcast();
        MockV3Aggregator Mockv3aggregator = new MockV3Aggregator(
            DECIMAL,
            ANSWER
        );
        vm.stopBroadcast();

        networkConfig memory networkconfig = networkConfig({
            pricefeed: address(Mockv3aggregator)
        });

        return (networkconfig);
    }
}
