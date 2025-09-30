// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UniqueRugResponder {
    event SupplyDrop(
        bytes4 tag,
        address indexed token,
        uint256 prev,
        uint256 cur,
        uint256 dropBps,
        uint256 atBlock,
        address caller
    );

    function execute(bytes calldata payload) external {
        (
            bytes4 tag,
            address token,
            uint256 prev,
            uint256 cur,
            uint256 dropBps,
            uint256 atBlock
        ) = abi.decode(payload, (bytes4, address, uint256, uint256, uint256, uint256));

        emit SupplyDrop(tag, token, prev, cur, dropBps, atBlock, msg.sender);
    }
}
