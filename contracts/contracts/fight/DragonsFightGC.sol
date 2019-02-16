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
    Dragon[] public dragons;
    
    function ownerOf(uint256 _tokenId) public view returns (address);
    function checkDragonStatus(uint256 _dragonID, uint8 _stage) public view;
    function setCurrentAction(uint256 _dragonID, uint8 _currentAction) external;
    function setTime2Rest(uint256 _dragonID, uint256 _addNextBlock2Action) external;
    function isApprovedOrOwner(address _spender, uint256 _tokenId) public view returns (bool);

    
}

contract DragonsFight {
    function getWinner(uint256 _dragonOneID, uint256 _dragonTwoID) external returns (uint256 _winerID);
}

contract DragonsStats {
    function incFightWin(uint256 _dragonID) external;
    function incFightLose(uint256 _dragonID) external;
    function setLastAction(uint256 _dragonID, uint256 _lastActionDragonID, uint8 _lastActionID) external;
}

contract Mutagen {
    function mint(address _to, uint256 _amount)  public returns (bool);
}

contract DragonsFightGC is Pausable {
    Mutagen public mutagenContract;
    DragonsETH public mainContract;
    DragonsFight public dragonsFightContract;
    DragonsStats public dragonsStatsContract;
    address payable wallet;
    uint256 public mutagenToWin = 10;
    uint256 public mutagenToLose =1;
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
    function changeMutagenToWin(uint256 _mutagenToWin) external onlyAdmin {
        mutagenToWin = _mutagenToWin;
    }
    
    function changeMutagenToLose(uint256 _mutagenToLose) external onlyAdmin {
        mutagenToLose = _mutagenToLose;
    }
    function changeAddTime2Rest(uint256 _addTime2Rest) external onlyAdmin {
        addTime2Rest = _addTime2Rest;
    }
    function withdrawAllEther() external onlyAdmin {
        require(wallet != address(0), "Withdraw address can't be zero!");
        wallet.transfer(address(this).balance);
    }
}