// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {ProfileStorage} from "../src/ProfileStorage.sol";

contract ProfileStorageScript is Script {
    ProfileStorage public profileStorage;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        profileStorage = new ProfileStorage();

        vm.stopBroadcast();
    }
}
