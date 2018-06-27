pragma solidity ^0.4.24;

import "./security/Pausable.sol";
import "./math/SafeMath.sol";
import "./security/ReentrancyGuard.sol";
import "./ERC721/AddressUtils.sol";

contract DragonsETH {
    function createDragon(
        address _to, 
        uint256 _timeToBorn, 
        uint256 _parentOne, 
        uint256 _parentTwo, 
        uint256 _gen1, 
        uint240 _gen2
    ) 
        external;
}

contract CrowdSaleDragonsETH is Pausable, ReentrancyGuard {
    using SafeMath for uint256;
    using AddressUtils for address;
    address private wallet;
    address public mainContract;
    uint256 public crowdSaleDragonPrice = 0.01 ether;
    uint256 public soldDragons;
    uint256 public priceChanger = 0.00005 ether;
    uint256 public timeToBorn = 5760; // ~ 24h
    uint256 public contRefer50x50;
    mapping(address => bool) public refer50x50;
    
    constructor(address _wallet, address _mainContract) public {
        wallet = _wallet;
        mainContract = _mainContract;
    }


    function() external payable whenNotPaused nonReentrant {
        require(soldDragons <= 100000);
        require(msg.value >= crowdSaleDragonPrice);
        require(!msg.sender.isContract());
        uint256 count_to_buy;
        uint256 return_value;
  
        count_to_buy = msg.value.div(crowdSaleDragonPrice);
        if (count_to_buy > 15) 
            count_to_buy = 15;
        // operation safety check with functions div() and require() above
        return_value = msg.value - count_to_buy * crowdSaleDragonPrice;
        if (return_value > 0) 
            msg.sender.transfer(return_value);
            
        uint256 mainValue = msg.value - return_value;
        
        if (msg.data.length == 20) {
            address referer = bytesToAddress(bytes(msg.data));
            require(referer != msg.sender);
            if (referer == address(0))
                wallet.transfer(mainValue);
            else {
                if (refer50x50[referer]) {
                    referer.transfer(mainValue/2);
                    wallet.transfer(mainValue - mainValue/2);
                } else {
                    referer.transfer(mainValue*3/10);
                    wallet.transfer(mainValue - mainValue*3/10);
                }
            }
        } else 
            wallet.transfer(mainValue);

        for(uint256 i = 1; i <= count_to_buy; i += 1) {
            DragonsETH(mainContract).createDragon(msg.sender, block.number + timeToBorn, 0, 0, 0, 0);
            soldDragons++;
            crowdSaleDragonPrice = crowdSaleDragonPrice + priceChanger;
        }
        
    }

// onlyRole("BountyAgent")
    function sendBonusEgg(address _to, uint256 _count) external {
        for(uint256 i = 1; i <= _count; i += 1) {
            DragonsETH(mainContract).createDragon(_to, block.number + timeToBorn, 0, 0, 0, 0);
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
    

    function setRefer50x50(address _refer) external onlyAdmin {
        require(contRefer50x50 < 50);
        require(refer50x50[_refer] == false);
        refer50x50[_refer] = true;
        contRefer50x50 +=1;
    }

    function setTimeToBorn(uint256 _timeToBorn) external onlyAdmin {
        timeToBorn = _timeToBorn;
        
    }

    function withdrawAllEther() external onlyAdmin {
        require(wallet != 0);
        wallet.transfer(address(this).balance);
    }
   
    function bytesToAddress(bytes _bytesData) internal pure returns(address _addressReferer) {
        assembly {
            _addressReferer := mload(add(_bytesData,0x14))
        }
        return _addressReferer;
    }
}
