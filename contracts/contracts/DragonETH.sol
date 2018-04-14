pragma solidity ^0.4.21;

import "./ERC721/ERC721Token.sol";
import "./DragonETH_GC.sol";

// FOR TEST remove in war deploy
// contract DragonETH is ERC721Token("DragonETH game", "DragonETH"), DragonETH_GC {
contract DragonETH is ERC721Token("Test game", "Test"), DragonETH_GC {
    uint256 public totalDragons;
    struct Dragon {
        uint256 gen1;
        uint8 stage; // 0 - Dead, 1 - Egg, 2 - Dragon 
        uint8 currentAction; // 0 - free, 1 - egg?,  
        uint240 gen2;
        uint256 nextBlock2Action;
    }
    Dragon[] dragons;
    
   
    function DragonETH() public {
 
        _mint(msg.sender, 0);
        Dragon memory _dragon = Dragon({
            gen1: 0,
            stage: 0,
            currentAction: 0,
            gen2: 0,
            nextBlock2Action: 0
        });
        dragons.push(_dragon);
    }
   
    function addToFixMarketPlace(uint256 _dragonID, uint256 _dragonPrice, uint256 _endBlockNumber) external  {
        require(msg.sender == ownerOf(_dragonID));
        if (fmpContractAddress.addToFixMarketPlace(msg.sender, _dragonID, _dragonPrice, _endBlockNumber)) {
        transferFrom(msg.sender,fmpContractAddress,_dragonID);
        }
    }

    function getDragonGens(uint256 _dragonID) external view returns(bytes32 _res1, bytes32 _res2 ) {
        
    _res1 = bytes32(dragons[_dragonID].gen1);
    _res2 = bytes32(dragons[_dragonID].gen2);
    }
    function createDragon(address _to, uint256 _timeToBorn, uint256 _parentOne, uint256 _parentTwo, uint256 _gen1, uint240 _gen2) external onlyRole("CreateAgent") {
        totalDragons++;
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
    
}
