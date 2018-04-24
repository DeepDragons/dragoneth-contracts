pragma solidity ^0.4.23;

import "./security/Pausable.sol";
import "./math/SafeMath.sol";
import "./security/ReentrancyGuard.sol";
import "./ERC721/AddressUtils.sol";

contract DragonETH {

function createDragon(address _to, uint256 _timeToBorn, uint256 _parentOne, uint256 _parentTwo, uint256 _gen1, uint240 _gen2) external;

}
contract CrowdSaleDragonETH is Pausable, ReentrancyGuard {
    using SafeMath for uint256;
    using AddressUtils for address;
    address private wallet;
    address public mainContract;
    uint256 public crowdSaleDragonPrice = 0.01 ether;
    uint256 public soldDragons;
    uint256 public priceChanger = 0.00005 ether;
    uint256 public timeToBorn = 5760; // ~ 24h 
    uint256 public timeToFirstBorn;
    
    constructor(address _wallet, address _mainContract) public {
        wallet = _wallet;
        mainContract = _mainContract;
        timeToFirstBorn = block.number + 80640; // ~14 days 
    }


    function() external payable whenNotPaused nonReentrant {
       require(soldDragons <= 100000);
       require(msg.value >= crowdSaleDragonPrice);
       require(!msg.sender.isContract());
        uint256 count_to_buy;
        uint256 return_value;
  
        count_to_buy = msg.value.div(crowdSaleDragonPrice);
        if (count_to_buy > 10) count_to_buy = 10;
        // operation safety check with functions div() and require() above
        return_value = msg.value - count_to_buy * crowdSaleDragonPrice;
        if (return_value > 0) msg.sender.transfer(return_value);
        wallet.transfer(msg.value - return_value);
        for(uint256 i = 1; i <= count_to_buy; i += 1) {
            if (block.number < timeToFirstBorn) {
                // TODO add safe transfer
                DragonETH(mainContract).createDragon(msg.sender, timeToFirstBorn, 0, 0, 0, 0);
            } else {
                DragonETH(mainContract).createDragon(msg.sender, block.number + timeToBorn, 0, 0, 0, 0);
            }
            soldDragons++;
            crowdSaleDragonPrice = crowdSaleDragonPrice + priceChanger;
        }
        
    }

    function changePrice(uint256 _price) external onlyAdmin {
       crowdSaleDragonPrice = _price;
    }

    function setPriceChanger(uint256 _priceChanger) external onlyAdmin {
       priceChanger = _priceChanger;
    }

    function changeWallet(address _wallet) external onlyAdmin {
        wallet = _wallet;
    }
    
    function setTimeToBorn(uint256 _timeToBorn, uint256 _timeToFirstBorn) external onlyAdmin {
        timeToBorn = _timeToBorn;
        timeToFirstBorn = _timeToFirstBorn;
        
    }

    function withdrawAllEther() external onlyAdmin {
        require(wallet != 0);
        wallet.transfer(address(this).balance);
    }
}
