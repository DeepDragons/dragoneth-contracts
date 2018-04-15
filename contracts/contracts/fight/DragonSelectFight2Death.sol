pragma solidity ^0.4.21;

contract DragonFight {
    function getWiner(uint256 _dragonOneID, uint256 _dragonTwoID) internal returns (uint256 _winerID);
}


contract DragonSelectFight2Death is DragonFight {
    function add2SelctFight2Death(address _dragonOwner, uint256 _yourDragonID, uint256 _oppDragonID, uint256 _endBlockNumber) external;
}
