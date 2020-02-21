pragma solidity ^0.6.1;


/**
 * @title Helps contracts guard agains reentrancy attacks.
 * @author Remco Bloemen <remco@2π.com>
 * @notice If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {

  /**
   * @dev We use a single lock for the whole contract.
   */
  bool private reentrancyLock = false;

  /**
   * @dev Prevents a contract from calling itself, directly or indirectly.
   * @notice If you mark a function `nonReentrant`, you should also
   * mark it `external`. Calling one nonReentrant function from
   * another is not supported. Instead, you can implement a
   * `private` function doing the actual work, and a `external`
   * wrapper marked as `nonReentrant`.
   */
  modifier nonReentrant() {
    require(!reentrancyLock);
    reentrancyLock = true;
    _;
    reentrancyLock = false;
  }

}

contract MultiWallet is ReentrancyGuard {
    address payable wallet1_10 = 0x98F04b28946C73D049c04A63Ac1F3352689F23bf; // Rinat
    address payable wallet2_10 = 0x36d9399A33C4851526D541E0e4B577E5dAdc6be0; // Igor
    address payable wallet3_10 = 0x4044f3164AE9465c249963ffF008420171a3E522; // Alexander
    address payable wallet4_10 = 0x181d493A0499E81726FB7dfFa698d2923e780669; // Ivan
    address payable wallet5_60 = 0xb2406fe92dA73f6ed175862007b5cb7d781d881D; //  prodaction Igor

    receive() external payable { }
    
    function divide() external nonReentrant {
        uint256 totalBalance = address(this).balance;
        uint256 w10 = totalBalance * 1 / 10;
        
        wallet1_10.transfer(w10);
        wallet2_10.transfer(w10);
        wallet3_10.transfer(w10);
        wallet4_10.transfer(w10);
        wallet5_60.transfer(totalBalance - 4 * w10);
   }
   function changeWallet1(address payable _newWallet) external {
       require(msg.sender == wallet1_10);
       wallet1_10 = _newWallet;
   }
   function changeWallet2(address payable _newWallet) external {
       require(msg.sender == wallet2_10);
       wallet2_10 = _newWallet;
   }
   function changeWallet3(address payable _newWallet) external {
       require(msg.sender == wallet3_10);
       wallet3_10 = _newWallet;
   }
   function changeWallet4(address payable _newWallet) external {
       require(msg.sender == wallet4_10);
       wallet4_10 = _newWallet;
   }
   function changeWallet5(address payable _newWallet) external {
       require(msg.sender == wallet5_60);
       wallet5_60 = _newWallet;
   }
 
}
