pragma solidity ^0.4.21;
contract DESTROYER {
    function destroy() external {
        selfdestruct(msg.sender);
    }
}
