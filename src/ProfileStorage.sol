// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13 <0.9.0;

/// @title Profile Storage (Mini Project)
/// @author Rasheed
/// @notice Profile Onchain
/// @dev Stores profile details

contract ProfileStorage {
    //enum to track account status

    enum AccountStatus {
        Unregistered,
        Active,
        Inactive
    }

    //struct to store user details
    struct User {
        string username;
        uint256 age;
        uint256 creationTime;
        uint256 balance;
        address wallet;
        AccountStatus status;
    }

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    //mapping to store user details with wallet address as key
    mapping(address => User) users;

    error AccountAlreadyExist();
    error AccountNotActive();
    error onlyOwnerCan();

    modifier onlyUnregistered() {
        if (users[msg.sender].status != AccountStatus.Unregistered) {
            revert AccountAlreadyExist();
        }
        _;
    }

    modifier onlyActive() {
        if (users[msg.sender].status != AccountStatus.Active) {
            revert AccountNotActive();
        }
        _;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert onlyOwnerCan();
        }
        _;
    }

    //logic to create profile, suspend account and get profile details
    function createProfile(
        string memory _username,
        uint256 _age
    ) public payable onlyUnregistered {
        users[msg.sender] = User({
            username: _username,
            age: _age,
            creationTime: block.timestamp,
            balance: msg.value,
            wallet: msg.sender,
            status: AccountStatus.Active
        });
    }

    //logic to suspend account, only active accounts can suspend other accounts
    function suspendAcct(address _inactive) public onlyActive onlyOwner {
        users[_inactive].status = AccountStatus.Inactive;
    }

    //logic to get profile details, only active accounts can view profile details
    function getProfile(
        address _user
    )
        public
        view
        onlyOwner
        returns (
            string memory,
            uint256,
            uint256,
            uint256,
            address,
            AccountStatus
        )
    {
        User memory u = users[_user];
        return (
            u.username,
            u.age,
            u.creationTime,
            u.balance,
            u.wallet,
            u.status
        );
    }
}
