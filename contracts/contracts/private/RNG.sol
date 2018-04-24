pragma solidity ^0.4.21;


import "../security/rbac/RBACWithAdmin.sol";

contract RNG is RBACWithAdmin {

    uint256 private curAddressNum;
    uint256[10] private rndaddress;
   
    function RNG()  public{
       for(uint256 i=0;i<10;i++) {
           rndaddress[i] = uint256(keccak256(block.blockhash(block.number-2*i)));
       }
    }
    //onlyWhitelisted
  function get32b(address _from, uint256 _dragonID) external onlyRole("GenRNG") returns (bytes32 b32) {
    b32 = keccak256(rndaddress[1]+rndaddress[3]+rndaddress[5]+rndaddress[7]+rndaddress[9]+rndaddress[0]
    +rndaddress[2]+rndaddress[4]+rndaddress[6]+rndaddress[8]+uint256(_from)+curAddressNum+_dragonID);
    rndaddress[curAddressNum % 10 ] = uint256(keccak256(uint256(_from)+curAddressNum));
    curAddressNum++;
  }

}
