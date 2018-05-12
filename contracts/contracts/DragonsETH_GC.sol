pragma solidity ^0.4.23;


import "./security/rbac/RBACWithAdmin.sol";


contract GenRNG {

    function getNewGens(address _from, uint256 _dragonID) external returns (uint256[2] resultGen);
}


contract FixMarketPlace {
    function add2MarketPlace(address _dragonOwner, uint256 _dragonID, uint256 _dragonPrice, uint256 _endBlockNumber) external returns (bool);
}


contract Auction {
    function add2Auction(
        address _dragonOwner, 
        uint256 _dragonID, 
        uint256 _startPrice, 
        uint256 _step, 
        uint256 _endPrice, 
        uint256 _endBlockNumber
    ) 
        external 
        returns (bool);
}


contract DragonSelectFight2Death {
    function addSelctFight2Death(
        address _dragonOwner, 
        uint256 _yourDragonID, 
        uint256 _oppDragonID, 
        uint256 _endBlockNumber, 
        uint256 _priceSelectFight2Death
    ) 
        external;
}


contract DragonsRandomFight2Death {
    function addRandomFight2Death(address _dragonOwner, uint256 _DragonID) external;
}


contract Mutagen2Face {
    function addDragon(address _dragonOwner, uint256 _dragonID, uint256 mutagenCount) external;
}


contract SuperContract {
    function checkDragon(uint256 _dragonID) external returns (bool);
}


contract DragonsStats {
    function setParents(uint256 _dragonID, uint256 _parentOne, uint256 _parentTwo) external;
    function setBirthBlock(uint256 _dragonID) external;
    function incChildren(uint256 _dragonID) external;
    function setDeathBlock(uint256 _dragonID) external;
    function getDragonFight(uint256 _dragonID) external view returns (uint256);
}


contract Necropolis {
    function addDragon(address _lastDragonOwner, uint256 _dragonID, uint256 _deathReason) external;
}


contract DragonsETH_GC is RBACWithAdmin {
    GenRNG public genRNGContractAddress;
    FixMarketPlace public fmpContractAddress;
    DragonsStats public dragonsStatsContract;
    Necropolis public necropolisContract;
    Auction public auctionContract;
    SuperContract public superContract;
    DragonSelectFight2Death public selectFight2DeathContract;
    DragonsRandomFight2Death public randomFight2DeathContract;
    Mutagen2Face public mutagen2FaceContract;
    
    address wallet;
    
    uint8 adultDragonStage = 3;
    bool stageThirdBegin = false;
    uint256 constant UINT256_MAX = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
    uint256 public secondsInBlock = 15;
    uint256 public priceDecraseTime2Action = 0.000005 ether; //  1 block
    uint256 public priceRandomFight2Death = 0.02 ether;
    uint256 public priceSelectFight2Death = 0.03 ether;
    uint256 public priceChangeName = 0.01 ether;
    uint256 public needFightToAdult = 100;
    
    function changeGenRNGcontractAddress(address _genRNGContractAddress) external onlyAdmin {
        genRNGContractAddress = GenRNG(_genRNGContractAddress);
    }

    function changeFMPcontractAddress(address _fmpContractAddress) external onlyAdmin {
        fmpContractAddress = FixMarketPlace(_fmpContractAddress);
    }

    function changeDragonsStatsContract(address _dragonsStatsContract) external onlyAdmin {
        dragonsStatsContract = DragonsStats(_dragonsStatsContract);
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

    function changeSuperContract(address _superContract) external onlyAdmin {
        superContract = SuperContract(_superContract);
    }

    function changeWallet(address _wallet) external onlyAdmin {
        wallet = _wallet;
    }

    function changePriceDecraseTime2Action(uint256 _priceDecraseTime2Action) external onlyAdmin {
        priceDecraseTime2Action = _priceDecraseTime2Action;
    }

    function changePriceRandomFight2Death(uint256 _priceRandomFight2Death) external onlyAdmin {
        priceRandomFight2Death = _priceRandomFight2Death;
    }

    function changePriceSelectFight2Death(uint256 _priceSelectFight2Death) external onlyAdmin {
        priceSelectFight2Death = _priceSelectFight2Death;
    }

    function changePriceChangeName(uint256 _priceChangeName) external onlyAdmin {
        priceChangeName = _priceChangeName;
    }

    function changeSecondsInBlock(uint256 _secondsInBlock) external onlyAdmin {
        secondsInBlock = _secondsInBlock;
    }
    function changeNeedFightToAdult(uint256 _needFightToAdult) external onlyAdmin {
        needFightToAdult = _needFightToAdult;
    }

    function changeAdultDragonStage(uint8 _adultDragonStage) external onlyAdmin {
        adultDragonStage = _adultDragonStage;
    }

    function setStageThirdBegin() external onlyAdmin {
        stageThirdBegin = true;
    }

    function withdrawAllEther() external onlyAdmin {
        require(wallet != 0);
        wallet.transfer(address(this).balance);
    }
    
    // EIP-165 and EIP-721
    bytes4 constant ERC165_Signature = 0x01ffc9a7;
    bytes4 constant ERC721_Signature = 0x80ac58cd;
    bytes4 constant ERC721Metadata_Signature = 0x5b5e139f;
    bytes4 constant ERC721Enumerable_Signature = 0x780e9d63;
    
    function supportsInterface(bytes4 _interfaceID) external pure returns (bool) {
        return (
            (_interfaceID == ERC165_Signature) || 
            (_interfaceID == ERC721_Signature) || 
            (_interfaceID == ERC721Metadata_Signature) || 
            (_interfaceID == ERC721Enumerable_Signature)
        );
    }
}