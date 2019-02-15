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
    
    //function transferFrom(address _from, address _to, uint256 _tokenId) public;
    //function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
    function ownerOf(uint256 _tokenId) public view returns (address _owner);
    function setCurrentAction(uint256 _dragonID, uint8 _currentAction) external;
}

contract RNG {
    function get32b(address _from, uint256 _dragonID) external returns (bytes32 b32);
}

contract DragonsFight is RBACWithAdmin {
    DragonsETH public mainContract;
    address private addressRNG;
    uint256 constant SF = 0xFFFFFFFF;
    
    event FightCourse(uint256 _dragonOneID, uint256 _dragonTwoID, uint256 dragonOneDamage, uint256 dragonTwoDamage,bytes32  random_number);

    constructor(address _addressMainContract) public {
        mainContract = DragonsETH(_addressMainContract);
    }
    function getWinner(uint256 _dragonOneID, uint256 _dragonTwoID) external onlyRole("FightContract") returns (uint256 _winerID){
        require(_dragonOneID != _dragonTwoID);
        bytes32 random_number;
        address _tmpAddress = address(uint(msg.sender) ^ uint(mainContract.ownerOf(_dragonTwoID)));
        random_number = RNG(addressRNG).get32b(_tmpAddress, _dragonOneID ^ _dragonTwoID);
        uint240 gensDragonOne;
        uint240 gensDragonTwo;
        (,,,gensDragonOne,) = mainContract.dragons(_dragonOneID);
        (,,,gensDragonTwo,) = mainContract.dragons(_dragonTwoID);
        bytes30 bGensDragonOne = bytes30(gensDragonOne);
        bytes30 bGensDragonTwo = bytes30(gensDragonTwo);
        uint256 dragonOneDamage;
        uint256 dragonTwoDamage;
        for (uint256 index = 0; index < 15; index++) {
            uint8 tmpRN = uint8(random_number[index]);
            uint8 tmpRN2 = uint8(random_number[index + 15]);
            if (tmpRN < 200) {
                if (bGensDragonOne[index] > bGensDragonTwo[15 + index]) {
                    dragonTwoDamage += uint8(bGensDragonOne[index]) - uint8(bGensDragonTwo[15 + index]);
                }
                
            } else {
                if (tmpRN < 225) {
                    if (uint8(bGensDragonOne[index]) > uint8(bGensDragonTwo[15 + index]) - (tmpRN - 200)) {
                        dragonTwoDamage += uint8(bGensDragonOne[index]) - uint8(bGensDragonTwo[15 + index]) + (tmpRN - 200);
                    }
                } else {
                    if (uint8(bGensDragonOne[index]) > uint8(bGensDragonTwo[15 + index]) + (tmpRN - 225)) {
                        dragonTwoDamage += uint8(bGensDragonOne[index]) - uint8(bGensDragonTwo[15 + index]) - (tmpRN - 225);
                    }
                }
            }
            if (tmpRN2 < 200) {
                if (bGensDragonTwo[index] > bGensDragonOne[15 + index]) {
                    dragonOneDamage += uint8(bGensDragonTwo[index]) - uint8(bGensDragonOne[15 + index]);
                }
                
            } else {
                if (tmpRN2 < 225) {
                    if (uint8(bGensDragonTwo[index]) > uint8(bGensDragonOne[15 + index])  - (tmpRN2 - 200)) {
                        dragonOneDamage += uint8(bGensDragonTwo[index]) - uint8(bGensDragonOne[15 + index]) +  (tmpRN2 - 225);
                    }
                } else {
                    if (uint8(bGensDragonTwo[index]) > uint8(bGensDragonOne[15 + index]) + (tmpRN2 - 225)) {
                        dragonOneDamage += uint8(bGensDragonTwo[index]) - uint8(bGensDragonOne[15 + index]) - (tmpRN2 - 225);
                    }
                }
            }
            
        }
        emit FightCourse( _dragonOneID, _dragonTwoID, dragonOneDamage, dragonTwoDamage, random_number);
        uint256 probOneWin = dragonTwoDamage * SF / (dragonOneDamage + dragonTwoDamage);
        uint256 probRN = ((uint256(uint8(random_number[30])) << 8) + uint8(random_number[31]))* SF / 0xFFFF;
        if (probRN <= probOneWin) {
            return _dragonOneID;    
        } else {
            return _dragonTwoID;
        }
    }
    function changeAddressRNG(address _addressRNG) external onlyAdmin {
        addressRNG = _addressRNG;
    }
}

