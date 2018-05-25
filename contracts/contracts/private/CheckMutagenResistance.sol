pragma solidity ^0.4.23;

import "../security/rbac/RBACWithAdmin.sol";

contract DragonsETH {
    struct Dragon {
        uint256 gen1;
        uint8 stage; // 0 - Dead, 1 - Egg, 2 - Young Dragon 
        uint8 currentAction; // 0 - free, 1 - fight place, 0xFF - Necropolis,  2 - random fight, 3 - breed market, 4 - breed auction, 5 - random breed ...
        uint240 gen2;
        uint256 nextBlock2Action;
    }
//mybe function????
    Dragon[] public dragons;
}

contract CheckMutagenResistance is RBACWithAdmin {
    DragonsETH public mainContract;
    
    function checkResistance(uint256 _dragonID) external view returns (bool){
    // TODO Develop It!!!!
    uint256 tmp;
    (tmp,)= mainContract.dragons(_dragonID);
       if (bytes1(blockhash(block.number-2)) < bytes32(tmp)[20] ) {
            return true;    
        } else {
            return false;
        }
        
    }
    function changeAddressMainContract(address _newAddress) external onlyAdmin {
        mainContract = DragonsETH(_newAddress);
    }
    
}

