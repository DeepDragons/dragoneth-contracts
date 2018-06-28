pragma solidity ^0.4.24;

import "../security/rbac/RBACWithAdmin.sol";

contract ProxyWallet is RBACWithAdmin {
    address mainWallet;
    
    constructor(address _mainWallet) public {
        mainWallet = _mainWallet;
    }
    function() public payable {
        mainWallet.transfer(msg.value);
    }
    function changeMainWallet(address _mainWallet) external onlyAdmin {
        mainWallet = _mainWallet;
    }
}