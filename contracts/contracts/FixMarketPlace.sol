pragma solidity ^0.4.21;

import "./security/Pausable.sol";
import "./math/SafeMath.sol";

contract DragonETH {
function transferFrom(address _from, address _to, uint256 _tokenId) public;
function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
  
}

contract FixMarketPlace is Pausable {
    using SafeMath for uint256;
    DragonETH public mainContract;
    address wallet;
    uint256 public totalDragonsToSale;
    uint256 public minSellTime = 13; //~2 min
    uint256 public maxSellTime = 259200; //~30 days??????
    uint256 public ownersPercent = 50; // eq 5%
    mapping(uint256 => address) dragonsOwner;
    mapping(uint256 => uint256) public dragonPrices;
    mapping(uint256 => uint256) public dragonsEndBlock;
    uint256[] public dragonsList; 
    mapping(uint256 => uint256) dragonsListIndex;
    //mapping (address => uint256[]) private ownedTokens;

    function FixMarketPlace(address _wallet) public {
        wallet = _wallet;
    }

    function _delItem(uint256 _dragonID) private {
        delete(dragonsOwner[_dragonID]);
        delete(dragonPrices[_dragonID]);
        delete(dragonsEndBlock[_dragonID]);
        if (totalDragonsToSale > 1) {
            dragonsList[dragonsListIndex[_dragonID]] = dragonsList[dragonsList.length - 1];
        }
        dragonsList.length--;
        delete(dragonsListIndex[_dragonID]);
        totalDragonsToSale--;
    }
    function addToFixMarketPlace(address _dragonOwner, uint256 _dragonID, uint256 _dragonPrice, uint256 _endBlockNumber) external whenNotPaused returns (bool sucsses) {
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

    function buyDragon(uint256 _dragonID) external payable whenNotPaused {
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
    function getAllDragonsSale() external view returns(uint256[]) {
        return dragonsList;
    }
    function getDragonsToSale() external view returns(uint256[]) {
        

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
        mainContract = DragonETH(_newAddress);
    }
    
    function changeWallet(address _wallet) external onlyAdmin {
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
        require(wallet != 0);
        wallet.transfer(address(this).balance);
    }
}

