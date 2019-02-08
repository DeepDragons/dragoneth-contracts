pragma solidity ^0.5.3;

import "./security/Pausable.sol";
import "./math/SafeMath.sol";
import "./security/ReentrancyGuard.sol";

contract DragonsETH {
    struct Dragon {
        uint256 gen1;
        uint8 stage; // 0 - Dead, 1 - Egg, 2 - Young Dragon 
        uint8 currentAction; // 0 - free, 1 - fight place, 0xFF - Necropolis,  2 - random fight, 3 - breed market, 4 - breed auction, 5 - random breed ...
        uint240 gen2;
        uint256 nextBlock2Action;
    }

    Dragon[] public dragons;
    
    function transferFrom(address _from, address _to, uint256 _tokenId) public;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
  
}

contract FixMarketPlace is Pausable, ReentrancyGuard {
    using SafeMath for uint256;
    DragonsETH public mainContract;
    address payable wallet;
    uint256 public totalDragonsToSale;
    uint256 public minSellTime = 13; //~2 min
    uint256 public maxSellTime = 259200; //~30 days??????
    uint256 public ownersPercent = 50; // eq 5%
    mapping(uint256 => address payable) public dragonsOwner;
    mapping(uint256 => uint256) public dragonPrices;
    mapping(uint256 => uint256) public dragonsEndBlock;
    mapping(uint256 => uint256) public dragonsListIndex;
    uint256[] public dragonsList; 
    
    //mapping (address => uint256[]) private ownedTokens;

    constructor(address payable _wallet) public {
        wallet = _wallet;
    }

    function _delItem(uint256 _dragonID) private {
        delete(dragonsOwner[_dragonID]);
        delete(dragonPrices[_dragonID]);
        delete(dragonsEndBlock[_dragonID]);
        if (totalDragonsToSale > 1) {
            dragonsList[dragonsListIndex[_dragonID]] = dragonsList[dragonsList.length - 1];
            dragonsListIndex[dragonsList[dragonsList.length - 1]] = dragonsListIndex[_dragonID];
        }
        dragonsList.length--;
        delete(dragonsListIndex[_dragonID]);
        totalDragonsToSale--;
    }
    function add2MarketPlace(address payable _dragonOwner, uint256 _dragonID, uint256 _dragonPrice, uint256 _endBlockNumber) external whenNotPaused returns (bool) {
        require(msg.sender == address(mainContract));
        require(_endBlockNumber  > minSellTime);
        require(_endBlockNumber < maxSellTime ); //??????
        require(_dragonPrice > 0);
        dragonsOwner[_dragonID] = _dragonOwner;
        dragonPrices[_dragonID] = _dragonPrice;
        dragonsEndBlock[_dragonID] = block.number + _endBlockNumber;
        dragonsListIndex[_dragonID] = dragonsList.length;
        dragonsList.push(_dragonID);
        totalDragonsToSale++;
        return true;
    }
    
    function delFromFixMarketPlace(uint256 _dragonID) external {
            require(msg.sender == dragonsOwner[_dragonID] || dragonsEndBlock[_dragonID] < block.number);
            mainContract.transferFrom(address(this), dragonsOwner[_dragonID], _dragonID);
            _delItem(_dragonID);
    }

    function buyDragon(uint256 _dragonID) external payable nonReentrant whenNotPaused {
        require(block.number <= dragonsEndBlock[_dragonID]);
        uint256 _dragonCommisions = dragonPrices[_dragonID].mul(ownersPercent).div(1000);
        require(msg.value >= dragonPrices[_dragonID].add(_dragonCommisions));
        uint256 valueToReturn = msg.value.sub(dragonPrices[_dragonID]).sub(_dragonCommisions);
        if (valueToReturn != 0) {
            msg.sender.transfer(valueToReturn);
        }
    
        mainContract.safeTransferFrom(address(this), msg.sender, _dragonID);
        wallet.transfer(_dragonCommisions);
        dragonsOwner[_dragonID].transfer(msg.value - valueToReturn - _dragonCommisions);
        _delItem(_dragonID);        
    }
    function getAllDragonsSale() external view returns(uint256[] memory) {
        return dragonsList;
    }
    function getDragonsToSale() external view returns(uint256[] memory) {
        

        if (totalDragonsToSale == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            // !!!!!! need to test on time go to future
            uint256[] memory result = new uint256[](totalDragonsToSale);
            uint256 _dragonIndex;
            uint256 _resultIndex = 0;

            for (_dragonIndex = 0; _dragonIndex < totalDragonsToSale; _dragonIndex++) {
                uint256 _dragonID = dragonsList[_dragonIndex];
                if (dragonsEndBlock[_dragonID] > block.number) {
                    result[_resultIndex] = _dragonID;
                    _resultIndex++;
                }
            }

            return result;
        }
    }
    function getFewDragons(uint256[] calldata _dragonIDs) external view returns(uint256[] memory) {
        uint256 dragonCount = _dragonIDs.length;
        if (dragonCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](dragonCount * 5);
            uint256 resultIndex = 0;

            for (uint256 dragonIndex = 0; dragonIndex < dragonCount; dragonIndex++) {
                uint256 dragonID = _dragonIDs[dragonIndex];
// chech to existance
                result[resultIndex++] = dragonID;
                uint8 tmp;
                (,tmp,,,)= mainContract.dragons(dragonID);
                result[resultIndex++] = uint256(tmp);
                result[resultIndex++] = uint256(dragonsOwner[dragonID]);
                result[resultIndex++] = dragonPrices[dragonID];
                result[resultIndex++] = dragonsEndBlock[dragonID];
                
            }

            return result; 
        }
    }
    function clearStuxDragon(uint256 _start, uint256 _count) external whenNotPaused returns (uint256 _deleted) {
        uint256 _dragonIndex;
        
        for(_dragonIndex=_start; _dragonIndex < _start + _count && _dragonIndex < dragonsList.length; _dragonIndex++) {
            uint256 _dragonID = dragonsList[_dragonIndex];
            if (dragonsEndBlock[_dragonID] < block.number) {
                mainContract.transferFrom(address(this), dragonsOwner[_dragonID], _dragonID);
                _delItem(_dragonID);
                _deleted++;
            }
        }
    }
   
    function changeAddressMainContract(address _newAddress) external onlyAdmin {
        mainContract = DragonsETH(_newAddress);
    }
    
    function changeWallet(address payable _wallet) external onlyAdmin {
        wallet = _wallet;
    }

    function changeMinSellTime(uint256 _minSellTime) external onlyAdmin {
        minSellTime = _minSellTime;
    }

    function changeMaxSellTime(uint256 _maxSellTime) external onlyAdmin {
        maxSellTime = _maxSellTime;
    }

    function changeOwnersPercent(uint256 _ownersPercent) external onlyAdmin {
        ownersPercent = _ownersPercent;
    }

    function withdrawAllEther() external onlyAdmin {
        require(wallet != address(0));
        wallet.transfer(address(this).balance);
    }
}

