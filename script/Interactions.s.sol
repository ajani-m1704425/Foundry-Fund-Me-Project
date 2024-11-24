// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;
    function fundFundMe(address mostRecentContract) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentContract)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
    }
    function run() external {
        address mostRecentContract = DevOpsTools.get_most_recent_deployment(
            "MyContract",
            block.chainid
        );
        vm.startBroadcast();
        fundFundMe(mostRecentContract);
        vm.stopBroadcast();
    }
}
contract WithdrawFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;
    function withdrawFundMe(address mostRecentContract) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentContract)).withdraw();
        vm.stopBroadcast();
    }
    function run() external {
        address mostRecentContract = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        withdrawFundMe(mostRecentContract);
        vm.stopBroadcast();
    }
}
