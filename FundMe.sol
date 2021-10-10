// SPDX-License-Identifier: MIT


//The code is basically doing following items
//1. How to import and call a data provider like chainlink
//2. How to use modifiers for certain functions like withDraw of funds
//3. Funding an address only when the value of ETH sent is greater than 50$
pragma solidity >=0.6.6 <0.9.0;

//Smart Contracts dont have a data source of thier own and have to depend on oracles for it
//Chailink is the most popular data provider for smartcontracts 
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; 

//import "@chainlink/contracts/src/v0.8/vendor/SafeMathChainlink.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract FundMe {
    
    //to handle Overflows and Underflows
    //unsigned basically means only positive numbers
    //Overflow is when uint8 -> (255 + 1) = 0 - because thats the upper limit
    //Underflow is when uint8 -> (0 - 1) = 255 - because neagative value is not allowed
    
    using SafeMath for uint256;
    
    //Create a mapping between address and how much fund they have
    mapping(address => uint256) public addressToAmountFunded;
    
    address[] public funders;
    address public owner;
    
    //constructor will be called on the contract initialization
    constructor() public {
        owner = msg.sender;
    }
    
    //"payable" keyword makes it possible for assoicating a value with transaction
    //generally denoted in gwei or wei
    function fund() public payable {
        
        //define a min USD of ETH to transfer
        
        uint256 minUSD = 50;
        
        //uint256 minUSD = 100 * 277772;
        // 1 gwei - 0.00000359 usdt
        // 1 USDT	277,772 Gwei
        //reqiure statements are same as if statements - they check if condition is true or else cancel the trasaction
        require(getConversionRate(msg.value) >= minUSD, "You need spend more ETH");
        
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        
    }
    
    //Contract address wherein ETH/USDT data provider is deployed.
    //0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
    //In traditional definition, Contract Address is like a exe deployed, once opened or called runs the code 
    
    function getVersion() public view returns(uint256){
        //ETH USD price from chainlink data
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
        
    }
    
    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        
        //blank spaces for arguments we dont need
        (, int256 answer,,,) = priceFeed.latestRoundData();
        
        //return uint256(answer / 100000000);
        return uint256(answer * 1000000000); //wil return value in wei - 18 decimals places
    }
    
    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        
        uint256 ethPrice = getPrice(); // in usdt
        uint256 ethAmountInUsd =  (ethPrice * ethAmount / 1000000000000000000); //1000000000000000000
        //return ethAmountInUsd;
        return ethAmountInUsd;
    }
    
    //Example of modfiers
    modifier onlyOwner{
        require(msg.sender == owner,"This operation can be performed by Contract owner");
        _; //run line 63 first and then run rest of the code where the modifier is used
    }
    
    function withDraw() payable onlyOwner public {
        //allow only the owner to call this function
        //require(msg.sender == owner);
        //this can be better handled using modifier
        //msg.sender.transfer(address(this).balance); //use to transfer ETH from one address to another
        
        for(uint256 funderIndex=0; funderIndex<funders.length; funderIndex++)
        {
            address currentFunder = funders[funderIndex];
            addressToAmountFunded[currentFunder] = 0;
        }
        funders = new address[](0);
    }
}
