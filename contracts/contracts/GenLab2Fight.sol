pragma solidity ^0.5.4;

import "./security/rbac/RBACWithAdmin.sol";

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

    function ownerOf(uint256 _tokenId) public view returns (address _owner);
    function setTime2Rest(uint256 _dragonID, uint256 _addNextBlock2Action) external;
    function changeDragonGen(uint256 _dragonID, uint256 _gen, uint8 _which) external;
}
contract Mutagen {
    function burn(address _from, uint256 _value) public;
}

contract DragonsStats {
    function setLastAction(uint256 _dragonID, uint256 _lastActionDragonID, uint8 _lastActionID) external;
    function incGenLabFight(uint256 _dragonID) external;
}

contract RNG {
    function get32b(address _from, uint256 _dragonID) external returns (bytes32 b32);
}

contract GenLab2Fight is RBACWithAdmin {
    Mutagen public mutagenContract;
    DragonsETH public mainContract;
    DragonsStats public dragonsStatsContract;
    address private addressRNG;
    address payable wallet;
    uint256 public addTime2Rest = 0;
    uint256 public mutagenCount = 100;
    uint256 public priceMutagenWork = 0.1 ether;
    uint256 public priceMax = 1 ether;
     
    event FightGensChanged(address indexed _owner, uint256 _dragonID, uint240 _oldGens, uint240 _newGens);

    constructor(address _mainContract, address _mutagen, address _stats, address payable _wallet) public {
        mainContract = DragonsETH(_mainContract);
        mutagenContract = Mutagen(_mutagen);
        dragonsStatsContract = DragonsStats(_stats);
        wallet = _wallet;
    }
    function setMaxGen(uint256 _dragonID, uint256 _genNum) external payable {
        _firstCheck(_dragonID, _genNum, priceMax);
        uint8 currentAction;
        uint240 gensDragon;
        uint256 nextBlock2Action;
        (,,currentAction,gensDragon,nextBlock2Action) = mainContract.dragons(_dragonID);
        require(currentAction == 0, "Dragon is busy!");
        require(nextBlock2Action <= block.number, "Dragon is resting!");
        uint8 genAdd = 0xFF - uint8(bytes30(gensDragon)[_genNum]);
        uint240 newGens = gensDragon + (uint240(genAdd) << (29 - _genNum) * 8);
        _setResault(_dragonID, gensDragon, newGens);
    }
    function mutateFightGenRandom(uint256 _dragonID, uint256 _genNum) external payable {
        mutagenContract.burn(msg.sender, mutagenCount);
        _firstCheck(_dragonID, _genNum, priceMutagenWork);
        bytes32 random_number = RNG(addressRNG).get32b(msg.sender, _dragonID);
        uint8 currentAction;
        uint240 gensDragon;
        uint256 nextBlock2Action;
        (,,currentAction,gensDragon,nextBlock2Action) = mainContract.dragons(_dragonID);
        require(currentAction == 0, "Dragon is busy!");
        require(nextBlock2Action <= block.number, "Dragon is resting!");
        uint240 genAdd = uint240(uint8(random_number[31]));
        if ((uint240(uint8(bytes30(gensDragon)[_genNum])) + genAdd) > 0xFF) {
            gensDragon -= uint240(uint256(1 << (30 - _genNum) * 8));
        }
        uint240 newGens = gensDragon + (genAdd << (29 - _genNum) * 8);
        _setResault(_dragonID, gensDragon, newGens);
    }
    function returnPrices() external view returns (uint256, uint256, uint256){
        return (mutagenCount, priceMutagenWork, priceMax);
    }
    function _firstCheck(uint256 _dragonID, uint256 _genNum, uint256 _price) private {
        require(msg.value >= _price, "Not enough ether!");
        require(mainContract.ownerOf(_dragonID) == msg.sender, "Only the owner can do this!");
        require(_genNum <= 29, "Number is to big!");
        uint256 returnValue = msg.value - _price;
        wallet.transfer(_price);
        if (returnValue > 0) {
            msg.sender.transfer(returnValue);
        }
    }
    function _setResault(uint256 _dragonID, uint240 _oldGens, uint240 _newGens) private {
        mainContract.changeDragonGen(_dragonID, _newGens, 1);
        if (addTime2Rest > 0) {
            mainContract.setTime2Rest(_dragonID, addTime2Rest);
        }        
        dragonsStatsContract.incGenLabFight(_dragonID);
        dragonsStatsContract.setLastAction(_dragonID, _dragonID, 12);
        emit FightGensChanged(msg.sender, _dragonID, _oldGens, _newGens);
    }
    function changeAddTime2Rest(uint256 _addTime2Rest) external onlyAdmin {
        addTime2Rest = _addTime2Rest;
    }
    function changeMutagenCount(uint256 _mutagenCount) external onlyAdmin {
        mutagenCount = _mutagenCount;
    }
    function changePriceMutagenWork(uint256 _priceMutagenWork) external onlyAdmin {
        priceMutagenWork = _priceMutagenWork;
    }
    function changePriceMax(uint256 _priceMax) external onlyAdmin {
        priceMax = _priceMax;
    }
    function changeAddressRNG(address _addressRNG) external onlyAdmin {
        addressRNG = _addressRNG;
    }
    function changeWallet(address payable _wallet) external onlyAdmin {
        wallet = _wallet;
    }
    function withdrawAllEther() external onlyAdmin {
        require(wallet != address(0), "Withdraw address can't be zero!");
        wallet.transfer(address(this).balance);
    }
}

