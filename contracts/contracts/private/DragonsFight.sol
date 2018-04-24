pragma solidity ^0.4.23;

import "../security/rbac/RBACWithAdmin.sol";

contract DragonsFight is RBACWithAdmin {
    function getWinner(uint256 _dragonOneID, uint256 _dragonTwoID) external view returns (uint256 _winerID){
    // TODO Develop It!!!!
        require(_dragonOneID != _dragonTwoID);
        if (uint8(blockhash(block.number-2)) > 127 ) {
            return _dragonOneID;    
        } else {
            return _dragonTwoID;
        }
        
    }
    
}

