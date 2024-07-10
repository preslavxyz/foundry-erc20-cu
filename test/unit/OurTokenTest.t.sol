// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    address public alice;
    address public bob;

    function setUp() external {
        alice = address(0x1);
        bob = address(0x2);
        vm.startPrank(alice); // all subsequent calls will be from Alice's address
        ourToken = new OurToken(1000 * 10 ** 18); // 1000 tokens with 18 decimals
        vm.stopPrank();
    }

    function testInitialSupply() external view {
        assertEq(ourToken.totalSupply(), 1000e18);
        assertEq(ourToken.balanceOf(alice), 1000e18);
    }

    function testTransfer() external {
        vm.startPrank(alice);
        ourToken.transfer(bob, 100e18);
        vm.stopPrank();
        assertEq(ourToken.balanceOf(alice), 900e18);
        assertEq(ourToken.balanceOf(bob), 100e18);
    }

    function testApproveAndTransferFrom() external {
        vm.startPrank(alice);
        ourToken.approve(bob, 200e18);
        vm.stopPrank();
        uint256 allowance = ourToken.allowance(alice, bob);
        assertEq(allowance, 200e18);

        vm.startPrank(bob);
        ourToken.transferFrom(alice, bob, 200e18);
        vm.stopPrank();
        assertEq(ourToken.balanceOf(alice), 800e18);
        assertEq(ourToken.balanceOf(bob), 200e18);
    }

    function testAllowance() external {
        vm.startPrank(alice);
        ourToken.approve(bob, 300e18);
        vm.stopPrank();
        uint256 allowance = ourToken.allowance(alice, bob);
        assertEq(allowance, 300e18);

        vm.startPrank(bob);
        ourToken.transferFrom(alice, bob, 150e18);
        vm.stopPrank();
        assertEq(ourToken.balanceOf(alice), 850e18);
        assertEq(ourToken.balanceOf(bob), 150e18);
        allowance = ourToken.allowance(alice, bob);
        assertEq(allowance, 150e18);
    }

    function testFailInsufficientBalanceTransfer() external {
        vm.startPrank(alice);
        ourToken.transfer(bob, 1100e18); // Alice only has 1000 tokens
        vm.stopPrank();
    }

    function testFailInsufficientAllowanceTransferFrom() external {
        vm.startPrank(alice);
        ourToken.approve(bob, 100e18);
        vm.stopPrank();
        vm.startPrank(bob);
        ourToken.transferFrom(alice, bob, 200 * 10 ** 18); // allowance is only 100 tokens
        vm.stopPrank();
    }
}
