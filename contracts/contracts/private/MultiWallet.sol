pragma solidity ^0.4.24;

import "../security/ReentrancyGuard.sol";


contract MultiWallet is ReentrancyGuard {
    address wallet1_7 = 0x98F04b28946C73D049c04A63Ac1F3352689F23bf; // Renat
    address wallet2_7 = 0x36d9399A33C4851526D541E0e4B577E5dAdc6be0; // Igor
    address wallet3_7 = 0x4044f3164AE9465c249963ffF008420171a3E522; // Alexander
    address wallet4_7 = 0x181d493A0499E81726FB7dfFa698d2923e780669; // Ivan
    address wallet5_2 = 0x27DC375Ce528832B0b1955A288c411CaE4Ac7c12; // Kate tmp Igor
    address wallet6_10 = 0xfa01d5584B39A46f384168e32A86Ae2d48F7D1Aa; // disgner department 10% tmp Alexander
    address wallet7_8  = 0x888430ed4d28603286d59eDD12B3C1afCCe35657; //  NN
    address wallet8_309 = 0xFF996042E1f9e11c9658e5bEdce2363F853490F1; //  prodaction work Ivan
    address wallet9_005 = 0x246C5881E3F109B2aF170F5C773EF969d3da581B; // Rinat
    address wallet10_206 = 0xb2406fe92dA73f6ed175862007b5cb7d781d881D; //  prodaction invester return tmp Igor

    function() public payable { }
    
    function divide() external nonReentrant {
        uint256 totalBalance = address(this).balance;
        uint256 w309 = totalBalance * 309 / 1000;
        uint256 w10 = totalBalance * 1 / 10;
        uint256 w7  = totalBalance * 7 / 100;
        uint256 w8  = totalBalance * 2 / 25;
        uint256 w2  = totalBalance * 1 / 50;
        uint256 w05 = totalBalance * 1 / 200;
        
        wallet1_7.transfer(w7);
        wallet2_7.transfer(w7);
        wallet3_7.transfer(w7);
        wallet4_7.transfer(w7);
        wallet5_2.transfer(w2);
        wallet6_10.transfer(w10);
        wallet7_8.transfer(w8);
        wallet8_309.transfer(w309);
        wallet9_005.transfer(w05);        
        wallet10_206.transfer(totalBalance - w7 * 4 - w2 - w10 - w8 - w309 - w05);
   }
   function changeWallet1(address _newWallet) external {
       require(msg.sender == wallet1_7);
       wallet1_7 = _newWallet;
   }
   function changeWallet2(address _newWallet) external {
       require(msg.sender == wallet2_7);
       wallet2_7 = _newWallet;
   }
   function changeWallet3(address _newWallet) external {
       require(msg.sender == wallet3_7);
       wallet3_7 = _newWallet;
   }
   function changeWallet4(address _newWallet) external {
       require(msg.sender == wallet4_7);
       wallet4_7 = _newWallet;
   }
   function changeWallet5(address _newWallet) external {
       require(msg.sender == wallet5_2);
       wallet5_2 = _newWallet;
   }
   function changeWallet6(address _newWallet) external {
       require(msg.sender == wallet6_10);
       wallet6_10 = _newWallet;
   }
   function changeWallet7(address _newWallet) external {
       require(msg.sender == wallet7_8);
       wallet7_8 = _newWallet;
   }
   function changeWallet8(address _newWallet) external {
       require(msg.sender == wallet8_309);
       wallet8_309 = _newWallet;
   }
   function changeWallet9(address _newWallet) external {
       require(msg.sender == wallet9_005);
       wallet9_005 = _newWallet;
   }
   function changeWallet10(address _newWallet) external {
       require(msg.sender == wallet10_206);
       wallet10_206 = _newWallet;
   }
 
}
