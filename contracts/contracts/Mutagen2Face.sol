pragma solidity ^0.4.23;

contract DragonsETH {
     function killDragonDeathContract(address _lastOwner, uint256 _dragonID, uint256 _deathReason) external;
     function transferFrom(address _from, address _to, uint256 _tokenId) public;
}
contract CheckMutagenResistance {
    function checkResistance(uint256 _dragonID) external view returns (bool);
}


contract Mutagen2Face {
    function addDragon(address _dragonOwner, uint256 _dragonID, uint256 mutagenCount) external;
}