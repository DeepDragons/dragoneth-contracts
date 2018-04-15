pragma solidity ^0.4.21;

import "../security/Whitelist.sol";

contract RNG {
function get2b32(address _from, uint256 _dragonID) external returns (bytes32[2] b32);
}
contract GenRNG is Whitelist {

  address private addressRNG;

  function GenRNG(address _addressRNG) public {
  addressRNG = _addressRNG;
}

function changeAddressRNG(address _addressRNG) external onlyAdmin {
  addressRNG = _addressRNG;
}

  function getNewGens(address _from, uint256 _dragonID) external onlyWhitelisted returns (uint256[2] resultGen) {
   bytes32[2] memory random_number;
   random_number = RNG(addressRNG).get2b32(_from, _dragonID);
   //00 rezerved(for color) 00h - 00h
//01 detailColorSchemaGen = 00h - 63h (99d)
    resultGen[0] = resultGen[0] + uint8(random_number[0][1]) % 100;
    resultGen[0] = resultGen[0] << 8;
//02*detailAuraGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][2]) % 5;
    resultGen[0] = resultGen[0] << 8;
//03 detailAuraColorGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][3]) % 5;
    resultGen[0] = resultGen[0] << 8;
//04 *detailWingsGen = 00h - 05h
    resultGen[0] = resultGen[0] + uint8(random_number[0][4]) % 6;
    resultGen[0] = resultGen[0] << 8;
//05 detailWingsColor1Gen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][5]) % 5;
    resultGen[0] = resultGen[0] << 8;
//06 detailWingsColor2Gen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][6]) % 5;
    resultGen[0] = resultGen[0] << 8;
//07 *detailTailGen = 00h - 07h
    resultGen[0] = resultGen[0] + uint8(random_number[0][7]) % 8;
    resultGen[0] = resultGen[0] << 8;
//08 detailTailColor1Gen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][8]) % 5;
    resultGen[0] = resultGen[0] << 8;
//09 detailTailColor2Gen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][9]) % 5;
    resultGen[0] = resultGen[0] << 8;
//10 +detailBodyGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][10]) % 5;
    resultGen[0] = resultGen[0] << 8;
//11 detailBodyColorGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][11]) % 5;
    resultGen[0] = resultGen[0] << 8;
//12 *detailSpotsGen = 00h - 09h
    resultGen[0] = resultGen[0] + uint8(random_number[0][12]) % 10;
    resultGen[0] = resultGen[0] << 8;
//13 detailSpotsColorGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][13]) % 5;
    resultGen[0] = resultGen[0] << 8;
//14 *detailScalesGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][14]) % 5;
    resultGen[0] = resultGen[0] << 8;
//15 detailScalesColorGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][15]) % 5;
    resultGen[0] = resultGen[0] << 8;
//16 *detailHornsGen = 00h - 07h
    resultGen[0] = resultGen[0] + uint8(random_number[0][16]) % 8;
    resultGen[0] = resultGen[0] << 8;
//17 --detailHornsColorGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][17]) % 5;
    resultGen[0] = resultGen[0] << 8;
//18 *detailHeadGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][18]) % 6;
    resultGen[0] = resultGen[0] << 8;
//19 detailHeadColorGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][19]) % 5;
    resultGen[0] = resultGen[0] << 8;
//20 mutagenImutable 00h-FFh
    resultGen[0] = resultGen[0] + uint8(random_number[0][20]);
    resultGen[0] = resultGen[0] << 8;
//21 *detailClawsGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][21]) % 5;
    resultGen[0] = resultGen[0] << 8;
//22 detailClawsColor1Gen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][22]) % 5;
    resultGen[0] = resultGen[0] << 8;
//23 detailClawsColor2Gen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][23]) % 5;
    resultGen[0] = resultGen[0] << 8;
//24 ?detailEyesGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][24]) % 5;
    resultGen[0] = resultGen[0] << 8;
//25 detailEyesColor1Gen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][25]) % 5;
    resultGen[0] = resultGen[0] << 8;
//26 detailEyesColor2Gen = 00h - 04h
    //resultGen[0] = resultGen[0] + uint8(random_number[0][26]) % 5;
    resultGen[0] = resultGen[0] << 8;
//27 *detailSpikesGen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][27]) % 5;
    resultGen[0] = resultGen[0] << 8;
//28 detailSpikesColor1Gen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][28]) % 5;
    resultGen[0] = resultGen[0] << 8;
//29 detailSpikesColor2Gen = 00h - 04h
    resultGen[0] = resultGen[0] + uint8(random_number[0][29]) % 5;
    resultGen[0] = resultGen[0] << 8;
//30 rezerved 00h - 00h
//31 rezerved 00h - 00h


    resultGen[0] = resultGen[0] << 8;
    resultGen[1] = uint256(random_number[1]);
  }
}
