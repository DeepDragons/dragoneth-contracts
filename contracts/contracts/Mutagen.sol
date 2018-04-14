pragma solidity ^0.4.21;

import "./ERC20/MintableToken.sol";
import "./ERC20/BurnableToken.sol";

contract Mutagen is MintableToken, BurnableToken {
//    string public constant name = "DragonETH Mutagen";
//    string public constant symbol = "Mutagen";
    uint8  public constant decimals = 0;
    // TODO del on war deploy
    string public constant name = "Test game test";
    string public constant symbol = "Test";
    
}