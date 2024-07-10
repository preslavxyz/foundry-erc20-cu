// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Test}  from "forge-std/Test.sol";
import { OurToken } from "src/OurToken.sol";

contract OurTokenFuzzTest is Test {
    OurToken public ourToken;
    address public alice;
    address public bob;

    function setUp() external {
        alice = address(0x1);
        bob = address(0x2);
        vm.startPrank(alice);
        ourToken = new OurToken(1000e18); // 1000 tokens with 18 decimals
        vm.stopPrank();
    }

    // function testFuzzTransfer(address to, uint256 amount) public {
    //     vm.assume(to != address(0)); // Prevent transferring to the zero address
    //     uint256 initialBalanceAlice = ourToken.balanceOf(alice);
    //     amount = bound(amount, 0, initialBalanceAlice); // Ensure amount is within balance

    //     uint256 initialBalanceTo = ourToken.balanceOf(to);

    //     vm.startPrank(alice);
    //     ourToken.transfer(to, amount);
    //     vm.stopPrank();

    //     assertEq(ourToken.balanceOf(alice), initialBalanceAlice - amount);
    //     assertEq(ourToken.balanceOf(to), initialBalanceTo + amount);
    // }

    function testFuzzApprove(address spender, uint256 amount) public {
        vm.assume(spender != address(0)); // Prevent approving the zero address

        vm.startPrank(alice);
        ourToken.approve(spender, amount);
        vm.stopPrank();

        assertEq(ourToken.allowance(alice, spender), amount);
    }

    // function testFuzzTransferFrom(address from, address to, uint256 amount) public {
    //     vm.assume(from != address(0)); // Prevent transferring from the zero address
    //     vm.assume(to != address(0)); // Prevent transferring to the zero address

    //     uint256 initialBalanceFrom = ourToken.balanceOf(from);
    //     amount = bound(amount, 0, initialBalanceFrom); // Ensure amount is within balance

    //     // Only proceed if from has some balance
    //     vm.assume(initialBalanceFrom > 0);

    //     vm.startPrank(alice);
    //     ourToken.approve(bob, amount);
    //     vm.stopPrank();
    //     uint256 initialBalanceTo = ourToken.balanceOf(to);
    //     uint256 initialAllowance = ourToken.allowance(from, bob);

    //     vm.startPrank(bob);
    //     ourToken.transferFrom(from, to, amount);
    //     vm.stopPrank();

    //     assertEq(ourToken.balanceOf(from), initialBalanceFrom - amount);
    //     assertEq(ourToken.balanceOf(to), initialBalanceTo + amount);
    //     assertEq(ourToken.allowance(from, bob), initialAllowance - amount);
    // }
}
