pragma solidity ^0.4.23;

import "./ERC721/ERC721Token.sol";
import "./DragonsETH_GC.sol";
import "./security/ReentrancyGuard.sol";

// FOR TEST remove in war deploy
// contract DragonsETH is ERC721Token("DragonsETH.com game", "DragonsETH"), DragonsETH_GC, ReentrancyGuard {
contract DragonsETH is ERC721Token("Test game", "Test"), DragonsETH_GC, ReentrancyGuard {
    uint256 public totalDragons;
    uint256 public liveDragons;
    struct Dragon {
        uint256 gen1;
        uint8 stage; // 0 - Dead, 1 - Egg, 2 - Young Dragon 
        uint8 currentAction; // 0 - free, 1 - fight place, 0xFF - Necropolis,  2 - random fight, 3 - breed market, 4 - breed auction, 5 - random breed ...
        uint240 gen2;
        uint256 nextBlock2Action;
    }
    Dragon[] public dragons;
    mapping(uint256 => string) public dragonName;
    
   
    constructor(address _wallet, address _necropolisContract, address _dragonsStatsContract) public {
        
        _mint(msg.sender, 0);
        Dragon memory _dragon = Dragon({
            gen1: 0,
            stage: 0,
            currentAction: 0,
            gen2: 0,
            nextBlock2Action: UINT256_MAX
        });
        dragons.push(_dragon);
        transferFrom(msg.sender, _necropolisContract, 0);
        dragonsStatsContract = DragonsStats(_dragonsStatsContract);
        necropolisContract = Necropolis(_necropolisContract);
        wallet = _wallet;
    }
   
    function add2MarketPlace(uint256 _dragonID, uint256 _dragonPrice, uint256 _endBlockNumber) external canTransfer(_dragonID)  {
        require(dragons[_dragonID].stage != 0); // dragon not dead
        if (dragons[_dragonID].stage >= 2) {
            checkDragonStatus(_dragonID, 2);
        }
        address dragonOwner = ownerOf(_dragonID);
        if (fmpContractAddress.add2MarketPlace(dragonOwner, _dragonID, _dragonPrice, _endBlockNumber)) {
        transferFrom(dragonOwner, fmpContractAddress, _dragonID);
        }
    }

    function add2Auction(uint256 _dragonID,  uint256 _startPrice, uint256 _step, uint256 _endPrice, uint256 _endBlockNumber) external canTransfer(_dragonID)  {
        require(dragons[_dragonID].stage != 0); // dragon not dead
        if (dragons[_dragonID].stage >= 2) {
            checkDragonStatus(_dragonID, 2);
        }
        address dragonOwner = ownerOf(_dragonID);
        if (auctionContract.add2Auction(dragonOwner, _dragonID, _startPrice, _step, _endPrice, _endBlockNumber)) {
        transferFrom(dragonOwner, auctionContract, _dragonID);
        }
    }
    
    function addRandomFight2Death(uint256 _dragonID) external payable nonReentrant canTransfer(_dragonID)   {
        checkDragonStatus(_dragonID, adultDragonStage);
        if (priceRandomFight2Death > 0) {
            require(msg.value >= priceRandomFight2Death);
            wallet.transfer(priceRandomFight2Death);
            if (msg.value - priceRandomFight2Death > 0) msg.sender.transfer(msg.value - priceRandomFight2Death);
        }
        address dragonOwner = ownerOf(_dragonID);
        transferFrom(dragonOwner, randomFight2DeathContract, _dragonID);
        randomFight2DeathContract.addRandomFight2Death(dragonOwner, _dragonID);
    }
    
    function addSelctFight2Death(uint256 _yourDragonID, uint256 _oppDragonID, uint256 _endBlockNumber) external payable nonReentrant canTransfer(_yourDragonID)   {
        checkDragonStatus(_yourDragonID, adultDragonStage);
        if (priceSelectFight2Death > 0) {
            require(msg.value >= priceSelectFight2Death);
            address(selectFight2DeathContract).transfer(priceSelectFight2Death);
            if (msg.value - priceSelectFight2Death > 0) msg.sender.transfer(msg.value - priceSelectFight2Death);
        }
        address dragonOwner = ownerOf(_yourDragonID);
        transferFrom(dragonOwner, selectFight2DeathContract, _yourDragonID);
        selectFight2DeathContract.addSelctFight2Death(dragonOwner, _yourDragonID, _oppDragonID, _endBlockNumber, priceSelectFight2Death);
        
    }
    
    function mutagen2Face(uint256 _dragonID, uint256 _mutagenCount) external canTransfer(_dragonID)   {
        checkDragonStatus(_dragonID, 2);
        address dragonOwner = ownerOf(_dragonID);
        transferFrom(dragonOwner, mutagen2FaceContract, _dragonID);
        mutagen2FaceContract.addDragon(dragonOwner, _dragonID, _mutagenCount);
    }
    
    
    function createDragon(address _to, uint256 _timeToBorn, uint256 _parentOne, uint256 _parentTwo, uint256 _gen1, uint240 _gen2) external onlyRole("CreateContract") {
        totalDragons++;
        liveDragons++;
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
            dragonsStatsContract.setParents(totalDragons,_parentOne,_parentTwo);
            dragonsStatsContract.incChildren(_parentOne);
            dragonsStatsContract.incChildren(_parentTwo);
        }
        dragonsStatsContract.setBirthBlock(totalDragons);
    }
    function changeDragonGen(uint256 _dragonID, uint256 _gen, uint8 _which) external onlyRole("ChangeContract") {
        require(dragons[_dragonID].stage >= 2); // dragon not dead and not egg
        if (_which == 0) {
            dragons[_dragonID].gen1 = _gen;
        } else {
            dragons[_dragonID].gen2 = uint240(_gen);
        }
    }
    function birthDragon(uint256 _dragonID) external canTransfer(_dragonID) {
        require(dragons[_dragonID].stage != 0); // dragon not dead
        require(dragons[_dragonID].nextBlock2Action <= block.number);
        dragons[_dragonID].stage = 2;
    }
    function matureDragon(uint256 _dragonID) external canTransfer(_dragonID) {
        require(stageThirdBegin);
        checkDragonStatus(_dragonID, 2);
        require(dragonsStatsContract.getDragonFight(_dragonID) >= 100);
        dragons[_dragonID].stage = 3;
        
    }
    function superDragon(uint256 _dragonID) external canTransfer(_dragonID) {
        checkDragonStatus(_dragonID, 3);
        require(superContract.checkDragon(_dragonID));
        dragons[_dragonID].stage = 4;
    }
    function killDragon(uint256 _dragonID) external onlyOwnerOf(_dragonID) {
        checkDragonStatus(_dragonID, 2);
        dragons[_dragonID].stage = 0;
        dragons[_dragonID].currentAction = 0xFF;
        dragons[_dragonID].nextBlock2Action = UINT256_MAX;
        necropolisContract.addDragon(ownerOf(_dragonID), _dragonID, 1);
        transferFrom(ownerOf(_dragonID), necropolisContract, _dragonID);
        dragonsStatsContract.setDeathBlock(_dragonID);
        liveDragons--;
    }
    function killDragonDeathContract(address _lastOwner, uint256 _dragonID, uint256 _deathReason) external canTransfer(_dragonID) onlyRole("DeathContract") {
        checkDragonStatus(_dragonID, 2);
        dragons[_dragonID].stage = 0;
        dragons[_dragonID].currentAction = 0xFF;
        dragons[_dragonID].nextBlock2Action = UINT256_MAX;
        necropolisContract.addDragon(_lastOwner, _dragonID, _deathReason);
        transferFrom(ownerOf(_dragonID), necropolisContract, _dragonID);
        dragonsStatsContract.setDeathBlock(_dragonID);
        liveDragons--;
        
    }
    function decraseTimeToAction(uint256 _dragonID) external payable nonReentrant canTransfer(_dragonID) {
        require(dragons[_dragonID].stage != 0); // dragon not dead
        require(msg.value >= priceDecraseTime2Action);
        require(dragons[_dragonID].nextBlock2Action > block.number);
        uint256 maxBlockCount = dragons[_dragonID].nextBlock2Action - block.number;
        if (msg.value > maxBlockCount * priceDecraseTime2Action) {
            msg.sender.transfer(msg.value - maxBlockCount * priceDecraseTime2Action);
            wallet.transfer(maxBlockCount * priceDecraseTime2Action);
            dragons[_dragonID].nextBlock2Action = 0;
        } else {
            if (priceDecraseTime2Action == 0) {
                dragons[_dragonID].nextBlock2Action = 0;
            } else {
                wallet.transfer(msg.value);
                dragons[_dragonID].nextBlock2Action =  dragons[_dragonID].nextBlock2Action - msg.value / priceDecraseTime2Action - 1;
            }
            
            
            
        }
        
    }
    function addDragonName(uint256 _dragonID,string _newName) external payable nonReentrant canTransfer(_dragonID) {
        checkDragonStatus(_dragonID, 2);
        if (bytes(dragonName[_dragonID]).length == 0) {
            dragonName[_dragonID] = _newName;
            if (msg.value > 0) msg.sender.transfer(msg.value);
        } else {
            if (priceChangeName == 0) {
                 dragonName[_dragonID] = _newName;
                 if (msg.value > 0) msg.sender.transfer(msg.value);
            } else {
                require(msg.value >= priceChangeName);
                wallet.transfer(priceChangeName);
                if (msg.value - priceChangeName > 0) msg.sender.transfer(msg.value - priceChangeName);
                dragonName[_dragonID] = _newName;
            }
        }
    }
    
    function checkDragonStatus(uint256 _dragonID, uint8 _stage) public view {
        require(dragons[_dragonID].stage != 0); // dragon not dead
         // dragon not in action and not in rest  and not egg
        require(dragons[_dragonID].nextBlock2Action <= block.number && dragons[_dragonID].currentAction == 0 && dragons[_dragonID].stage >=_stage);
    }
    function setCurrentAction(uint256 _dragonID, uint8 _currentAction) external onlyRole("ActionContract") {
        dragons[_dragonID].currentAction = _currentAction;
    }
    function setTime2Rest(uint256 _dragonID, uint256 _addNextBlock2Action) external onlyRole("ActionContract") {
        dragons[_dragonID].nextBlock2Action = block.number + _addNextBlock2Action;
    }
    
    
    
    function getDragonGens(uint256 _dragonID) external view returns(bytes32 _res1, bytes32 _res2, uint256 _nextBlock2Action ) {

// TODO test it!!!!!!

        uint256 tmp;
        tmp = dragons[_dragonID].stage;
        tmp = tmp << 8;
        tmp = tmp + dragons[_dragonID].currentAction;
        tmp = tmp << 240;
        tmp = tmp + uint256(dragons[_dragonID].gen2);
    
        _res1 = bytes32(dragons[_dragonID].gen1);
        _res2 = bytes32(tmp);
        _nextBlock2Action = dragons[_dragonID].nextBlock2Action;
    }
    
}
