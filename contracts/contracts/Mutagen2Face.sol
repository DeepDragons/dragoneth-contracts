pragma solidity ^0.4.23;

import "./security/rbac/RBACWithAdmin.sol";

contract DragonsETH {
     function killDragonDeathContract(address _lastOwner, uint256 _dragonID, uint256 _deathReason) external;
     function transferFrom(address _from, address _to, uint256 _tokenId) public;
     function changeDragonGen(uint256 _dragonID, uint256 _gen, uint8 _which) external;
}
contract CheckMutagenResistance {
    function checkResistance(uint256 _dragonID) external view returns (bool);
}


contract Mutagen2Face is RBACWithAdmin  {
    DragonsETH public mainContract;
    CheckMutagenResistance public checkResistanceContract;
    
    function addDragon(address _dragonOwner, uint256 _dragonID, uint256 mutagenCount) external {
        if (checkResistanceContract.checkResistance(_dragonID)) {
            mainContract.changeDragonGen(_dragonID,0,0);
            mainContract.transferFrom(address(this), _dragonOwner, _dragonID);
        } else {
            mainContract.killDragonDeathContract(_dragonOwner,_dragonID,2);
        }
        
    }
    
    function changeAddressMainContract(address _newAddress) external onlyAdmin {
        mainContract = DragonsETH(_newAddress);
    }
    function changeAddressCheckResistanceContract(address _newAddress) external onlyAdmin {
        checkResistanceContract = CheckMutagenResistance(_newAddress);
    }
}