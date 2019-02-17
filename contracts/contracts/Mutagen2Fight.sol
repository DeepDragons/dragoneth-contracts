pragma solidity ^0.5.4;

//????
import "./security/rbac/RBACWithAdmin.sol";

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

    function ownerOf(uint256 _tokenId) public view returns (address _owner);
    function setTime2Rest(uint256 _dragonID, uint256 _addNextBlock2Action) external;
    function isApprovedOrOwner(address _spender, uint256 _tokenId) public view returns (bool);
}
contract Mutagen {
    function mint(address _to, uint256 _amount)  public returns (bool);
}

contract RNG {
    function get32b(address _from, uint256 _dragonID) external returns (bytes32 b32);
}

contract Mutagen2Fight is RBACWithAdmin {
    DragonsETH public mainContract;
    address private addressRNG;
    
    event FightGensChanged(uint256 _dragonOneID, uint240 _oldGens, uint240 _newGens);

    constructor(address _addressMainContract) public {
        mainContract = DragonsETH(_addressMainContract);
    }
    function mutateFightGens(uint256 _dragonID, uint256 _nutagenCount) external {
        //require();
        require(mainContract.isApprovedOrOwner(msg.sender, _dragonID));
    }    
    function changeAddressRNG(address _addressRNG) external onlyAdmin {
        addressRNG = _addressRNG;
    }
}

