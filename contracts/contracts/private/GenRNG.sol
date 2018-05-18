pragma solidity ^0.4.24;

import "../security/rbac/RBACWithAdmin.sol";

contract RNG {
function get32b(address _from, uint256 _dragonID) external returns (bytes32 b32);
}
contract GenRNG is RBACWithAdmin {

  address private addressRNG;

  constructor(address _addressRNG) public {
  addressRNG = _addressRNG;
}

function changeAddressRNG(address _addressRNG) external onlyAdmin {
  addressRNG = _addressRNG;
}

  function getNewGens(address _from, uint256 _dragonID) external onlyRole("MainContract") returns (uint256[2] resultGen) {
   bytes32 random_number;
   uint8 tmpGen;
   random_number = RNG(addressRNG).get32b(_from, _dragonID);
//00 rezerved(for color) 00h - 00h
//01 detailColorSchemaGen = 00h - ffh
    resultGen[0] += uint8(random_number[1]);
    resultGen[0] = resultGen[0] << 8;
//02*detailAuraGen = 00h - 05h
    tmpGen = uint8(random_number[2]);
    if (tmpGen >= 229) 
        if (tmpGen < 244) 
            resultGen[0] += 1;
        else if (tmpGen < 252)
            resultGen[0] += 2;
            else if (tmpGen < 254)
                resultGen[0] += 3;
                else
                    resultGen[0] += 4;

    resultGen[0] = resultGen[0] << 8;
//03 detailAuraColorGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[3]) % 5;
    resultGen[0] = resultGen[0] << 8;
//04 *detailWingsGen = 00h - 05h
    resultGen[0] = resultGen[0] + uint8(random_number[4]) % 6;
    resultGen[0] = resultGen[0] << 16;
//05 reserved
//    resultGen[0] = resultGen[0] + uint8(random_number[5]) % 5;
//    resultGen[0] = resultGen[0] << 8;
//06 detailWingsColor2Gen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[6]) % 5;
    resultGen[0] = resultGen[0] << 8;
//07 *detailTailGen = 00h - 07h
    resultGen[0] = resultGen[0] + uint8(random_number[7]) % 8;
    resultGen[0] = resultGen[0] << 8;
//08 reserved
//    resultGen[0] = resultGen[0] + uint8(random_number[8]) % 5;
    resultGen[0] = resultGen[0] << 8;
//09 detailTailColor2Gen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[9]) % 5;
    resultGen[0] = resultGen[0] << 8;
//10 +detailBodyGen = 00h - 04h
    //resultGen[0] = resultGen[0] + uint8(random_number[10]) % 5;
    tmpGen = uint8(random_number[10]);
    if (tmpGen > 153)
        if (tmpGen < 230) 
            resultGen[0] += 1;
        else if (tmpGen < 243)
            resultGen[0] += 2;
            else
                resultGen[0] += 3;
                
    resultGen[0] = resultGen[0] << 8;
//11 detailBodyColorGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[11]) % 5;
    resultGen[0] = resultGen[0] << 8;
//12 *detailSpotsGen = 00h - 09h
    resultGen[0] = resultGen[0] + uint8(random_number[12]) % 10;
    resultGen[0] = resultGen[0] << 8;
//13 detailSpotsColorGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[13]) % 5;
    resultGen[0] = resultGen[0] << 8;
//14 *detailScalesGen = 00h - 04h
    tmpGen = uint8(random_number[14]);
    if (tmpGen >= 102) // 255 * 0.4 ~ 102
        if (tmpGen < 194) 
            resultGen[0] += 1;
        else if (tmpGen < 240)
            resultGen[0] += 2;
            else if (tmpGen < 247)
                resultGen[0] += 3;
                else
                    resultGen[0] += 4;
    resultGen[0] = resultGen[0] << 8;
//15 detailScalesColorGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[15]) % 5;
    resultGen[0] = resultGen[0] << 8;
//16 *detailHornsGen = 00h - 07h
    resultGen[0] = resultGen[0] + uint8(random_number[16]) % 8;
    resultGen[0] = resultGen[0] << 8;
//17 detailHornsColorGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[17]) % 5;
    resultGen[0] = resultGen[0] << 8;
//18 +detailHeadGen = 00h - 05h
    tmpGen = uint8(random_number[18]);
    if (tmpGen >= 153) 
        if (tmpGen < 192) 
            resultGen[0] += 1;
        else if (tmpGen < 230)
            resultGen[0] += 2;
            else if (tmpGen < 243)
                resultGen[0] += 3;
                else
                    resultGen[0] += 4;
    resultGen[0] = resultGen[0] << 8;
//19 reserved
//    resultGen[0] = resultGen[0] + uint8(random_number[19]) % 5;
    resultGen[0] = resultGen[0] << 8;
//20 mutagenImutable 00h-FFh
    resultGen[0] = resultGen[0] + uint8(random_number[20]);
    resultGen[0] = resultGen[0] << 24;
//21 +detailPawsGen = 00h
//    resultGen[0] = resultGen[0] + uint8(random_number[21]) % 5;
//    resultGen[0] = resultGen[0] << 8;
//22 reserved
//    resultGen[0] = resultGen[0] + uint8(random_number[22]) % 5;
//    resultGen[0] = resultGen[0] << 8;
//23 detailClawsColorGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[23]) % 5;
    resultGen[0] = resultGen[0] << 8;
//24 +detailEyesGen = 00h - 04h
    tmpGen = uint8(random_number[24]);
    if (tmpGen >= 153) 
        if (tmpGen < 192) 
            resultGen[0] += 1;
        else if (tmpGen < 230)
            resultGen[0] += 2;
            else if (tmpGen < 243)
                resultGen[0] += 3;
                else
                    resultGen[0] += 4;
    resultGen[0] = resultGen[0] << 8;
//25 detailEyesColor1Gen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[25]) % 5;
    resultGen[0] = resultGen[0] << 8;
//26 detailEyesColor2Gen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[26]) % 5;
    resultGen[0] = resultGen[0] << 40;
//27 reserved
//    resultGen[0] = resultGen[0] + uint8(random_number[27]) % 5;
//    resultGen[0] = resultGen[0] << 8;
//28 reserved
//    resultGen[0] = resultGen[0] + uint8(random_number[28]) % 5;
//    resultGen[0] = resultGen[0] << 8;
//29 reserved
//    resultGen[0] = resultGen[0] + uint8(random_number[29]) % 5;
//    resultGen[0] = resultGen[0] << 8;
//30 rezerved 00h - 00h
//31 rezerved 00h - 00h


//    resultGen[0] = resultGen[0] << 8;
    resultGen[1] = uint256(RNG(addressRNG).get32b(_from, _dragonID));
  }
}
