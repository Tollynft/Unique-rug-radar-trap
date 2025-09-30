// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Drosera Trap Interface
interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);
}

/// @dev Minimal ERC20-like interface
interface IERC20Like {
    function totalSupply() external view returns (uint256);
}

/// @title Unique Rug Radar Trap
/// @notice Detects large supply drops (possible rugs) in ERC20 tokens
contract UniqueRugRadar is ITrap {
    // Hardcoded token address (replace this with the target ERC20 when deploying)
    IERC20Like constant TOKEN = IERC20Like(0x0000000000000000000000000000000000000000);

    // 15% threshold in basis points (1500 = 15%)
    uint256 constant THRESHOLD_BPS = 1500;

    // Tag identifier for this trap
    bytes4 constant TAG = 0x55525231; // "URR1"

    struct Snap {
        uint256 supply;
        uint256 blockNumber;
    }

    constructor() {}

    /// @notice Collect current state (supply + block number)
    function collect() external view override returns (bytes memory) {
        return abi.encode(Snap({
            supply: TOKEN.totalSupply(),
            blockNumber: block.number
        }));
    }

    /// @notice Decide whether to respond (if supply dropped >=15%)
    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) return (false, "");

        Snap memory cur = abi.decode(data[0], (Snap));
        Snap memory prev = abi.decode(data[1], (Snap));

        // No response if supply increased or stayed same
        if (prev.supply == 0 || cur.supply >= prev.supply) return (false, "");

        uint256 drop = prev.supply - cur.supply;
        uint256 dropBps = (drop * 10_000) / prev.supply;

        if (dropBps >= THRESHOLD_BPS) {
            // Payload encodes detection info
            return (
                true,
                abi.encode(TAG, address(TOKEN), prev.supply, cur.supply, dropBps, cur.blockNumber)
            );
        }

        return (false, "");
    }
}
