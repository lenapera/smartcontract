pragma solidity ^0.4.16;

contract Raindatamonetizer {
    
    uint amountOfSegments;
    uint remainingSegments;
    uint pricePerSegment; 
    uint deadline; 
    int destLatitude;
    int destLongitude;
    int radius;
    uint funds;
    mapping (uint => Datasegment) datasegments;
    address owner;
    uint datasegmentID;
    
    struct Datasegment {
        address provider;
        int latitude;
        int longitude;
        uint raindata; 
        uint timestamp;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function Raindatamonetizer (int _latitude, int _longitude, int _radius, uint _amountOfSegments, uint _pricePerSegment, uint _deadline) payable {
        require(msg.value > _pricePerSegment * _amountOfSegments);
        funds = msg.value;
        owner = msg.sender;
        pricePerSegment = _pricePerSegment;
        amountOfSegments = _amountOfSegments;
        destLatitude = _latitude;
        destLongitude = _longitude;
        radius = _radius;
        deadline = _deadline;
        remainingSegments = amountOfSegments;
    }
    
    function getConditions () constant returns (address _owner, uint _pricePerSegment, int _latitude, int _longitude, int _radius, uint _deadline, uint _remainingSegments) {
        _owner = owner;
        _pricePerSegment = pricePerSegment;
        _latitude = destLatitude;
        _longitude = destLongitude;
        _radius = radius;
        _deadline = deadline;
        _remainingSegments = remainingSegments;
    }
    
    function insertDataSegment(int _latitude, int _longitude, uint _raindata, uint _timestamp) {
        datasegmentID++; 
        datasegments[datasegmentID] = Datasegment(msg.sender, _latitude, _longitude, _raindata, _timestamp);
        escrow(datasegmentID);
    }
    
    
    function getDataSegmentTestToBeDeleted (uint _datasegmentID) constant returns (address provider, int latitude, int longitude, uint raindata, uint timestamp) {
        provider = datasegments[_datasegmentID].provider;
        latitude = datasegments[_datasegmentID].latitude;
        longitude = datasegments[_datasegmentID].longitude;
        raindata = datasegments[_datasegmentID].raindata;
        timestamp = datasegments[_datasegmentID].timestamp;
    }

    function getDataSegment (uint _datasegmentID) onlyOwner returns (address provider, int latitude, int longitude, uint raindata, uint timestamp) {
        provider = datasegments[_datasegmentID].provider;
        latitude = datasegments[_datasegmentID].latitude;
        longitude = datasegments[_datasegmentID].longitude;
        raindata = datasegments[_datasegmentID].raindata;
        timestamp = datasegments[_datasegmentID].timestamp;
    }
    
    function escrow (uint _datasegmentID) returns (bool success) {
        if (validateDataSegment(_datasegmentID)) {
            if (funds > pricePerSegment) {
                datasegments[_datasegmentID].provider.transfer(pricePerSegment);
                funds = funds - pricePerSegment;
                remainingSegments--;
                
                return true;
            }
        }
        
        return false;
    }
    
    function validateDataSegment(uint _datasegmentID) returns (bool valid) {
        int latitudeMin = destLatitude - radius;
        int latitudeMax = destLatitude + radius;
        int longitudeMin = destLongitude - radius;
        int longitudeMax = destLongitude + radius;
        
        if ((remainingSegments > 0) && (deadline > datasegments[_datasegmentID].timestamp)) {
            if ((latitudeMin < datasegments[_datasegmentID].latitude) && (datasegments[_datasegmentID].latitude < latitudeMax)) {
                if ((longitudeMin < datasegments[_datasegmentID].longitude) && (datasegments[_datasegmentID].longitude < longitudeMax)) {
                    return true;
                }
            }
        }
        
        return false;
    }
    
    function payout () onlyOwner {
        remainingSegments = 0; 
        owner.transfer(funds);
    }
}
