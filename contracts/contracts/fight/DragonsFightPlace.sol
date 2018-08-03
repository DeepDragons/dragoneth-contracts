pragma solidity ^0.4.24;

import "./DragonsFightGC.sol";
import "../security/ReentrancyGuard.sol";

//TODO check to safeMath, add money return, refactor GC contract
contract DragonsFightPlace is DragonsFightGC, ReentrancyGuard {
    
    uint256 public totalDragonsToFight;
    uint256 public priceToFight = 0.001 ether; // price for test
    uint256 public priceToAdd = 0;  // price for test
    mapping(uint256 => address) dragonOwners;
    mapping(address => uint256) public ownerDragonsCount;
    uint256[] public dragonsList; 
    mapping(uint256 => uint256) public dragonsListIndex;

    constructor(address _wallet) public {
        wallet = _wallet;
    }

    function _delItem(uint256 _dragonID) private {
        require(dragonOwners[_dragonID] != address(0));
        mainContract.setCurrentAction(_dragonID, 0);
        ownerDragonsCount[dragonOwners[_dragonID]] -= 1;
        delete(dragonOwners[_dragonID]);
//TODO check it to end of array, and 1 element array
        if (totalDragonsToFight > 1) {
            uint256 tmpDragonID;
            tmpDragonID = dragonsList[dragonsList.length - 1];
            dragonsList[dragonsListIndex[_dragonID]] = tmpDragonID;
            dragonsListIndex[tmpDragonID] = dragonsListIndex[_dragonID];
        }
        dragonsList.length--;
        delete(dragonsListIndex[_dragonID]);
        totalDragonsToFight--;
    }
    
    function _setFightResult(uint256 _dragonWin, uint256 _dragonLose) private {
        dragonsStatsContract.incFightWin(_dragonWin);
        dragonsStatsContract.incFightLose(_dragonLose);
        dragonsStatsContract.setLastAction(_dragonWin, _dragonLose, 13);
        dragonsStatsContract.setLastAction(_dragonLose, _dragonWin, 14);
        emit Fight(_dragonWin, _dragonLose);
            
    }
    
    function _closeFight(uint256 _dragonWin, uint256 _dragonLose) private {
        mainContract.setTime2Rest(_dragonWin, addTime2Rest);
        mainContract.setTime2Rest(_dragonLose, addTime2Rest);
        mutagenContract.mint(mainContract.ownerOf(_dragonWin), mutagenToWin);
        mutagenContract.mint(mainContract.ownerOf(_dragonLose), mutagenToLose);
    }
    
    function addToFightPlace(uint256 _dragonID) external payable whenNotPaused nonReentrant {
        require(mainContract.isApprovedOrOwner(msg.sender, _dragonID));
        require(msg.value >= priceToAdd);
        mainContract.checkDragonStatus(_dragonID, 2);
        uint256 valueToReturn = msg.value - priceToAdd;
        if (priceToAdd != 0) {
            wallet.transfer(priceToAdd);
        }
        
        if (valueToReturn != 0) {
            msg.sender.transfer(valueToReturn);
        }
        dragonOwners[_dragonID] = mainContract.ownerOf(_dragonID);
        ownerDragonsCount[dragonOwners[_dragonID]] += 1;
        dragonsListIndex[_dragonID] = dragonsList.length;
        dragonsList.push(_dragonID);
        totalDragonsToFight++;
        mainContract.setCurrentAction(_dragonID, 1);
        
    }
    
    function delFromFightPlace(uint256 _dragonID) external {
        require(mainContract.isApprovedOrOwner(msg.sender, _dragonID));
        _delItem(_dragonID);
    }

    function fightWithDragon(uint256 _yourDragonID,uint256 _thisDragonID) external payable whenNotPaused nonReentrant {
        require(msg.value >= priceToFight);
        require(mainContract.isApprovedOrOwner(msg.sender, _yourDragonID));
        mainContract.checkDragonStatus(_yourDragonID, 2);
        uint256 valueToReturn = msg.value - priceToFight;
        if (priceToFight != 0) {
            wallet.transfer(priceToFight);
        }
        if (valueToReturn != 0) {
            msg.sender.transfer(valueToReturn);
        }
        // TODO check for gas usage
        if (dragonsFightContract.getWinner(_yourDragonID, _thisDragonID) == _yourDragonID ) {
            _setFightResult(_yourDragonID, _thisDragonID);
            _closeFight(_yourDragonID, _thisDragonID);
            
        } else {
            _setFightResult(_thisDragonID, _yourDragonID);
            _closeFight(_thisDragonID, _yourDragonID);
        }
        _delItem(_thisDragonID);        
    }
    
    function getAllDragonsFight() external view returns(uint256[]) {
        return dragonsList;
    }
    
    function getFewDragons(uint256[] _dragonIDs) external view returns(uint256[]) {
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
    
    function getAddressDragons(address _owner) external view returns(uint256[]) {
        uint256 dragonCount = ownerDragonsCount[_owner];
        if (dragonCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](dragonCount * 2);
            uint256 resultIndex = 0;

            for (uint256 dragonIndex = 0; dragonIndex < totalDragonsToFight; dragonIndex++) {
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
    
    function clearFightPlace(uint256[] _dragonIDs) external onlyAdmin whenPaused {
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

