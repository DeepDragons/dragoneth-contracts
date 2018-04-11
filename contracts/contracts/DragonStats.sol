pragma solidity ^0.4.21;

import "./security/rbac/RBACWithAdmin.sol";

contract DragonStats is RBACWithAdmin {
    uint256 constant UINT128_MAX = 340282366920938463463374607431768211455;
    uint256 constant UINT248_MAX = 452312848583266388373324160190187140051835877600158453279131187530910662655;
    struct parent {
        uint128 parentOne;
        uint128 parentTwo;
    }
    
    struct lastAction {
        uint8  lastActionID;
        uint248 lastActionDragonID;
    }
    
    struct dragonStat {
        uint32 fightWin;
        uint32 fightLose;
        uint32 children;
        uint32 fightToDeathWin;
        uint32 mutagenFace;
        uint32 mutagenFight;
        uint32 genLabFace;
        uint32 genLabFight;
    }
    
    mapping(uint256 => uint256) public birthBlock;
    mapping(uint256 => uint256) public deathBlock;
    mapping(uint256 => parent)  public parents;
    mapping(uint256 => lastAction) public lastActions;
    mapping(uint256 => dragonStat) public dragonStats;
    
    function DragonStats(address _mainContract) public {
        adminAddRole(_mainContract, "MainContract");
        
    }
    
    function setBirthBlock(uint256 _dragonID, uint256 _birthBloc) external onlyRole("MainContract") {
        require(birthBlock[_dragonID] == 0);
        birthBlock[_dragonID] = _birthBloc;
    }
    
    function setDeathBlock(uint256 _dragonID, uint256 _deathBloc) external onlyRole("MainContract") {
        require(deathBlock[_dragonID] == 0);
        deathBlock[_dragonID] = _deathBloc;
    }
    
    function setParens(uint256 _dragonID, uint256 _parentOne, uint256 _parentTwo) external onlyRole("MainContract") {
        
        require(birthBlock[_dragonID] == 0);
        
        if (_parentOne <= UINT128_MAX) { 
            parents[_dragonID].parentOne = uint128(_parentOne);
        }
        
        if (_parentTwo <= UINT128_MAX) { 
            parents[_dragonID].parentTwo = uint128(_parentTwo);
        }
    }
    function setLastAction(uint256 _dragonID, uint256 _lastActionDragonID, uint8 _lastActionID) external onlyRole("MainContract") {
        lastActions[_dragonID].lastActionID = _lastActionID;
        if (_lastActionDragonID > UINT248_MAX) {
            lastActions[_dragonID].lastActionDragonID = 0;
        } else {
            lastActions[_dragonID].lastActionDragonID = uint248(_lastActionDragonID);
        }
    }
    function incFightWin(uint256 _dragonID) external onlyRole("MainContract") {
        dragonStats[_dragonID].fightWin++;
    }
    function incFightLose(uint256 _dragonID) external onlyRole("MainContract") {
        dragonStats[_dragonID].fightLose++;
    }
    function incChildren(uint256 _dragonID) external onlyRole("MainContract") {
        dragonStats[_dragonID].children++;
    }
    function addMutagenFace(uint256 _dragonID, uint256 _mutagenCount) external onlyRole("MainContract") {
        dragonStats[_dragonID].mutagenFace = dragonStats[_dragonID].mutagenFace + uint32(_mutagenCount);
    }
    function addMutagenFight(uint256 _dragonID, uint256 _mutagenCount) external onlyRole("MainContract") {
        dragonStats[_dragonID].mutagenFight = dragonStats[_dragonID].mutagenFight + uint32(_mutagenCount);
    }
    function incGenLabFace(uint256 _dragonID) external onlyRole("MainContract") {
        dragonStats[_dragonID].genLabFace++;
    }
    function incGenLabFight(uint256 _dragonID) external onlyRole("MainContract") {
        dragonStats[_dragonID].genLabFight++;
    }
}
