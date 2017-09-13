pragma solidity ^0.4.16;

contract Raindatamonetizer {
    
    uint amountOfSegments;
    uint remainingSegments;
    uint pricePerSegment; 
    uint deadline; 
    int latitude;
    int longitude;
    uint radius;
    uint funds;
    mapping (uint => Datasegment) datasegments;
    address owner;
    
    struct Datasegment {
        address provider;
        address owner;
        int latitude;
        int longitude;
        uint raindata; 
        uint timestamp;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function Raindatamonetizer (int _latitude, int _longitude, uint _radius, uint _amountOfSegments, uint _pricePerSegment, uint _deadline) payable {
        require(msg.value > _pricePerSegment * _amountOfSegments);
        funds = msg.value;
        owner = msg.sender;
        pricePerSegment = _pricePerSegment;
        amountOfSegments = _amountOfSegments;
        latitude = _latitude;
        longitude = _longitude;
        radius = _radius;
        deadline = _deadline;
    }
    
    function getConditions () constant returns (uint _pricePerSegment, int _latitude, int _longitude, uint _radius, uint _deadline) {
        _pricePerSegment = pricePerSegment;
        _latitude = latitude;
        _longitude = longitude;
        _radius = radius;
        _deadline = deadline;
    }
    
    function insertDataSegment(int _latitude, int _longitude, uint _raindata, uint _timestamp) returns (uint datasegmentID) {
        datasegmentID++; 
        datasegments[datasegmentID] = Datasegment(msg.sender, msg.sender, _latitude, _longitude, _raindata, _timestamp);
    }
    
    
    function getDataSegment (uint datasegmentID) constant returns (address provider, int latitude, int longitude, uint raindata, uint timestamp) {
        provider = datasegments[datasegmentID].provider;
        latitude = datasegments[datasegmentID].latitude;
        longitude = datasegments[datasegmentID].longitude;
        raindata = datasegments[datasegmentID].raindata;
        timestamp = datasegments[datasegmentID].timestamp;
    }
    
    function escrow (uint datasegmentID) returns (bool success) {
        if ((msg.sender == owner) && (funds > pricePerSegment)) {
            datasegments[datasegmentID].owner = msg.sender;
            datasegments[datasegmentID].provider.transfer(pricePerSegment);
            
            return true;
        }
        
        return false;
    }
    
    function validateDataSegment(uint iD) returns (bool valid) {
        
    }
}