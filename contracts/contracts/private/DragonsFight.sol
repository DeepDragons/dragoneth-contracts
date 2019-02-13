pragma solidity ^0.5.4;

import "../security/rbac/RBACWithAdmin.sol";

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
    
    function transferFrom(address _from, address _to, uint256 _tokenId) public;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
    function setCurrentAction(uint256 _dragonID, uint8 _currentAction) external;
}


contract DragonsFight is RBACWithAdmin {
    DragonsETH public mainContract;
    
    constructor(address _addressMainContract) public {
        mainContract = DragonsETH(_addressMainContract);
    }
    function getWinner(uint256 _dragonOneID, uint256 _dragonTwoID) external view returns (uint256 _winerID){
        require(_dragonOneID != _dragonTwoID);
        uint240 gensDragonOne;
        uint240 gensDragonTwo;
        (,,,gensDragonOne,) = mainContract.dragons(_dragonOneID);
        (,,,gensDragonTwo,) = mainContract.dragons(_dragonTwoID);
        bytes30 bGensDragonOne = bytes30(gensDragonOne);
        bytes30 bGensDragonTwo = bytes30(gensDragonTwo);
        uint256 dragonOneDamage;
        uint256 dragonTwoDamage;
        for (uint256 index = 0; index < 15; index++) {
            if (bGensDragonOne[index] > bGensDragonTwo[15 + index]) {
                dragonTwoDamage += uint8(bGensDragonOne[index]) - uint8(bGensDragonTwo[15 + index]);
            }
            if (bGensDragonTwo[index] > bGensDragonOne[15 + index]) {
                dragonOneDamage += uint8(bGensDragonTwo[index]) - uint8(bGensDragonOne[15 + index]);
            }
        }
        
        if (dragonOneDamage < dragonTwoDamage ) {
            return _dragonOneID;    
        } else {
            return _dragonTwoID;
        }
        
    }

}

