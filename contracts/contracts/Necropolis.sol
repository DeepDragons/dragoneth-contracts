pragma solidity ^0.4.23;


import "./security/rbac/RBACWithAdmin.sol";


contract Necropolis is RBACWithAdmin {
    struct Dragon {
        address lastDragonOwner;
        uint256 dragonID;
        uint256 deathReason; // 1 - suicide, 2 - drunk, 3 - fight
    }
    
    Dragon[] public dragons;
    mapping(uint256 => uint256) public dragonIndex;
    
    constructor() public {
        Dragon memory _dragon = Dragon({
            lastDragonOwner: 0,
            dragonID: 0,
            deathReason: 0
        });
        dragons.push(_dragon);
    }
    
    function addDragon(
        address _lastDragonOwner, 
        uint256 _dragonID, 
        uint256 _deathReason
    ) 
        external 
        onlyRole("MainContract") 
    {
        Dragon memory _dragon = Dragon({
            lastDragonOwner: _lastDragonOwner,
            dragonID: _dragonID,
            deathReason: _deathReason
        });
        dragonIndex[_dragonID] = dragons.length;
        dragons.push(_dragon);
    }
    
    function deadDragons() external view returns (uint256){
        return dragons.length - 1;
    }
}
