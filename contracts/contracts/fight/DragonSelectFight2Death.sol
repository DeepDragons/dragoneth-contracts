pragma solidity ^0.4.23;

import "./DragonsFightGC.sol";

contract DragonSelectFight2Death is DragonsFightGC {
    
    uint256 public totalDragonsToFight;
    uint256 public priceToFight = 0 ether; // price for test
    uint256 public priceToAdd = 0;  // price for test
    mapping(uint256 => address) dragonsOwner;
    mapping(uint256 => uint256) public dragonsEndBlock;
    uint256[] public dragonsList; 
    mapping(uint256 => uint256) dragonsListIndex;
    mapping(uint256 => uint256) callDragons;


    constructor(address _wallet) public {
        wallet = _wallet;
    }

    function _delItem(uint256 _dragonID) private {
        delete(dragonsOwner[_dragonID]);
        delete(dragonsEndBlock[_dragonID]);
        delete(callDragons[_dragonID]);
        if (totalDragonsToFight > 1) {
            dragonsList[dragonsListIndex[_dragonID]] = dragonsList[dragonsList.length - 1];
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
            
    }
    function addSelctFight2Death(address _dragonOwner, uint256 _yourDragonID, uint256 _oppDragonID, uint256 _endBlockNumber, uint256 _priceSelectFight2Death) external payable whenNotPaused {
    
        require(_endBlockNumber  > minFightWaitBloc);
        require(_endBlockNumber < maxFightWaitBloc); //??????
        
        require(msg.sender == address(mainContract));
        require(msg.value >= priceToAdd);
        
        uint256 valueToReturn = msg.value - priceToAdd;
        if (priceToFight != 0) {
        wallet.transfer(priceToAdd);
        }
        
        if (valueToReturn != 0) {
            msg.sender.transfer(valueToReturn);
        }
        if (callDragons[_oppDragonID] == _yourDragonID) {
            require(block.number <= dragonsEndBlock[_oppDragonID]);
                if (dragonsFightContract.getWinner(_yourDragonID, _oppDragonID) == _yourDragonID ) {
            
                    mutagenContract.mint(msg.sender,mutagenToWin);
                    mainContract.setTime2Rest(_yourDragonID, addTime2Rest);
// add stat change
//                    _setFightResult(_yourDragonID, _oppDragonID);
                    mainContract.transferFrom(address(this), _dragonOwner, _yourDragonID);
                    mainContract.killDragonDeathContract(dragonsOwner[_oppDragonID],_oppDragonID,3);
                    
                } else {
            
                    mutagenContract.mint(dragonsOwner[_oppDragonID],mutagenToWin);
                    mainContract.setTime2Rest(_oppDragonID, addTime2Rest);
//                    _setFightResult(_oppDragonID, _yourDragonID);
// add stat change
                    mainContract.transferFrom(address(this), dragonsOwner[_oppDragonID], _oppDragonID);
                    mainContract.killDragonDeathContract( _dragonOwner, _yourDragonID,3);

                }
                
        _delItem(_oppDragonID); 
        } else {
            
        dragonsOwner[_yourDragonID] = _dragonOwner;
        callDragons[_yourDragonID] = _oppDragonID;
        dragonsEndBlock[_yourDragonID] = block.number + _endBlockNumber;
        dragonsListIndex[_yourDragonID] = dragonsList.length;
        dragonsList.push(_yourDragonID);
        totalDragonsToFight++;
        }
        
    }
    
    function delFromFightPlace(uint256 _dragonID) external {
        require(msg.sender == dragonsOwner[_dragonID] || dragonsEndBlock[_dragonID] < block.number);
         mainContract.setCurrentAction(_dragonID, 0);
        _delItem(_dragonID);
    }

  
    function getAllDragonsFight() external view returns(uint256[]) {
        return dragonsList;
    }
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
   
    


    function changePrices(uint256 _priceToFight,uint256 _priceToAdd) external onlyAdmin {
        priceToFight = _priceToFight;
        priceToAdd = _priceToAdd;
    }

   
}

