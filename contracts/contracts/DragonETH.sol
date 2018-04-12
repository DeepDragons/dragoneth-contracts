pragma solidity ^0.4.21;

import "./ERC721/ERC721Token.sol";
import "./DragonETH_GC.sol";

contract DragonETH is ERC721Token("DragonETH game", "DragonETH"), DragonETHgameControl {
    uint256 public totalDragons;
    struct Dragon {
        uint256 gen1;
        uint256 gen2;
    }
    Dragon[] dragons;
    
   
    function DragonETH() public {
 
        _mint(msg.sender, 0);
        Dragon memory _dragon = Dragon({
            gen1: 0,
            gen2: 0
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
    function createDragon(address _to) external onlyRole("CreateAgent") {
        totalDragons++;
        // TODO add chek to safeTransfer
        _mint(_to, totalDragons);
        uint256[2] memory twoGen = genRNGContractAddress.getNewGens(_to, totalDragons);
        Dragon memory _dragon = Dragon({
            gen1: twoGen[0],
            gen2: twoGen[1]
        });
        dragons.push(_dragon);
    }
    
}
