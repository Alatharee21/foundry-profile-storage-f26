// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13 <0.9.0;

import {Test} from "forge-std/Test.sol";
import {ProfileStorage} from "../src/ProfileStorage.sol";
import {console} from "forge-std/console.sol";

contract ProfileStorageTest is Test {
    ProfileStorage public profileStorage;

    function setUp() public {
        profileStorage = new ProfileStorage();
    }

    function test_CreateProfile() public payable {
        profileStorage.createProfile("Alice", 25);
        (
            string memory username,
            uint256 age,
            uint256 creationTime,
            uint256 balance,
            address wallet,
            ProfileStorage.AccountStatus status
        ) = profileStorage.getProfile(msg.sender);

        console.log("Username:", username);
        console.log("Age:", age);
        console.log("Creation Time:", creationTime);
        console.log("Balance:", balance);
        console.log("Wallet:", wallet);
        console.log("Status:", uint256(status));

        assertEq(username, "Alice");
        assertEq(age, 25);
        assertEq(creationTime, block.timestamp);
        assertEq(balance, msg.value);
        assertEq(wallet, msg.sender);
        assertEq(uint256(status), uint256(ProfileStorage.AccountStatus.Active));
    }

    function test_suspendAcct() public payable {
        profileStorage.createProfile("Bob", 30);
        profileStorage.suspendAcct(address(0x123));
        (, , , , , ProfileStorage.AccountStatus status) = profileStorage
            .getProfile(address(0x123));
        assertEq(
            uint256(status),
            uint256(ProfileStorage.AccountStatus.Inactive)
        );
    }

    function test_GetProfile() public payable {
        profileStorage.createProfile("Charlie", 28);
        (
            string memory username,
            uint256 age,
            uint256 creationTime,
            uint256 balance,
            address wallet,
            ProfileStorage.AccountStatus status
        ) = profileStorage.getProfile(msg.sender);
        assertEq(username, "Charlie");
        assertEq(age, 28);
        assertEq(creationTime, block.timestamp);
        assertEq(balance, msg.value);
        assertEq(wallet, msg.sender);
        assertEq(uint256(status), uint256(ProfileStorage.AccountStatus.Active));
    }
}
