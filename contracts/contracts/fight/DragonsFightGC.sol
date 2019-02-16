pragma solidity ^0.5.4;

import "../security/Pausable.sol";

contract DragonsETH {
    struct Dragon {
        uint256 gen1;
        uint8 stage; // 0 - Dead, 1 - Egg, 2 - Young Dragon 
        uint8 currentAction; // 0 - free, 1 - fight place, 0xFF - Necropolis,  2 - random fight,
                             // 3 - breed market, 4 - breed auction, 5 - random breed, 6 - market place ...
        uint240 gen2;
        uint256 nextBlock2Action;
    }
//mybe function????
    Dragon[] public dragons;
    
    function ownerOf(uint256 _tokenId) public view returns (address);
    function checkDragonStatus(uint256 _dragonID, uint8 _stage) public view;
    function setCurrentAction(uint256 _dragonID, uint8 _currentAction) external;
    function setTime2Rest(uint256 _dragonID, uint256 _addNextBlock2Action) external;
    function transferFrom(address _from, address _to, uint256 _tokenId) public;
    function killDragonDeathContract(address _lastOwner, uint256 _dragonID, uint256 _deathReason) external;
    function isApprovedOrOwner(address _spender, uint256 _tokenId) public view returns (bool);

    
}

contract DragonsFight {
    function getWinner(uint256 _dragonOneID, uint256 _dragonTwoID) external returns (uint256 _winerID);
}

contract DragonsStats {
    function incFightWin(uint256 _dragonID) external;
    function incFightLose(uint256 _dragonID) external;
    function incFightToDeathWin(uint256 _dragonID) external;
    function setLastAction(uint256 _dragonID, uint256 _lastActionDragonID, uint8 _lastActionID) external;
}

contract Mutagen {
    function mint(address _to, uint256 _amount)  public returns (bool);
}

contract DragonsFightGC is Pausable {
//    using SafeMath for uint256;
    Mutagen public mutagenContract;
    DragonsETH public mainContract;
    DragonsFight public dragonsFightContract;
    DragonsStats public dragonsStatsContract;
    address payable wallet;
    uint256 public minFightWaitBloc = 80; // ~20 min
    uint256 public maxFightWaitBloc = 172800; // ~30 days??????
    uint256 public mutagenToWin = 10;
    uint256 public mutagenToLose =1;
    uint256 public mutagenToDeathWin = 100;
    uint256 public addTime2Rest = 240; // ~ 60 min
    
    event FightFP(uint256 _winnerId, uint256 _loserId, address _ownerWinner, address _onwerLoser);
    event AddDragonFP(address indexed _from, uint256 _tokenId);
    event RemoveDragonFP(address indexed _from, uint256 _tokenId);
    
 
    function changeAddressMutagenContract(address _newAddress) external onlyAdmin {
        mutagenContract = Mutagen(_newAddress);
    }
    function changeAddressMainContract(address _newAddress) external onlyAdmin {
        mainContract = DragonsETH(_newAddress);
    }
    function changeAddressFightContract(address _newAddress) external onlyAdmin {
        dragonsFightContract = DragonsFight(_newAddress);
    }
    function changeAddressStatsContract(address _newAddress) external onlyAdmin {
        dragonsStatsContract = DragonsStats(_newAddress);
    }
    function changeWallet(address payable _wallet) external onlyAdmin {
        wallet = _wallet;
    }

    function changeMinFightWaitBloc(uint256 _minFightWaitBloc) external onlyAdmin {
        minFightWaitBloc = _minFightWaitBloc;
    }

    function changeMaxFightWaitBloc(uint256 _maxFightWaitBloc) external onlyAdmin {
        maxFightWaitBloc = _maxFightWaitBloc;
    }
    
    function changeMutagenToWin(uint256 _mutagenToWin) external onlyAdmin {
        mutagenToWin = _mutagenToWin;
    }
    
    function changeMutagenToLose(uint256 _mutagenToLose) external onlyAdmin {
        mutagenToLose = _mutagenToLose;
    }
    
    function changeMutagenToDeathWin(uint256 _mutagenToDeathWin) external onlyAdmin {
        mutagenToDeathWin = _mutagenToDeathWin;
    }
    function changeAddTime2Rest(uint256 _addTime2Rest) external onlyAdmin {
        addTime2Rest = _addTime2Rest;
    }
    function withdrawAllEther() external onlyAdmin {
        require(wallet != address(0), "Withdraw address can't be zero!");
        wallet.transfer(address(this).balance);
    }
}