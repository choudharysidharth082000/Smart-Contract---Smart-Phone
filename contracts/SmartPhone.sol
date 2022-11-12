//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;


contract PhoneSmart{
    address public admin;
    struct Group{
        uint256 groupId;
        string groupName;
        string groupDescription;
        address payable[] members;
        bool isActive;
        string groupLink;
        string groupQR;
        uint256 basePrice;
    }
    //database for storing all thr group
    mapping(uint256 => Group) public database;
    uint256 indexDatabase = 0;

    constructor(){
        admin = msg.sender; //global vaiable transferring value to the participants
    }
    //funciton for getting the participants with a fixed amount of ether
    function getParticipants(uint256 _groupId) public payable{
        require(database[_groupId].isActive == true, "Group is not active");
        require(msg.value == database[_groupId].basePrice, "Please pay the base price");
        database[_groupId].members.push(payable(msg.sender));
    }
    //function for creating a group
    function createGroup(string memory _groupName, string memory _groupDescription, string memory _groupLink, string memory _groupQR, uint256 _basePrice) public{
        database[indexDatabase] = Group(indexDatabase, _groupName, _groupDescription, new address payable[](0), true, _groupLink, _groupQR, _basePrice);
        indexDatabase++;
    }
    //function to join the group with the getParticipants function
    function joinGroup(uint256 _groupId) public payable{
        getParticipants(_groupId);
    }
    //function to get the group details
    function getGroupDetails(uint256 id) public view returns(Group memory){
        return database[id];
    }
    //function to get the group members
    function getGroupMembers(uint256 id) public view returns(address payable[] memory){
        return database[id].members;
    }
    //function to get the group members
    function getGroupMembersCount(uint256 id) public view returns(uint256){
        return database[id].members.length;
    }
    //function to get the group members
    function getGroupMembersDetails(uint256 id, uint256 index) public view returns(address payable){
        return database[id].members[index];
    }
    //function to divide all ethers to all members except for the id provided in parameter and also check if it is the admin
    function divideEther(uint256 _groupId, uint256 _id) public payable{
        require(msg.sender == admin, "You are not the admin");
        uint256 amount = msg.value / database[_groupId].members.length;
        for(uint256 i = 0; i < database[_groupId].members.length; i++){
            if(i != _id){
                database[_groupId].members[i].transfer(amount);
            }
        }
    }
    //function to divide all ethers to all members except for the id provided in parameter
    function divideEther(uint256 _groupId) public payable{
        uint256 amount = msg.value / database[_groupId].members.length;
        for(uint256 i = 0; i < database[_groupId].members.length; i++){
            database[_groupId].members[i].transfer(amount);
        }
    }
    //function to get the balance of the contract
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }    
    
    
}