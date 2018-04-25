pragma solidity ^0.4.23;
contract DESTROYER {
    function destroy() external {
        selfdestruct(msg.sender);
    }
}
