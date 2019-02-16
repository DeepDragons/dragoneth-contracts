pragma solidity ^0.5.3;
pragma experimental ABIEncoderV2;

contract DragonsETH {
    struct Dragon {
        uint256 gen1;
        uint8 stage; // 0 - Dead, 1 - Egg, 2 - Young Dragon 
        uint8 currentAction; // 0 - free, 1 - fight place, 0xFF - Necropolis,  2 - random fight,
                             // 3 - breed market, 4 - breed auction, 5 - random breed, 6 - market place ...
        uint240 gen2;
        uint256 nextBlock2Action;
    }

    Dragon[] public dragons;
    mapping(uint256 => string) public dragonName;
    
    function ownerOf(uint256 _tokenId) public view returns (address);
}

contract DragonsStats {
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
    
    
}

contract Proxy4DAPP {
    DragonsETH public mainContract;
    DragonsStats public statsContract;
    
    constructor(address _addressMainContract, address _addressDragonsStats) public {
        mainContract = DragonsETH(_addressMainContract);
        statsContract = DragonsStats(_addressDragonsStats);
    } /*
    function getDragons(uint256[] calldata _dragonIDs) external view returns(uint256[] memory) {
        if (_dragonIDs.length == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](_dragonIDs.length * 15 + 1);
            uint256 resultIndex = 0;
             result[resultIndex++] = block.number;
            for (uint256 dragonIndex = 0; dragonIndex < _dragonIDs.length; dragonIndex++) {
                uint256 dragonID = _dragonIDs[dragonIndex];
                result[resultIndex++] = dragonID;
                result[resultIndex++] = uint256(mainContract.ownerOf(dragonID));
                uint8 tmp;
                uint8 currentAction;
                uint240 gen2;
                (result[resultIndex++],tmp,currentAction,gen2,result[resultIndex++]) = mainContract.dragons(dragonID);
                result[resultIndex++] = uint256(tmp); // stage
                result[resultIndex++] = uint256(currentAction);
                result[resultIndex++] = uint256(gen2);
                uint248 lastActionDragonID;
                (tmp, lastActionDragonID) = statsContract.lastActions(dragonID);
                result[resultIndex++] = uint256(tmp); // lastActionID
                result[resultIndex++] = uint256(lastActionDragonID);
                uint32 fightWin;
                uint32 fightLose;
                uint32 children;
                uint32 fightToDeathWin;
                uint32 mutagenFight;
                uint32 genLabFight;
                (fightWin,fightLose,children,fightToDeathWin,,mutagenFight,,genLabFight) = statsContract.dragonStats(dragonID);
                result[resultIndex++] = uint256(fightWin);
                result[resultIndex++] = uint256(fightLose);
                result[resultIndex++] = uint256(children);
                result[resultIndex++] = uint256(fightToDeathWin);
                result[resultIndex++] = uint256(mutagenFight);
                result[resultIndex++] = uint256(genLabFight);
            }

            return result; 
        }
    } */
    function getDragons(uint256[] calldata _dragonIDs) external view returns(uint256[] memory) {
        if (_dragonIDs.length == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](_dragonIDs.length * 17 + 1/*CHAGE IT*/);
            result[0] = block.number;
            for (uint256 dragonIndex = 0; dragonIndex < _dragonIDs.length; dragonIndex++) {
                uint256 dragonID = _dragonIDs[dragonIndex];
                result[dragonIndex * 17 + 1] = dragonID;
                result[dragonIndex * 17 + 2] = uint256(mainContract.ownerOf(dragonID));
                uint8 tmp;
                uint8 currentAction;
                uint240 gen2;
                (result[dragonIndex * 17 + 3]/*gen1*/,tmp,currentAction,gen2,result[dragonIndex * 17 + 4]/*nextBlock2Action*/) = mainContract.dragons(dragonID);
                result[dragonIndex * 17 + 5] = uint256(tmp); // stage
                result[dragonIndex * 17 + 6] = uint256(currentAction);
                result[dragonIndex * 17 + 7] = uint256(gen2);
                uint248 lastActionDragonID;
                (tmp, lastActionDragonID) = statsContract.lastActions(dragonID);
                result[dragonIndex * 17 + 8] = uint256(tmp); // lastActionID
                result[dragonIndex * 17 + 9] = uint256(lastActionDragonID);
                uint32 fightWin;
                uint32 fightLose;
                uint32 children;
                uint32 fightToDeathWin;
                uint32 mutagenFight;
                uint32 genLabFight;
                uint32 mutagenFace;
                uint32 genLabFace;
                (fightWin,fightLose,children,fightToDeathWin,mutagenFace,mutagenFight,genLabFace,genLabFight) = statsContract.dragonStats(dragonID);
                result[dragonIndex * 17 + 10] = uint256(fightWin);
                result[dragonIndex * 17 + 11] = uint256(fightLose);
                result[dragonIndex * 17 + 12] = uint256(children);
                result[dragonIndex * 17 + 13] = uint256(fightToDeathWin);
                result[dragonIndex * 17 + 14] = uint256(mutagenFace);
                result[dragonIndex * 17 + 15] = uint256(mutagenFight);
                result[dragonIndex * 17 + 16] = uint256(genLabFace);
                result[dragonIndex * 17 + 17] = uint256(genLabFight);
            }

            return result; 
        }
    }
    function getDragonsName(uint256[] calldata _dragonIDs) external view returns(string[] memory) {
        uint256 dragonCount = _dragonIDs.length;
        if (dragonCount == 0) {
            return new string[](0);
        } else {
            string[] memory result = new string[](dragonCount);
            uint256 resultIndex = 0;

            for (uint256 dragonIndex = 0; dragonIndex < dragonCount; dragonIndex++) {
                result[resultIndex++] = mainContract.dragonName(_dragonIDs[dragonIndex]);
            }
        }
    }
    function getDragonsStats(uint256[] calldata _dragonIDs) external view returns(uint256[] memory) {
        uint256 dragonCount = _dragonIDs.length;
        if (dragonCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](dragonCount * 6);
            uint256 resultIndex = 0;

            for (uint256 dragonIndex = 0; dragonIndex < dragonCount; dragonIndex++) {
                uint256 dragonID = _dragonIDs[dragonIndex];
                result[resultIndex++] = dragonID;
                result[resultIndex++] = uint256(mainContract.ownerOf(dragonID));
                uint128 parentOne;
                uint128 parentTwo;
                (parentOne, parentTwo) = statsContract.parents(dragonID);
                result[resultIndex++] = uint256(parentOne);
                result[resultIndex++] = uint256(parentTwo);
                result[resultIndex++] = statsContract.birthBlock(dragonID);
                result[resultIndex++] = statsContract.deathBlock(dragonID);
                }
        }
    }
}
