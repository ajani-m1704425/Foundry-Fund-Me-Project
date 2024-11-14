//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract interactionsTest is Test {
    FundMe fundme;

    address USER = makeAddr("User");
    uint256 constant INITIAL_BAL = 5 ether;
    uint256 constant SENT_BAL = 0.2 ether;

    function setUp() external {
        DeployFundMe deployfundme = new DeployFundMe();
        fundme = deployfundme.run();
    }

    function testUserCanFundInteraction() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundme));
        console.log(msg.sender);
        console.log(address(this));
        assertEq(fundme.getFunders()[0], address(msg.sender));
    }

    function testUserCanWithdrawInteraction() public {
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundme));
        assertEq(address(fundme).balance, 0);
    }
}
