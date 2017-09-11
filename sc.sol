pragma solidity ^0.4.16;

contract Raindatamonetizer {
    
    uint requests;
    uint payAmount; 
    uint deadline; 
    uint geolocationRadius;
    mapping (uint => Datasegment) datasegments;
    address owner;
    
    struct Datasegment {
        address provider;
        uint geolocation;
        bool raindata; 
        uint timestamp;
    }
    
    function raindatamonetizer () {
        owner = msg.sender;
    }
    
    function insertDataSegment(uint geo, bool rain, uint time) returns (uint datasegmentID) {
        datasegmentID++; 
        datasegments[datasegmentID] = Datasegment(msg.sender, geo, rain, time);
    }
    
    function validateDataSegment(uint iD) returns (bool valid) {
        
    }
    
    function getDataSegment (uint datasegmentID) returns (address provider, uint geolocation, bool raindata, uint timestamp) {
        provider = datasegments[datasegmentID].provider;
        geolocation = datasegments[datasegmentID].geolocation;
        raindata = datasegments[datasegmentID].raindata;
        timestamp = datasegments[datasegmentID].timestamp;
    }
    
}
