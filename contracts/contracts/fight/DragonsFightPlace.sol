pragma solidity ^0.4.24;

import "./DragonsFightGC.sol";

contract DragonsFightPlace is DragonsFightGC {
    
    uint256 public totalDragonsToFight;
    uint256 public priceToFight = 0.001 ether; // price for test
    uint256 public priceToAdd = 0;  // price for test
    mapping(uint256 => address) dragonsOwner;
    mapping(address => uint256) ownerDragonsCount;
//    mapping(uint256 => uint256) public dragonsEndBlock;
    uint256[] public dragonsList; 
    mapping(uint256 => uint256) dragonsListIndex;


    constructor(address _wallet) public {
        wallet = _wallet;
    }

    function _delItem(uint256 _dragonID) private {
        ownerDragonsCount[dragonsOwner[_dragonID]] -= 1;
        delete(dragonsOwner[_dragonID]);
//        delete(dragonsEndBlock[_dragonID]);
        if (totalDragonsToFight > 1) {
            uint256 tmp;
            tmp = dragonsList[dragonsList.length - 1];
            dragonsList[dragonsListIndex[_dragonID]] = tmp;
            dragonsListIndex[tmp] = dragonsListIndex[_dragonID];
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
    
    function addToFightPlace(uint256 _dragonID) external payable whenNotPaused {
//        require(_endBlockNumber  > minFightWaitBloc);
//        require(_endBlockNumber < maxFightWaitBloc); //??????
        require(mainContract.isApprovedOrOwner(msg.sender, _dragonID));
        require(msg.value >= priceToAdd);
        mainContract.checkDragonStatus(_dragonID, 2);
        uint256 valueToReturn = msg.value - priceToAdd;
        if (priceToFight != 0) {
        wallet.transfer(priceToAdd);
        }
        
        if (valueToReturn != 0) {
            msg.sender.transfer(valueToReturn);
        }
        dragonsOwner[_dragonID] = mainContract.ownerOf(_dragonID);
//        dragonsEndBlock[_dragonID] = block.number + _endBlockNumber;
        ownerDragonsCount[dragonsOwner[_dragonID]] += 1;
        dragonsListIndex[_dragonID] = dragonsList.length;
        dragonsList.push(_dragonID);
        totalDragonsToFight++;
        mainContract.setCurrentAction(_dragonID, 1);
        
    }
    
    function delFromFightPlace(uint256 _dragonID) external {
        require(msg.sender == dragonsOwner[_dragonID]);
         mainContract.setCurrentAction(_dragonID, 0);
        _delItem(_dragonID);
    }

    function fightWithDragon(uint256 _yourDragonID,uint256 _thisDragonID) external payable whenNotPaused {
//        require(block.number <= dragonsEndBlock[_thisDragonID]);
        require(msg.value >= priceToFight);
        require(mainContract.ownerOf(_yourDragonID) == msg.sender);
        mainContract.checkDragonStatus(_yourDragonID, 2);
        uint256 valueToReturn = msg.value - priceToFight;
        if (priceToFight != 0) {
        wallet.transfer(priceToFight);
        }
        
        if (valueToReturn != 0) {
            msg.sender.transfer(valueToReturn);
        }

        if (dragonsFightContract.getWinner(_yourDragonID, _thisDragonID) == _yourDragonID ) {
            
            mutagenContract.mint(msg.sender,mutagenToWin);
            mutagenContract.mint(dragonsOwner[_thisDragonID],mutagenToLose);
            _setFightResult(_yourDragonID, _thisDragonID);
            
        } else {
            
            mutagenContract.mint(dragonsOwner[_thisDragonID],mutagenToWin);
            mutagenContract.mint(msg.sender,mutagenToLose);
            _setFightResult(_thisDragonID, _yourDragonID);
        }
        mainContract.setCurrentAction(_yourDragonID, 0);
        mainContract.setCurrentAction(_thisDragonID, 0);
        // TODO add rest time
        mainContract.setTime2Rest(_yourDragonID, addTime2Rest);
        mainContract.setTime2Rest(_thisDragonID, addTime2Rest);
        _delItem(_thisDragonID);        
    }
    function getAllDragonsFight() external view returns(uint256[]) {
        return dragonsList;
    }
/*
    function getDragonsTofight() external view returns(uint256[]) {
        

        if (totalDragonsToFight == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            // !!!!!! need to test on time go to future
            uint256[] memory result = new uint256[](totalDragonsToFight);
            uint256 _dragonIndex;
            uint256 _resultIndex = 0;

            for (_dragonIndex = 0; _dragonIndex < totalDragonsToFight; _dragonIndex++) {
                uint256 _dragonID = dragonsList[_dragonIndex];
                if (dragonsEndBlock[_dragonID] > block.number) {
                    result[_resultIndex] = _dragonID;
                    _resultIndex++;
                }
            }

            return result;
        }
    }
*/
    function getFewDragons(uint256[] _dragonIDs) external view returns(uint256[]) {
        uint256 dragonCount = _dragonIDs.length;
        if (dragonCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](dragonCount * 5);
            uint256 resultIndex = 0;

            for (uint256 dragonIndex = 0; dragonIndex < dragonCount; dragonIndex++) {
                uint256 dragonID = _dragonIDs[dragonIndex];
// chech to existance
                result[resultIndex++] = dragonID;
                uint8 tmp;
                (,tmp,,,)= mainContract.dragons(dragonID);
                result[resultIndex++] = uint256(tmp);
                result[resultIndex++] = uint256(dragonsOwner[dragonID]);
//                result[resultIndex++] = dragonPrices[dragonID];
//                result[resultIndex++] = dragonsEndBlock[dragonID];
                
            }

            return result; 
        }
    }
     function getAddressDragons(address _owner) external view returns(uint256[]) {
        uint256 dragonCount = ownerDragonsCount[_owner];
        if (dragonCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](dragonCount * 3);
            uint256 resultIndex = 0;

            for (uint256 dragonIndex = 0; dragonIndex < totalDragonsToFight; dragonIndex++) {
                uint256 dragonID = dragonsList[dragonIndex];
// chech to existance
                if (_owner != dragonsOwner[dragonID])
                    continue;
                result[resultIndex++] = dragonID;
                uint8 tmp;
                (,tmp,,,)= mainContract.dragons(dragonID);
                result[resultIndex++] = uint256(tmp);
//                result[resultIndex++] = uint256(dragonsOwner[dragonID]);
//                result[resultIndex++] = dragonPrices[dragonID];
//                result[resultIndex++] = dragonsEndBlock[dragonID];
                
            }

            return result; 
        }
    }
/*
    function clearStuxDragon(uint256 _start, uint256 _count) external whenNotPaused returns (uint256 _deleted) {
        uint256 _dragonIndex;
        
        for(_dragonIndex=_start; _dragonIndex < _start + _count && _dragonIndex < dragonsList.length; _dragonIndex++) {
            uint256 _dragonID = dragonsList[_dragonIndex];
            if (dragonsEndBlock[_dragonID] < block.number) {
                mainContract.setCurrentAction(_dragonID, 0);
                _delItem(_dragonID);
                _deleted++;
            }
        }
    }
   
    
*/

    function changePrices(uint256 _priceToFight,uint256 _priceToAdd) external onlyAdmin {
        priceToFight = _priceToFight;
        priceToAdd = _priceToAdd;
    }

   
}

