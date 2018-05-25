pragma solidity ^0.4.23;

contract DragonFight {
    function getWiner(uint256 _dragonOneID, uint256 _dragonTwoID) internal returns (uint256 _winerID);
}

contract DragonsRandomFight2Death is DragonFight {
    function add2RandomFight2Death(address _dragonOwner, uint256 _DragonID) external;

}
