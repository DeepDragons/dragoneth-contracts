pragma solidity ^0.4.19;

import "../security/ReentrancyGuard.sol";


contract MultiWallet is ReentrancyGuard {
    address wallet1_18 = 0x98F04b28946C73D049c04A63Ac1F3352689F23bf; // Renat
    address wallet2_18 = 0x36d9399A33C4851526D541E0e4B577E5dAdc6be0; // Igor
    address wallet3_18 = 0x5eeE623EDC4FF9a72a85F5F40417E6AA8dEbC03d; // Alexander
    address wallet4_18 = 0xF66C90b5879405E6FD0b27F0077B13100c5b69c1;
    address wallet5_8  = 0xeC9FefdD828C28b4D1559548E5df6a460d83dB29; // disigner1 8 Masha
    address wallet6_2  = 0x1DbEd156A8423abe1aCE32abeBD972f29CceCd78; // disgner2 2 Eugen
    address wallet7_8  = 0x638a05783dB75e08095A45362E3f207601277dAe; // 5 ads
    address wallet8_10 = 0xfc4b10427678C60c3D1B0b80625657c95a29fFEe; //13 prodaction Igor


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
