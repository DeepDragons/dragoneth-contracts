pragma solidity ^0.5.3;

import "./security/Pausable.sol";
import "./math/SafeMath.sol";
import "./security/ReentrancyGuard.sol";

contract DragonsETH {
    struct Dragon {
        uint256 gen1;
        uint8 stage; // 0 - Dead, 1 - Egg, 2 - Young Dragon 
        uint8 currentAction; // 0 - free, 1 - fight place, 0xFF - Necropolis,  2 - random fight,
                             // 3 - breed market, 4 - breed auction, 5 - random breed 6 - market place ...
        uint240 gen2;
        uint256 nextBlock2Action;
    }

    Dragon[] public dragons;
    
    function transferFrom(address _from, address _to, uint256 _tokenId) public;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
    function setCurrentAction(uint256 _dragonID, uint8 _currentAction) external;
}

contract FixMarketPlace is Pausable, ReentrancyGuard {
    using SafeMath for uint256;
    DragonsETH public mainContract;
    address payable wallet;
    uint256 public ownersPercent = 50; // eq 5%
    mapping(uint256 => address payable) public dragonsOwner;
    mapping(uint256 => uint256) public dragonPrices;
    mapping(uint256 => uint256) public dragonsListIndex;
    mapping(address => uint256) public ownerDragonsCount;
    uint256[] public dragonsList;
    
    event SoldOut(address indexed _from, address indexed _to, uint256 _tokenId, uint256 _price);
    event ForSale(address indexed _from, uint256 _tokenId, uint256 _price);
    event SaleCancel(address indexed _from, uint256 _tokenId, uint256 _price);
    
    constructor(address payable _wallet) public {
        wallet = _wallet;
    }
    function add2MarketPlace(address payable _dragonOwner, uint256 _dragonID, uint256 _dragonPrice, uint256 /*_endBlockNumber*/) 
        external
        whenNotPaused
        returns (bool) 
    {
        require(msg.sender == address(mainContract), "Only main contract can add dragons!");
        dragonsOwner[_dragonID] = _dragonOwner;
        ownerDragonsCount[_dragonOwner]++;
        dragonPrices[_dragonID] = _dragonPrice;
        dragonsListIndex[_dragonID] = dragonsList.length;
        dragonsList.push(_dragonID);
        mainContract.setCurrentAction(_dragonID, 6);
        emit ForSale(_dragonOwner, _dragonID, _dragonPrice);
        return true;
    }
    
    function delFromFixMarketPlace(uint256 _dragonID) external {
        require(msg.sender == dragonsOwner[_dragonID], "Only owner can do it.");
        mainContract.transferFrom(address(this), dragonsOwner[_dragonID], _dragonID);
        emit SaleCancel(dragonsOwner[_dragonID], _dragonID, dragonPrices[_dragonID]);
        _delItem(_dragonID);
    }
    function buyDragon(uint256 _dragonID) external payable nonReentrant whenNotPaused {
        uint256 _dragonCommisions = dragonPrices[_dragonID].mul(ownersPercent).div(1000);
        require(msg.value >= dragonPrices[_dragonID].add(_dragonCommisions), "Not enough money!");
        uint256 valueToReturn = msg.value.sub(dragonPrices[_dragonID]).sub(_dragonCommisions);
        if (valueToReturn != 0) {
            msg.sender.transfer(valueToReturn);
        }
    
        mainContract.safeTransferFrom(address(this), msg.sender, _dragonID);
        wallet.transfer(_dragonCommisions);
        dragonsOwner[_dragonID].transfer(msg.value - valueToReturn - _dragonCommisions);
        emit SoldOut(dragonsOwner[_dragonID], msg.sender, _dragonID, msg.value - valueToReturn - _dragonCommisions);
        _delItem(_dragonID);
    }
    function totalDragonsToSale() external view returns(uint256) {
        return dragonsList.length;
    }
    function getAllDragonsSale() external view returns(uint256[] memory) {
        return dragonsList;
    }
    function getSlicedDragonsSale(uint256 _firstIndex, uint256 _aboveLastIndex) external view returns(uint256[] memory) {
        require(_firstIndex < dragonsList.length, "First index greater than totalDragonsToSale");
        uint256 lastIndex = _aboveLastIndex;
        if (_aboveLastIndex > dragonsList.length) lastIndex = dragonsList.length;
        require(_firstIndex <= lastIndex, "First index greater than Last Index");
        uint256 resultCount = lastIndex - _firstIndex;
        if (resultCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](resultCount);
            uint256 _dragonIndex;
            uint256 _resultIndex = 0;

            for (_dragonIndex = _firstIndex; _dragonIndex < lastIndex; _dragonIndex++) {
                result[_resultIndex] = dragonsList[_dragonIndex];
                _resultIndex++;
            }

            return result;
        }
    }
    function getOwnedDragonToSale(address _owner) external view returns(uint256[] memory) {
        uint256 countResaultDragons = ownerDragonsCount[_owner];
        if (countResaultDragons == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](countResaultDragons);
            uint256 _dragonIndex;
            uint256 _resultIndex = 0;

            for (_dragonIndex = 0; _dragonIndex < dragonsList.length; _dragonIndex++) {
                uint256 _dragonID = dragonsList[_dragonIndex];
                if (dragonsOwner[_dragonID] == _owner) {
                    result[_resultIndex] = _dragonID;
                    _resultIndex++;
                    if (_resultIndex == countResaultDragons) break;
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
            uint256[] memory result = new uint256[](dragonCount * 4);
            uint256 resultIndex = 0;

            for (uint256 dragonIndex = 0; dragonIndex < dragonCount; dragonIndex++) {
                uint256 dragonID = _dragonIDs[dragonIndex];
                result[resultIndex++] = dragonID;
                uint8 tmp;
                (,tmp,,,) = mainContract.dragons(dragonID);
                result[resultIndex++] = uint256(tmp);
                result[resultIndex++] = uint256(dragonsOwner[dragonID]);
                result[resultIndex++] = dragonPrices[dragonID];
                
            }

            return result; 
        }
    }
     function _delItem(uint256 _dragonID) private {
        require(dragonsOwner[_dragonID] != address(0), "An attempt to remove an unregistered dragon");
        mainContract.setCurrentAction(_dragonID, 0);
        ownerDragonsCount[dragonsOwner[_dragonID]]--;
        delete(dragonsOwner[_dragonID]);
        delete(dragonPrices[_dragonID]);
        if (dragonsList.length - 1 != dragonsListIndex[_dragonID]) {
            dragonsList[dragonsListIndex[_dragonID]] = dragonsList[dragonsList.length - 1];
            dragonsListIndex[dragonsList[dragonsList.length - 1]] = dragonsListIndex[_dragonID];
        }
        dragonsList.length--;
        delete(dragonsListIndex[_dragonID]);
    }
    function clearMarket(uint256[] calldata _dragonIDs) external onlyAdmin whenPaused {
        uint256 dragonCount = _dragonIDs.length;
        if (dragonCount > 0) {
            for (uint256 dragonIndex = 0; dragonIndex < dragonCount; dragonIndex++) {
                uint256 dragonID = _dragonIDs[dragonIndex];
                mainContract.transferFrom(address(this), dragonsOwner[dragonID], dragonID);
                _delItem(dragonID);
            }
        }
    }
    function changeAddressMainContract(address _newAddress) external onlyAdmin {
        mainContract = DragonsETH(_newAddress);
    }
    function changeWallet(address payable _wallet) external onlyAdmin {
        wallet = _wallet;
    }
    function changeOwnersPercent(uint256 _ownersPercent) external onlyAdmin {
        ownersPercent = _ownersPercent;
    }
    function withdrawAllEther() external onlyAdmin {
        require(wallet != address(0), "Withdraw address can't be zero!");
        wallet.transfer(address(this).balance);
    }
}

