pragma solidity ^0.4.21;

import "./security/rbac/RBACWithAdmin.sol";

contract GenRNG {

    function getNewGens(address _from, uint256 _dragonID) external returns (uint256[2] resultGen);
}

contract FixMarketPlace {

    function addToFixMarketPlace(address _dragonOwner, uint256 _dragonID, uint256 _dragonPrice, uint256 _endBlockNumber) external returns (bool sucsses);
}

contract DragonStats {
    function setParents(uint256 _dragonID, uint256 _parentOne, uint256 _parentTwo) external;
    function setBirthBlock(uint256 _dragonID) external;
    function incChildren(uint256 _dragonID) external;
}
contract DragonETH_GC is RBACWithAdmin {
    GenRNG public genRNGContractAddress;
    FixMarketPlace public fmpContractAddress;
    DragonStats public dragonStatsContract;
    address wallet;
    
    uint256 public secondsInBlock = 15;
    uint256 public price2DecraseTime2Action = 0.00005 ether; //  1 block

    function changeGenRNGcontractAddress(address _genRNGContractAddress) external onlyAdmin {
        genRNGContractAddress = GenRNG(_genRNGContractAddress);
    }
    function changeFMPcontractAddress(address _fmpContractAddress) external onlyAdmin {
        fmpContractAddress = FixMarketPlace(_fmpContractAddress);
    }
    function changeSecondsInBlock(uint256 _secondsInBlock) external onlyAdmin {
        secondsInBlock = _secondsInBlock;
    }
    function changeDragonStatsContract(address _dragonStatsContract) external onlyAdmin {
        dragonStatsContract = DragonStats(_dragonStatsContract);
    }
    function changeWallet(address _wallet) external onlyAdmin {
        wallet = _wallet;
    }
    function changePrice2DecraseTime2Action(uint256 _price2DecraseTime2Action) external onlyAdmin {
        price2DecraseTime2Action = _price2DecraseTime2Action;
    }
    function withdrawAllEther() external onlyAdmin {
        require(wallet != 0);
        wallet.transfer(address(this).balance);
    }
}