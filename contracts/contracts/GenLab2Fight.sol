pragma solidity ^0.5.4;


//????
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
    function isApprovedOrOwner(address _spender, uint256 _tokenId) public view returns (bool);
    function changeDragonGen(uint256 _dragonID, uint256 _gen, uint8 _which) external;
}
contract Mutagen {
    function burn(address _from, uint256 _value) public;
     function balanceOf(address _owner) public view returns (uint256 balance);
}

contract RNG {
    function get32b(address _from, uint256 _dragonID) external returns (bytes32 b32);
}

contract Mutagen2Fight is RBACWithAdmin {
    Mutagen public mutagenContract;
    DragonsETH public mainContract;
    address private addressRNG;
    address payable wallet;
    uint256 public addTime2Rest = 240; // ~ 60 min
    uint256 public mutagenCount = 300;
    uint256 public priceMutagenWork = 0.1 ether;
    uint256 public priceMax = 1 ether;
     
    event FightGensChanged(address indexed _owner, uint256 _dragonOneID, uint240 _oldGens, uint240 _newGens);

    constructor(address _addressMainContract, address _addressMutagen) public {
        mainContract = DragonsETH(_addressMainContract);
        mutagenContract = Mutagen(_addressMutagen);
    }
    function setMaxGen(uint256 _dragonID, uint256 _genNum) external payable {
        require(msg.value >= priceMax);
        require(mainContract.ownerOf(_dragonID) == msg.sender);
        require(_genNum <= 29);
        uint256 returnValue = msg.value - priceMax;
        wallet.transfer(priceMax);
        if (returnValue > 0) {
            msg.sender.transfer(returnValue);
        }
        uint240 gensDragon;
        (,,,gensDragon,) = mainContract.dragons(_dragonID);
        uint8 genAdd = 0xFF - uint8(bytes30(gensDragon)[_genNum]);
        uint240 newGens = gensDragon + (genAdd << (29 - _genNum) * 8);
        mainContract.changeDragonGen(_dragonID, newGens, 1);
        //TODO Write statistic!!!!!
        emit FightGensChanged(msg.sender, _dragonID, gensDragon, newGens);
    }
    function mutateFightGenRandom(uint256 _dragonID, uint256 _genNum) external payable {
        require(mutagenContract.balanceOf(msg.sender) >= mutagenCount);
        require(msg.value >= priceMutagenWork);
        require(mainContract.ownerOf(_dragonID) == msg.sender);
        require(_genNum <= 29);
        uint256 returnValue = msg.value - priceMutagenWork;
        wallet.transfer(priceMutagenWork);
        if (returnValue > 0) {
            msg.sender.transfer(returnValue);
        }
        bytes32 random_number = RNG(addressRNG).get32b(msg.sender, _dragonID);
        uint240 gensDragon;
        (,,,gensDragon,) = mainContract.dragons(_dragonID);
        uint240 genAdd = uint240(uint8(random_number[31]));
        if ((uint240(uint8(bytes30(gensDragon)[_genNum])) + genAdd) > 0xFF) {
            gensDragon -= uint240(uint256(1 << (30 - _genNum) * 8));
        }
        uint240 newGens = gensDragon + (genAdd << (29 - _genNum) * 8); //checkit
        mainContract.changeDragonGen(_dragonID, newGens, 1);
        //TODO Write statistic!!!!!
        emit FightGensChanged(msg.sender, _dragonID, gensDragon, newGens);
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
    function changePriceMaxk(uint256 _priceMax) external onlyAdmin {
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

