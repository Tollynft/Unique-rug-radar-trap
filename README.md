# Unique Rug Radar Trap

This trap provides an on-chain monitoring solution for ERC20 tokens by detecting sudden **drops in total supply**.  
A sharp decrease in supply (≥ 15%) is often a red flag for a potential **rug pull** or malicious token burn.  

It serves as a practical and effective example of **rug detection** using Drosera.

---

## What It Does

The primary function of this trap is to catch **suspicious supply changes** that could signal a rug.  
By monitoring snapshots of an ERC20’s `totalSupply`, it alerts when a large supply reduction occurs.  

- **Trap Purpose:** Detect rug-pull–style token supply manipulation.  
- **Responder Purpose (optional):** Emit on-chain events when triggered for easy indexing and real-time alerts.  

---

## How It Works

This trap is highly relevant for DeFi ecosystems where rug pulls remain a persistent threat:


- **`UniqueRugRadar.sol`** – The main trap contract.  
  - **Collects:** The current `totalSupply` and block number of the token.  
  - **Analyzes:** Compares the most recent snapshot with the previous one.  
  - **Responds:** If the supply has dropped by **≥ 15%**, it returns `true` and encodes details of the drop.  

- **`UniqueRugResponder.sol`** – An optional responder contract.  
  - When triggered, it emits a `SupplyDrop` event containing:  
    - Tag (URR1)  
    - Token address  
    - Previous supply  
    - Current supply  
    - Drop percentage (in basis points)  
    - Block number  

---

## Real-World Use Case

This trap is useful for anyone tracking ERC20 tokens in DeFi:

- **Investors / Traders:** Spot sudden supply cuts that could mean an exit scam.  
- **Risk Monitors:** Integrate with dashboards to boost DeFi safety.  
- **Alert Systems:** Combine with responders to trigger automated alerts on Telegram, Discord, or monitoring pipelines.
- **Security Dashboards:** Serve as a data source for auditors or analytics teams to highlight suspicious token behavior.


---

## drosera.toml

```toml
name = "UniqueRugRadar"
version = "0.1.0"
description = "Drosera trap that flags totalSupply drops ≥15% for ERC20 tokens."
authors = ["Tolly_nft"]

response_function = "execute(bytes)"
