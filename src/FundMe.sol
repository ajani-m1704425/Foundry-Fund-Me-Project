// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

import {AggregatorV3Interface} from "@chainlink/contracts/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    address public immutable owner;
    AggregatorV3Interface private s_pricefeed;
    constructor(address pricefeed) {
        owner = msg.sender;
        s_pricefeed = AggregatorV3Interface(pricefeed);
    }
    using PriceConverter for uint256;

    uint256 constant minimumUsd = 5e18;
    address[] public s_funders;
    mapping(address => uint256) public s_funderToValueFunded;

    function fund() public payable {
        require(
            msg.value.getPriceConverter(s_pricefeed) >= minimumUsd,
            "Eth does not meet the minimum requirement"
        );
        s_funders.push(msg.sender);
        s_funderToValueFunded[msg.sender] =
            s_funderToValueFunded[msg.sender] +
            msg.value;
    }

    function getVersion() public view returns (uint256) {
        return (s_pricefeed.version());
    }

    function withdraw() public onlycontractCreator {
        for (uint256 index = 0; index < s_funders.length; index++) {
            address funder = s_funders[index];
            s_funderToValueFunded[funder] = 0;
        }

        s_funders = new address[](0);

        // Method to Transfer Funds
        //Transfer
        // payable(msg.sender).transfer(address(this).balance);
        //Send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Error sending");
        //Call
        (bool callSucces, ) = payable(msg.sender).call{
            value: address(this).balance
        }(""); //Most use
        require(callSucces, "Call not Send");
    }

    modifier onlycontractCreator() {
        require(msg.sender == owner, "Withraw Can only be Call by Owner");
        _;
    }
    receive() external payable {
        fund();
    }
    fallback() external payable {
        fund();
    }

    function getFunders() public view returns (address[] memory) {
        return s_funders;
    }

    function getValueFromAddress(address Addr) public view returns (uint256) {
        return s_funderToValueFunded[Addr];
    }
}
