pragma solidity ^0.4.21;


import "../security/PrivateWitelist.sol";

contract RNG is PrivateWhitelist {

    uint256 private curAddressNum;
    uint256[10] private rndaddress;
   
    function RNG()  public{
       for(uint256 i=0;i<10;i++) {
           rndaddress[i] = uint256(keccak256(block.blockhash(block.number-2*i)));
       }
    }
  function get2b32(address _from, uint256 _dragonID) external onlyWhitelisted returns (bytes32[2] b32) {
    b32[0] = keccak256(rndaddress[0]+rndaddress[2]+rndaddress[4]+rndaddress[6]+rndaddress[8]+uint256(_from)+curAddressNum+_dragonID);

    b32[1] = keccak256(rndaddress[1]+rndaddress[3]+rndaddress[5]+rndaddress[7]+rndaddress[9]+uint256(_from)+curAddressNum+_dragonID);
    rndaddress[curAddressNum % 10 ] = uint256(keccak256(uint256(_from)+curAddressNum));
    curAddressNum++;
  }

}
