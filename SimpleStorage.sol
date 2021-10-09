// SPDX-License-Identifier: MIT


//The code is basically doing following two items
//1. Asking the user to store a favorite number and then retrive it
//2. Creating a mapping of Person->favorite number and pushing it to an array
//pragma solidity >=0.6.0 <0.9.0;

pragma solidity ^0.8.0;

contract SimpleStorage {
    
    //declaration of different datatypes
    //uint256 favNo = 256;
    //bool aBool = false;
    //string HelloWorld = "Hello World!";
    //int256 favNum = -5;
    //address ethAddress = 0x033dcd188ba4c34a237722d7fb30ebeaa2cbcdfb;
    
    //this will be init to 0
    //the "public" keyword makes it accesssible any place in the contract
    //"internal" is the default state
    uint256 public favoriteNumber;

    struct People{
        uint256 favoriteNumberNew;
        string name;
    }

    //People public people = People({favoriteNumberNew: 44, name : "zzz"});
    //dynamic arrays
    People[] public people;

	//creates a one-to-one relationship - more like a dictionary    
    mapping(string => uint256) public nameToFavoriteNumber;
    
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
    
    //view and pure do not cost any gas as they just give us the current state of blockchain
    function get() public view returns(uint256){
        return favoriteNumber;
    }
    
    //Two ways to store information
    //"memory" -> the value is stored during execution or contract call
    //"storage" -> it will persist even after function execution
    function addPerson(string memory _name, uint256 _favoriteNumberNew) public {
        //people.push(People({favoriteNumberNew: _favoriteNumberNew, name : _name}));
        people.push(People(_favoriteNumberNew, _name));
        
        nameToFavoriteNumber[_name] = _favoriteNumberNew;
    }
    
    
}
