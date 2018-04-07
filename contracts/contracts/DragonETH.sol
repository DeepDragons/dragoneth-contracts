pragma solidity ^0.4.21;

import "./ERC721/ERC721Token.sol";
import "./ContractInterface.sol";
import "./security/Whitelist.sol";

contract DragonETH is ERC721Token("DragonETH", "DETH"), Whitelist {
    uint256 public totalDragons;
    struct Dragon {
        uint256 gen1;
        uint256 gen2;
    }
    Dragon[] dragons;
    // Re designe?
    GenRNG private genRNGContractAddress;
    FixMarketPlace public fmpContractAddress;

    function DragonETH(address _genRNGContractAddress, address _fmpContractAddress) public {
 
        _mint(msg.sender, 0);
        Dragon memory _dragon = Dragon({
            gen1: 0,
            gen2: 0
        });
        dragons.push(_dragon);
        genRNGContractAddress = GenRNG(_genRNGContractAddress);
        fmpContractAddress = FixMarketPlace(_fmpContractAddress);
    }
    // Re designe?
    function changeRNGcontractAddress(address _genRNGContractAddress) external onlyOwner {
        genRNGContractAddress = GenRNG(_genRNGContractAddress);
    }
    // Re designe?
    function changeFMPcontractAddress(address _fmpContractAddress) external onlyOwner {
        fmpContractAddress = FixMarketPlace(_fmpContractAddress);
    }
    // Re designe?
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
    function createDragon(address _to) external onlyWhitelisted() {
        totalDragons++;
        _mint(_to, totalDragons);
        uint256[2] memory twoGen = genRNGContractAddress.getNewGens(_to, totalDragons);
        Dragon memory _dragon = Dragon({
            gen1: twoGen[0],
            gen2: twoGen[1]
        });
        dragons.push(_dragon);
    }
    
}
