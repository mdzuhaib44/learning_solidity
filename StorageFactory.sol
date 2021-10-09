// SPDX-License-Identifier: MIT


//The code is basically doing following items
//1. How to inherit or import all the properties from a smartcontract
//2. Creating a array of such contracts and access value of each smart contract

pragma solidity ^0.8.0;

//import an existing smart contract
import "./SimpleStorage.sol";

contract StorageFactory is SimpleStorage{ //inherit all the properties of 'SimpleStorage'
    
    SimpleStorage[] public simpleStorageArray;
    
    function createSimpleStorageContract() public{
        
        //Create a SimpleStorage contract
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
        
    }
    
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public{
        //Addrees and ABI 
        //This will get the contract we want to intract with
        SimpleStorage currentContract = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        currentContract.store(_simpleStorageNumber);
                
    }
    
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256){
        
        //This will get the contract we want to intract with
        //SimpleStorage currentContract = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        //return currentContract.get();
        
        return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).get();
    }
    
}
