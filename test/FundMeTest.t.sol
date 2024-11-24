// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;

    address USER = makeAddr("User");
    uint256 constant INITIAL_BAL = 5 ether;
    uint256 constant SENT_BAL = 0.2 ether;
    function setUp() external {
        DeployFundMe deployfundme = new DeployFundMe();
        fundme = deployfundme.run();
    }
    function testVersion() public view {
        console.log(fundme.getVersion());
        assertEq(fundme.getVersion(), 4);
    }

    function testNotUpToMinimumUsd() public {
        vm.expectRevert();
        fundme.fund{value: 0 ether}();
    }

    function testFundersDataArrayUpdate() public {
        fundme.fund{value: 1 ether}();
        console.log(fundme.getFunders()[0]);
        console.log(msg.sender);
        console.log(address(this));
        assertEq(fundme.getFunders()[0], address(this));
    }
    modifier settingUser() {
        vm.prank(USER);
        vm.deal(USER, INITIAL_BAL);
        fundme.fund{value: SENT_BAL}();
        _;
    }
    function testFunderDataStrucrureUpdate() public settingUser {
        console.log(fundme.getValueFromAddress(USER));
        assertEq(fundme.getValueFromAddress(USER), SENT_BAL);
    }

    function testOnlyOwnerCanWithdraw() public settingUser {
        vm.expectRevert();
        fundme.withdraw();
    }

    function testWitdraw() public settingUser {
        uint256 startingBalanceFundme = address(fundme).balance;
        uint256 startingBalanceOwner = address(msg.sender).balance;

        vm.prank(msg.sender);
        fundme.withdraw();

        uint256 endBalanceFundme = address(fundme).balance;
        uint256 endBalanceOwner = address(msg.sender).balance;

        console.log(startingBalanceFundme);
        console.log(startingBalanceOwner);
        console.log(endBalanceFundme);
        console.log(endBalanceOwner);

        assertEq(endBalanceOwner, startingBalanceOwner + startingBalanceFundme);
    }
}
