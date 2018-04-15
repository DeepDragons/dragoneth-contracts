pragma solidity ^0.4.21;

import "./security/Pausable.sol";
import "./math/SafeMath.sol";

contract DragonETH {

function createDragon(address _to, uint256 _timeToBorn, uint256 _parentOne, uint256 _parentTwo, uint256 _gen1, uint240 _gen2) external;

}
contract CrowdSaleDragonETH is Pausable {
    using SafeMath for uint256;
    address private wallet;
    address public mainContract;
    uint256 public crowdSaleDragonPrice = 0.01 ether;
    uint256 public soldDragons;
    uint256 public priceChanger = 0.00005 ether;
    uint256 public timeToBorn = 5760; // ~ 24h 
    uint256 public timeToFirstBorn = 0; // Change to Birth Date of first dragon 
    function CrowdSaleDragonETH(address _wallet, address _mainContract) public {
        wallet = _wallet;
        mainContract = _mainContract;
    }


    function() external payable whenNotPaused {
       require(soldDragons <= 100000);
       require(msg.value >= crowdSaleDragonPrice);
        uint256 count_to_buy;
        uint256 return_value;
  
        count_to_buy = msg.value.div(crowdSaleDragonPrice);
        require(count_to_buy >= 1);
        if (count_to_buy > 5) count_to_buy = 5;
        // operation safety check with functions div() and require() above
        return_value = msg.value - count_to_buy * (crowdSaleDragonPrice);
        if (return_value > 0) msg.sender.transfer(return_value);
        wallet.transfer(msg.value - return_value);
        for(uint256 len = 1; len <= count_to_buy; len += 1) {
        // TODO rewrite parameter
            if (block.number < timeToFirstBorn) {
                DragonETH(mainContract).createDragon(msg.sender, timeToFirstBorn, 0, 0, 0, 0);
            } else {
                DragonETH(mainContract).createDragon(msg.sender, block.number + timeToBorn, 0, 0, 0, 0);
            }
            soldDragons++;
            crowdSaleDragonPrice = crowdSaleDragonPrice + priceChanger;
        }
        //TODO Add promo for CryptoKitty owners
        
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
