pragma solidity ^0.4.21;

import "./ownership/Pausable.sol";
import "./math/SafeMath.sol";

contract DragonETH {

function createDragon(address _to) external;

}
contract CrowdSaleDragonETH is Pausable {
    using SafeMath for uint256;
    address private wallet;
    address public mainContract;
    uint256 public crowdSaleDragonPrice = 0.01 ether;
    uint256 public soldDragons;
    uint256 public priceChanger = 0.00005 ether;

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
          DragonETH(mainContract).createDragon(msg.sender);
          soldDragons++;
          crowdSaleDragonPrice = crowdSaleDragonPrice + priceChanger;
        }
        //TODO Add promo for CryptoKitty owners
        
    }

    function changePrice(uint256 _price) external onlyOwner {
       crowdSaleDragonPrice = _price;
    }

    function setPriceChanger(uint256 _priceChanger) external onlyOwner {
       priceChanger = _priceChanger;
    }

    function changeWallet(address _wallet) external onlyOwner {
        wallet = _wallet;
    }

    function withdrawAllEther() external onlyOwner {
        require(wallet != 0);
        wallet.transfer(address(this).balance);
    }
}
