pragma solidity ^0.5.3;
contract DESTROYER {
    function destroy() external {
        selfdestruct(msg.sender);
    }
}
