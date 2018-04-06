pragma solidity ^0.4.21;

contract GenRNG {

    function getNewGens(address _from, uint256 _dragonID) external returns (uint256[2] resultGen);
}

contract FixMarketPlace {

    function addToFixMarketPlace(address _dragonOwner, uint256 _dragonID, uint256 _dragonPrice, uint256 _endBlockNumber) external returns (bool sucsses);
}
