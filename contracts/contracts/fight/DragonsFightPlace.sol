pragma solidity ^0.5.4;

import "./DragonsFightGC.sol";
import "../security/ReentrancyGuard.sol";
import "../math/SafeMath.sol";

contract DragonsFightPlace is DragonsFightGC, ReentrancyGuard {
    using SafeMath for uint256;
    uint256 public priceToFight = 0.001 ether; // price for test
    uint256 public priceToAdd = 0.0001 ether;  // price for test
    mapping(uint256 => address) dragonOwners;
    mapping(address => uint256) public ownerDragonsCount;
    mapping(uint256 => uint256) public dragonsListIndex;
    uint256[] public dragonsList;
    
    
    constructor(address payable _wallet) public {
        wallet = _wallet;
    }

    
    function addToFightPlace(uint256 _dragonID) external payable whenNotPaused nonReentrant {
        require(mainContract.isApprovedOrOwner(msg.sender, _dragonID), "Sender is not owner!");
        require(msg.value >= priceToAdd, "Not enough ether!");
        mainContract.checkDragonStatus(_dragonID, 2);
        uint256 valueToReturn = msg.value.sub(priceToAdd);
        if (priceToAdd != 0) {
            wallet.transfer(priceToAdd);
        }
        
        if (valueToReturn != 0) {
            msg.sender.transfer(valueToReturn);
        }
        dragonOwners[_dragonID] = mainContract.ownerOf(_dragonID);
        ownerDragonsCount[dragonOwners[_dragonID]]++;
        dragonsListIndex[_dragonID] = dragonsList.length;
        dragonsList.push(_dragonID);
        mainContract.setCurrentAction(_dragonID, 1);
        emit AddDragonFP(dragonOwners[_dragonID], _dragonID);
        
    }
    
    function delFromFightPlace(uint256 _dragonID) external {
        require(mainContract.isApprovedOrOwner(msg.sender, _dragonID), "Only owner or approved address can do this!");
        emit RemoveDragonFP(dragonOwners[_dragonID], _dragonID);
        _delItem(_dragonID);
    }

    function fightWithDragon(uint256 _yourDragonID,uint256 _thisDragonID) external payable whenNotPaused nonReentrant {
        require(msg.value >= priceToFight, "Not enough ether!");
        require(mainContract.isApprovedOrOwner(msg.sender, _yourDragonID), "Sender is not owner!");
        uint8 stage;
        uint8 currentAction;
        uint256 nextBlock2Action;
        (,stage,currentAction,,nextBlock2Action) = mainContract.dragons(_yourDragonID);
        require(stage >= 2, "No eggs, No dead dragons!");
        require(nextBlock2Action <= block.number, "Dragon is resting!");
        require(currentAction == 0 || currentAction == 1, "Dragon is busy!");
        uint256 valueToReturn = msg.value - priceToFight;
        if (priceToFight != 0) {
            wallet.transfer(priceToFight);
        }
        if (valueToReturn != 0) {
            msg.sender.transfer(valueToReturn);
        }
        if (dragonsFightContract.getWinner(_yourDragonID, _thisDragonID) == _yourDragonID ) {
            _setFightResult(_yourDragonID, _thisDragonID);
            _closeFight(_yourDragonID, _thisDragonID);
            emit FightFP(_yourDragonID, _thisDragonID, mainContract.ownerOf(_dragonID), dragonOwners[_thisDragonID]);
        } else {
            _setFightResult(_thisDragonID, _yourDragonID);
            _closeFight(_thisDragonID, _yourDragonID);
            emit FightFP(_thisDragonID, _yourDragonID, dragonOwners[_thisDragonID], mainContract.ownerOf(_dragonID));
        }
        _delItem(_thisDragonID);
        if (dragonOwners[_yourDragonID] != address(0))
            _delItem(_yourDragonID);
    }
    function getAllDragonsFight() external view returns(uint256[] memory) {
        return dragonsList;
    }
    function getSlicedDragonsSale(uint256 _firstIndex, uint256 _aboveLastIndex) external view returns(uint256[] memory) {
        require(_firstIndex < dragonsList.length, "First index greater than totalDragonsToFight");
        uint256 lastIndex = _aboveLastIndex;
        if (_aboveLastIndex > dragonsList.length) lastIndex = dragonsList.length;
        require(_firstIndex <= lastIndex, "First index greater than Last Index");
        uint256 resultCount = lastIndex - _firstIndex;
        if (resultCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](resultCount);
            uint256 _dragonIndex;
            uint256 _resultIndex = 0;

            for (_dragonIndex = _firstIndex; _dragonIndex < lastIndex; _dragonIndex++) {
                result[_resultIndex] = dragonsList[_dragonIndex];
                _resultIndex++;
            }

            return result;
        }
    }
    function getFewDragons(uint256[] calldata _dragonIDs) external view returns(uint256[] memory) {
        uint256 dragonCount = _dragonIDs.length;
        if (dragonCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](dragonCount * 3);
            uint256 resultIndex = 0;

            for (uint256 dragonIndex = 0; dragonIndex < dragonCount; dragonIndex++) {
                uint256 dragonID = _dragonIDs[dragonIndex];
                if (dragonOwners[dragonID] == address(0))
                    continue;
                result[resultIndex++] = dragonID;
                uint8 dragonStage;
                (,dragonStage,,,) = mainContract.dragons(dragonID);
                result[resultIndex++] = uint256(dragonStage);
                result[resultIndex++] = uint256(dragonOwners[dragonID]);
            }
            return result; 
        }
    }
    function getAddressDragons(address _owner) external view returns(uint256[] memory) {
        uint256 dragonCount = ownerDragonsCount[_owner];
        if (dragonCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](dragonCount * 2);
            uint256 resultIndex = 0;

            for (uint256 dragonIndex = 0; dragonIndex < dragonsList.length; dragonIndex++) {
                uint256 dragonID = dragonsList[dragonIndex];
                if (_owner != dragonOwners[dragonID])
                    continue;
                result[resultIndex++] = dragonID;
                uint8 dragonStage;
                (,dragonStage,,,) = mainContract.dragons(dragonID);
                result[resultIndex++] = uint256(dragonStage);
            }
            return result; 
        }
    }
    function totalDragonsToFight() external view returns(uint256) {
        return dragonsList.length;
    }
    function _delItem(uint256 _dragonID) private {
        require(dragonOwners[_dragonID] != address(0), "An attempt to remove an unregistered dragon");
        mainContract.setCurrentAction(_dragonID, 0);
        ownerDragonsCount[dragonOwners[_dragonID]]--;
        delete(dragonOwners[_dragonID]);
        if (dragonsList.length - 1 != dragonsListIndex[_dragonID]) {
            dragonsList[dragonsListIndex[_dragonID]] = dragonsList[dragonsList.length - 1];
            dragonsListIndex[dragonsList[dragonsList.length - 1]] = dragonsListIndex[_dragonID];
        }
        dragonsList.length--;
        delete(dragonsListIndex[_dragonID]);
    }
    function _setFightResult(uint256 _dragonWin, uint256 _dragonLose) private {
        dragonsStatsContract.incFightWin(_dragonWin);
        dragonsStatsContract.incFightLose(_dragonLose);
        dragonsStatsContract.setLastAction(_dragonWin, _dragonLose, 13);
        dragonsStatsContract.setLastAction(_dragonLose, _dragonWin, 14);
    }
    function _closeFight(uint256 _dragonWin, uint256 _dragonLose) private {
        mainContract.setTime2Rest(_dragonWin, addTime2Rest);
        mainContract.setTime2Rest(_dragonLose, addTime2Rest);
        mutagenContract.mint(mainContract.ownerOf(_dragonWin), mutagenToWin);
        mutagenContract.mint(mainContract.ownerOf(_dragonLose), mutagenToLose);
    }
    function clearFightPlace(uint256[] calldata _dragonIDs) external onlyAdmin whenPaused {
        uint256 dragonCount = _dragonIDs.length;
        for (uint256 dragonIndex = 0; dragonIndex < dragonCount; dragonIndex++) {
            uint256 dragonID = _dragonIDs[dragonIndex];
            if (dragonOwners[dragonID] != address(0))
                _delItem(dragonID);
        }
    }
    function changePrices(uint256 _priceToFight,uint256 _priceToAdd) external onlyAdmin {
        priceToFight = _priceToFight;
        priceToAdd = _priceToAdd;
    }
}

