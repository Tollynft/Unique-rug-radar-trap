# UniqueRug Radar Trap (PoC)

## Overview
A **Drosera proof-of-concept trap** that detects unusual ERC-20 token supply changes.  
Large sudden drops in `totalSupply` can indicate manipulations, exploits, or hidden risks.

## How It Works
- `collect()` → Reads `totalSupply()` from the token contract.  
- `shouldRespond()` → Compares consecutive values.  
   - If the supply decreases by **≥15%**, the trap flags it.  

## Example Test Log
collect() #1 → totalSupply: 1,000,000  
collect() #2 → totalSupply:   850,000  
shouldRespond([#1, #2]) → **true** (drop = 15%)
