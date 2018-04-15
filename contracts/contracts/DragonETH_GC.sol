pragma solidity ^0.4.21;

import "./security/rbac/RBACWithAdmin.sol";

contract GenRNG {

    function getNewGens(address _from, uint256 _dragonID) external returns (uint256[2] resultGen);
}

contract FixMarketPlace {

    function addToFixMarketPlace(address _dragonOwner, uint256 _dragonID, uint256 _dragonPrice, uint256 _endBlockNumber) external returns (bool sucsses);
}
contract Auction {
    function add2Auction(address _dragonOwner, uint256 _dragonID, uint256 _startPrice, uint256 _step, uint256 _endPrice, uint256 _endBlockNumber) external returns (bool sucsses);
}
contract DragonSelectFight2Death {
    function add2SelctFight2Death(address _dragonOwner, uint256 _yourDragonID, uint256 _oppDragonID, uint256 _endBlockNumber) external;
}
contract DragonsRandomFight2Death {
    function add2RandomFight2Death(address _dragonOwner, uint256 _DragonID) external;
}
contract Mutagen2Face {
    function addDragon(address _dragonOwner, uint256 _dragonID, uint256 mutagenCount) external;
}

contract DragonStats {
    function setParents(uint256 _dragonID, uint256 _parentOne, uint256 _parentTwo) external;
    function setBirthBlock(uint256 _dragonID) external;
    function incChildren(uint256 _dragonID) external;
    function setDeathBlock(uint256 _dragonID) external;
}
contract Necropolis {
     function addDragon(address _lastDragonOwner, uint256 _dragonID, uint256 _deathReason) external;
}
contract DragonETH_GC is RBACWithAdmin {
    GenRNG public genRNGContractAddress;
    FixMarketPlace public fmpContractAddress;
    DragonStats public dragonStatsContract;
    Necropolis public necropolisContract;
    Auction public auctionContract;
    DragonSelectFight2Death public selectFight2DeathContract;
    DragonsRandomFight2Death public randomFight2DeathContract;
    Mutagen2Face public mutagen2FaceContract;
    
    address wallet;
    
    uint256 public secondsInBlock = 15;
    uint256 public price2DecraseTime2Action = 0.00005 ether; //  1 block
    uint256 constant UINT256_MAX = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

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
    function changeAuctionContract(address _auctionContract) external onlyAdmin {
        auctionContract = Auction(_auctionContract);
    }
    function changeSelectFight2DeathContract(address _selectFight2DeathContract) external onlyAdmin {
        selectFight2DeathContract = DragonSelectFight2Death(_selectFight2DeathContract);
    }
    function changeRandomFight2DeathContract(address _randomFight2DeathContract) external onlyAdmin {
        randomFight2DeathContract = DragonsRandomFight2Death(_randomFight2DeathContract);
    }
    function changeMutagen2FaceContract(address _mutagen2FaceContract) external onlyAdmin {
        mutagen2FaceContract = Mutagen2Face(_mutagen2FaceContract);
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