pragma solidity ^0.4.21;

import "./ERC721/ERC721Token.sol";
import "./DragonETH_GC.sol";

// FOR TEST remove in war deploy
// contract DragonETH is ERC721Token("DragonETH game", "DragonETH"), DragonETH_GC {
contract DragonETH is ERC721Token("Test game", "Test"), DragonETH_GC {
    uint256 public totalDragons;
    uint256 public liveDragons;
    uint256 public deadDragons;
    struct Dragon {
        uint256 gen1;
        uint8 stage; // 0 - Dead, 1 - Egg, 2 - Young Dragon 
        uint8 currentAction; // 0 - free, 1 - fight place, 0xFF - Necropolis,  
        uint240 gen2;
        uint256 nextBlock2Action;
    }
    Dragon[] public dragons;
    
   
    function DragonETH(address _wallet, address _necropolisContract) public {
        
        _mint(msg.sender, 0);
        Dragon memory _dragon = Dragon({
            gen1: 0,
            stage: 0,
            currentAction: 0,
            gen2: 0,
            nextBlock2Action: UINT256_MAX
        });
        dragons.push(_dragon);
        necropolisContract = Necropolis(_necropolisContract);
        wallet = _wallet;
    }
   
    function addToFixMarketPlace(uint256 _dragonID, uint256 _dragonPrice, uint256 _endBlockNumber) external onlyOwnerOf(_dragonID)  {
        require(dragons[_dragonID].stage != 0); // dragon not dead
        if (dragons[_dragonID].stage >=2) {
            checkDragonStatus(_dragonID, 2);
        }
        if (fmpContractAddress.addToFixMarketPlace(msg.sender, _dragonID, _dragonPrice, _endBlockNumber)) {
        transferFrom(msg.sender,fmpContractAddress,_dragonID);
        }
    }

    
    function createDragon(address _to, uint256 _timeToBorn, uint256 _parentOne, uint256 _parentTwo, uint256 _gen1, uint240 _gen2) external onlyRole("CreateAgent") {
        totalDragons++;
        liveDragons++;
        // TODO add chek to safeTransfer
        _mint(_to, totalDragons);
        uint256[2] memory twoGen;
        if (_parentOne == 0 && _parentTwo == 0 && _gen1 == 0 && _gen2 == 0) {
            twoGen = genRNGContractAddress.getNewGens(_to, totalDragons);
        } else {
            twoGen[0] = _gen1;
            twoGen[1] = uint256(_gen2);
        }
        Dragon memory _dragon = Dragon({
            gen1: twoGen[0],
            stage: 1,
            currentAction: 0,
            gen2: uint240(twoGen[1]),
            nextBlock2Action: _timeToBorn 
        });
        dragons.push(_dragon);
        if (_parentOne !=0) {
            dragonStatsContract.setParents(totalDragons,_parentOne,_parentTwo);
            dragonStatsContract.incChildren(_parentOne);
            dragonStatsContract.incChildren(_parentTwo);
        }
        dragonStatsContract.setBirthBlock(totalDragons);
    }
    function birthDragon(uint256 _dragonID) external onlyOwnerOf(_dragonID) {
        require(dragons[_dragonID].nextBlock2Action <= block.number);
        dragons[_dragonID].stage = 2;
    }
    function killDragon(uint256 _dragonID) external onlyOwnerOf(_dragonID) {
        checkDragonStatus(_dragonID, 2);
        dragons[_dragonID].stage = 0;
        dragons[_dragonID].currentAction = 0xFF;
        dragons[_dragonID].nextBlock2Action = UINT256_MAX;
        necropolisContract.addDragon(ownerOf(_dragonID), _dragonID, 1);
        transferFrom(msg.sender,necropolisContract,_dragonID);
        dragonStatsContract.setDeathBlock(_dragonID);
        liveDragons--;
        deadDragons++;
        
    }
    function decraseTimeToAction(uint256 _dragonID) external payable onlyOwnerOf(_dragonID) {
        require(msg.value >= price2DecraseTime2Action);
        require(dragons[_dragonID].nextBlock2Action > block.number);
        uint256 maxBlockCount = dragons[_dragonID].nextBlock2Action - block.number;
        if (msg.value > maxBlockCount * price2DecraseTime2Action) {
            msg.sender.transfer(msg.value - maxBlockCount * price2DecraseTime2Action);
            wallet.transfer(maxBlockCount * price2DecraseTime2Action);
            dragons[_dragonID].nextBlock2Action = 0;
        } else {
            if (price2DecraseTime2Action == 0) {
                dragons[_dragonID].nextBlock2Action = 0;
            } else {
                wallet.transfer(msg.value);
                dragons[_dragonID].nextBlock2Action =  dragons[_dragonID].nextBlock2Action - msg.value / price2DecraseTime2Action;
            }
            
            
            
        }
        
    }
    function checkDragonStatus(uint256 _dragonID, uint8 _stage) public view {
        require(dragons[_dragonID].stage != 0); // dragon not dead
         // dragon not in action and not in rest  and not egg
        require(dragons[_dragonID].nextBlock2Action <= block.number && dragons[_dragonID].currentAction == 0 && dragons[_dragonID].stage >=_stage);
    }
    function setCurrentAction(uint256 _dragonID, uint8 _currentAction) external onlyRole("ActionContract") {
        dragons[_dragonID].currentAction = _currentAction;
    }
    function setTime2Rest(uint256 _dragonID, uint256 _addNextBlock2Action) external onlyRole("ActionContract") {
        dragons[_dragonID].nextBlock2Action = block.number + _addNextBlock2Action;
    }
    
    
    
    function getDragonGens(uint256 _dragonID) external view returns(bytes32 _res1, bytes32 _res2 ) {
        
    _res1 = bytes32(dragons[_dragonID].gen1);
    _res2 = bytes32(dragons[_dragonID].gen2);
    }
    
}
