pragma solidity ^0.4.23;

import "../security/ReentrancyGuard.sol";


contract MultiWallet is ReentrancyGuard {
    address wallet1_18 = 0x98F04b28946C73D049c04A63Ac1F3352689F23bf; // Renat
    address wallet2_18 = 0x36d9399A33C4851526D541E0e4B577E5dAdc6be0; // Igor
    address wallet3_18 = 0x971bCD2823ab07b39eA765Bd5863A4e63e0c7205; // Alexander
    address wallet4_18 = 0x181d493A0499E81726FB7dfFa698d2923e780669; // Ivan
    address wallet5_8  = 0x27DC375Ce528832B0b1955A288c411CaE4Ac7c12; // disigner1 8 Masha tmp Igor
    address wallet6_2  = 0xbF588e41A13314b84C22b3e2215f56DefE09C638; // disgner2 2 Evgeniy tmp Alexander
    address wallet7_8  = 0xff996042e1f9e11c9658e5bedce2363f853490f1; //  ads Ivan
    address wallet8_10 = 0xff996042e1f9e11c9658e5bedce2363f853490f1; //  prodaction Ivan


    function() public payable { }
    
    function divide() external nonReentrant {
        uint256 totalBalance = address(this).balance;
        uint256 w18 = totalBalance * 9 / 50;
//      uint256 w10 = totalBalance * 1 / 10;
        uint256 w8  = totalBalance * 2 / 25;
        uint256 w2  = totalBalance * 1 / 50;
        wallet1_18.transfer(w18);
        wallet2_18.transfer(w18);
        wallet3_18.transfer(w18);
        wallet4_18.transfer(w18);
        wallet5_8.transfer(w8);
        wallet6_2.transfer(w2);
        wallet7_8.transfer(w8);
        wallet8_10.transfer(totalBalance - w18 * 4 - w8 * 2 - w2);
        
    
   }
   function changeWallet1(address _newWallet) external {
       require(msg.sender == wallet1_18);
       wallet1_18 = _newWallet;
   }
   function changeWallet2(address _newWallet) external {
       require(msg.sender == wallet2_18);
       wallet2_18 = _newWallet;
   }
   function changeWallet3(address _newWallet) external {
       require(msg.sender == wallet3_18);
       wallet3_18 = _newWallet;
   }
   function changeWallet4(address _newWallet) external {
       require(msg.sender == wallet4_18);
       wallet4_18 = _newWallet;
   }
   function changeWallet5(address _newWallet) external {
       require(msg.sender == wallet5_8);
       wallet5_8 = _newWallet;
   }
   function changeWallet6(address _newWallet) external {
       require(msg.sender == wallet6_2);
       wallet6_2 = _newWallet;
   }
   function changeWallet7(address _newWallet) external {
       require(msg.sender == wallet7_8);
       wallet7_8 = _newWallet;
   }
   function changeWallet8(address _newWallet) external {
       require(msg.sender == wallet8_10);
       wallet8_10 = _newWallet;
   }
 
}
