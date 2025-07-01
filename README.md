# ExaChain EVM Precompiles

A collection of EVM-compatible smart contract interfaces for interacting with ExaChain's native IBC (Inter-Blockchain Communication) functionality, specifically ICS-20 token transfers.

## Overview

This repository provides Solidity interfaces and contracts that enable EVM-based smart contracts to interact with ExaChain's native IBC capabilities. The primary focus is on ICS-20 fungible token transfers, allowing seamless cross-chain token movements through IBC protocols.

### Key Features

- **IBC Token Transfers**: Execute cross-chain token transfers using IBC ICS-20 protocol
- **Authorization Management**: Grant and revoke transfer permissions for other addresses
- **Denomination Tracing**: Query and manage IBC token denomination traces
- **EVM Compatibility**: Full compatibility with Ethereum tooling and development workflows

## Architecture

### Core Contracts

#### `ICS20I.sol`

The main interface for IBC ICS-20 token transfers. Provides functionality for:

- Cross-chain token transfers via IBC
- Querying denomination traces and hashes
- Managing transfer timeouts and memos

**Precompile Address**: `0x0000000000000000000000000000000000000802`

#### `IICS20Authorization.sol`

Authorization interface for managing transfer permissions:

- Approve/revoke transfer authorizations
- Increase/decrease allowances for specific channels and denominations
- Query existing allowances

#### `Types.sol`

Common data structures used throughout the contracts:

- `ICS20Allocation`: Represents transfer allocations with spend limits
- `Coin` and `DecCoin`: Token representation structures
- `Height`: IBC block height structure for timeouts
- `PageRequest`/`PageResponse`: Pagination structures

## Quick Start

### Prerequisites

- Node.js (v16 or later)
- Yarn package manager
- ExaChain node access

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd exachain-evm-precompiles
```

2. Install dependencies:

```bash
yarn install
```

3. Set up environment variables:

```bash
cp .env.example .env
# Edit .env with your private keys and network configurations
```

### Configuration

Configure your environment variables in `.env`:

```env
# Private keys for deployment
PRIVATE_KEY=your_private_key_here
PRIVATE_KEY2=additional_key_if_needed

# API Keys (optional, for verification)
ETHERSCAN_API_KEY=your_etherscan_api_key_here
COINMARKETCAP_API_KEY=your_coinmarketcap_api_key_here

# Gas reporting
REPORT_GAS=true
```

### Network Configuration

The project is configured for ExaChain network:

- **Chain ID**: 20250626
- **RPC URL**: http://128.199.120.187:8545
- **Local Development**: http://127.0.0.1:8545

## Usage

### Compiling Contracts

```bash
yarn compile
```

### Running Tests

```bash
yarn test
```

### Deploying Contracts

Deploy to local network:

```bash
yarn deploy:local
```

Deploy to ExaChain testnet:

```bash
yarn deploy:testnet
```

Deploy to ExaChain mainnet:

```bash
yarn deploy:mainnet
```

### Contract Interaction

The contracts are precompiled at specific addresses on ExaChain. You can interact with them directly:

```solidity
import "./contracts/ICS20I.sol";

contract MyContract {
    ICS20I constant ics20 = ICS20I(ICS20_PRECOMPILE_ADDRESS);

    function transferTokens(
        string memory sourcePort,
        string memory sourceChannel,
        string memory denom,
        uint256 amount,
        string memory receiver,
        string memory memo
    ) external {
        Height memory timeoutHeight = Height(0, 0); // No timeout

        ics20.transfer(
            sourcePort,
            sourceChannel,
            denom,
            amount,
            msg.sender,
            receiver,
            timeoutHeight,
            0, // No timestamp timeout
            memo
        );
    }
}
```

### Authorization Example

```solidity
import "./contracts/IICS20Authorization.sol";

contract AuthorizationExample {
    IICS20Authorization constant auth = IICS20Authorization(ICS20_PRECOMPILE_ADDRESS);

    function grantTransferPermission(
        address grantee,
        string memory sourcePort,
        string memory sourceChannel,
        string memory denom,
        uint256 amount
    ) external {
        Coin[] memory spendLimit = new Coin[](1);
        spendLimit[0] = Coin(denom, amount);

        string[] memory allowList = new string[](0);

        ICS20Allocation[] memory allocations = new ICS20Allocation[](1);
        allocations[0] = ICS20Allocation(
            sourcePort,
            sourceChannel,
            spendLimit,
            allowList
        );

        auth.approve(grantee, allocations);
    }
}
```

## Development

### Project Structure

```
├── contracts/              # Smart contract interfaces
│   ├── ICS20I.sol          # Main IBC transfer interface
│   ├── IICS20Authorization.sol # Authorization interface
│   └── Types.sol           # Common data structures
├── scripts/                # Deployment and interaction scripts
│   └── interaction/        # Contract interaction examples
├── config/                 # Configuration files
├── hardhat.config.ts       # Hardhat configuration
└── package.json           # Project dependencies
```

### Available Scripts

- `yarn compile` - Compile contracts
- `yarn test` - Run tests
- `yarn test:coverage` - Run tests with coverage
- `yarn deploy` - Deploy contracts
- `yarn verify` - Verify deployed contracts
- `yarn clean` - Clean artifacts
- `yarn node` - Start local Hardhat node
- `yarn console` - Open Hardhat console

### Gas Optimization

The contracts are configured with:

- Solidity optimizer enabled (200 runs)
- Via IR compilation for better optimization
- Gas reporting available via `REPORT_GAS=true`

## IBC Integration

### Understanding IBC Transfers

IBC (Inter-Blockchain Communication) enables secure token transfers between different blockchains. Key concepts:

- **Source Port/Channel**: Identifies the IBC connection endpoint
- **Denomination**: Token identifier, may include IBC path for foreign tokens
- **Timeout**: Prevents stuck transfers with height or timestamp limits
- **Memo**: Optional metadata for the transfer

### Denomination Tracing

IBC tokens have special denominations that encode their transfer path:

```
ibc/[hash] -> Full trace: transfer/channel-0/uatom
```

Use the provided functions to resolve traces:

```solidity
string memory hash = ics20.denomHash("transfer/channel-0/uatom");
DenomTrace memory trace = ics20.denomTrace(hash);
```

## Security Considerations

- Always validate input parameters before calling precompile functions
- Set appropriate timeouts to prevent stuck transfers
- Use authorization mechanisms to control access to transfer functions
- Consider gas costs for cross-chain operations

## License

This project is licensed under the LGPL-3.0 License.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## Support

For questions and support:

- Review the contract interfaces and documentation
- Check ExaChain documentation for IBC-specific details
- Open an issue for bugs or feature requests

---

**Note**: This project provides interfaces to precompiled contracts on ExaChain. The actual IBC functionality is implemented at the blockchain protocol level.
