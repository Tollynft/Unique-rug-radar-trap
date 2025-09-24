// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title UniqueRugRadar - Drosera Test Trap
/// @notice Test-only trap for detecting unusual changes in ERC20 totalSupply.
contract UniqueRugRadar {
    uint256 public lastSupply;

    struct SupplyData {
        uint256 supply;
        uint256 timestamp;
    }

    SupplyData[] public history;

    /// @notice Collects the current totalSupply value (test placeholder).
    function collect(uint256 currentSupply) external {
        history.push(SupplyData(currentSupply, block.timestamp));
        lastSupply = currentSupply;
    }

    /// @notice Checks if supply dropped by ≥10% between last two collections.
    function shouldRespond() external view returns (bool) {
        if (history.length < 2) return false;
        SupplyData memory prev = history[history.length - 2];
        SupplyData memory curr = history[history.length - 1];

        if (prev.supply == 0) return false;
        uint256 drop = ((prev.supply - curr.supply) * 100) / prev.supply;
        return drop >= 10;
    }
}
