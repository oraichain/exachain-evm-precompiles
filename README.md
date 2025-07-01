# Oracle Hub EVM

A decentralized oracle hub with multisig governance for price aggregation, ported from CosmWasm to Solidity for EVM chains. **Now with Chainlink AggregatorV3Interface compatibility!**

## Features

- **Multisig Governance**: Proposal creation and voting system with weighted members
- **Price Aggregation**: Median calculation from multiple oracle submissions
- **Hook System**: Extensible hook contracts for price processing
- **Chainlink Compatibility**: OracleHook implements AggregatorV3Interface for seamless DeFi integration
- **Pause Functionality**: Emergency pause/unpause capabilities
- **Comprehensive Testing**: Full test suite with Chainlink interface testing

## Chainlink AggregatorV3Interface Integration

Your OracleHook now implements Chainlink's `AggregatorV3Interface`, making it a **drop-in replacement** for Chainlink price feeds in DeFi protocols.

### How It Works

1. **OracleHub** receives price submissions from multiple oracles
2. **OracleHub** calculates median prices and executes proposals
3. **OracleHook** receives price updates and stores them as Chainlink-compatible rounds
4. **DeFi protocols** can read prices using the standard Chainlink interface

### Usage Example

```solidity
// DeFi protocol reading from OracleHook (same as Chainlink)
AggregatorV3Interface priceFeed = AggregatorV3Interface(oracleHookAddress);
(
    uint80 roundId,
    int256 answer,
    uint256 startedAt,
    uint256 updatedAt,
    uint80 answeredInRound
) = priceFeed.latestRoundData();

// Convert to price (assuming 18 decimals)
uint256 price = uint256(answer);
```

### Available Functions

- `latestRoundData()` - Get the latest price
- `getRoundData(uint80 roundId)` - Get historical price data
- `decimals()` - Get number of decimals (typically 18)
- `description()` - Get feed description
- `version()` - Get interface version

## Architecture

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│   Oracles   │───▶│  OracleHub   │───▶│ OracleHook  │
│ (Members)   │    │ (Governance) │    │(Aggregator) │
└─────────────┘    └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                    ┌──────────────┐    ┌─────────────┐
                    │   Proposals  │    │ DeFi Protocols│
                    │   & Voting   │    │ (Chainlink) │
                    └──────────────┘    └─────────────┘
```

## Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Compile Contracts

```bash
npm run compile
```

### 3. Run Tests

```bash
npm test
```

### 4. Deploy Contracts

```bash
# Deploy OracleHub with Chainlink integration
npm run deploy:chainlink

# Or deploy individual components
npm run deploy
```

## Deployment

### Basic Deployment

```bash
npx hardhat run scripts/deployment/deploy.ts --network <network>
```

### Chainlink-Compatible Deployment

```bash
npx hardhat run scripts/deployment/deploy-aggregator-wrappers.ts --network <network>
```

This deploys:

- **OracleHub**: Main governance contract
- **OracleHook**: Chainlink-compatible price feed (one per price key)

### Configuration

Update the deployment script with your parameters:

```typescript
const priceKeys = [
  { key: "BTC/USD", decimals: 18, description: "BTC/USD price feed" },
  { key: "ETH/USD", decimals: 18, description: "ETH/USD price feed" },
  // Add more price keys as needed
];
```

## Contract Overview

### OracleHub.sol

- **Purpose**: Main governance contract for price aggregation
- **Features**: Proposal creation, voting, median calculation
- **Governance**: Multisig with weighted members

### OracleHook.sol

- **Purpose**: Chainlink-compatible price feed
- **Interface**: Implements `AggregatorV3Interface`
- **Features**: Price storage, historical data, round management

### ChainlinkPriceFeed.sol

- **Purpose**: Chainlink price feed adapter (optional)
- **Features**: Reads from Chainlink aggregators
- **Use Case**: Hybrid oracle system

## Testing

### Run All Tests

```bash
npm test
```

### Run Specific Test Suites

```bash
# Unit tests
npx hardhat test test/unit/

# Integration tests
npx hardhat test test/integration/

# Chainlink interface tests
npx hardhat test test/integration/OracleHookAggregatorV3.test.ts
```

## Integration with DeFi Protocols

### 1. Direct Integration

Use OracleHook addresses as Chainlink price feeds:

```solidity
// In your DeFi contract
AggregatorV3Interface public priceFeed;

constructor(address _priceFeed) {
    priceFeed = AggregatorV3Interface(_priceFeed);
}

function getPrice() public view returns (uint256) {
    (, int256 answer, , , ) = priceFeed.latestRoundData();
    return uint256(answer);
}
```

### 2. Price Feed Registry

Register OracleHook addresses in a price feed registry:

```solidity
mapping(bytes32 => address) public priceFeeds;

function setPriceFeed(bytes32 asset, address aggregator) external onlyOwner {
    priceFeeds[asset] = aggregator;
}
```

### 3. Multi-Asset Support

Deploy one OracleHook per price key for multi-asset support.

## Security Features

- **Pause Mechanism**: Emergency pause/unpause functionality
- **Access Control**: Owner-only admin functions
- **Reentrancy Protection**: All external calls protected
- **Input Validation**: Comprehensive parameter validation
- **Deposit System**: Proposal deposit requirements

## Gas Optimization

- **Efficient Storage**: Optimized data structures
- **Batch Operations**: Support for multiple price updates
- **Minimal External Calls**: Reduced gas consumption

## Monitoring

### Events to Monitor

- `ProposalCreated`: New price proposals
- `VoteCast`: Member votes
- `ProposalExecuted`: Successful proposals
- `PriceUpdated`: New price data
- `RoundDataUpdated`: Chainlink round updates

### Key Metrics

- Proposal success rate
- Voting participation
- Price update frequency
- Gas usage per operation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

MIT License - see LICENSE file for details

## Support

- **Documentation**: [Chainlink Data Feeds API Reference](https://docs.chain.link/data-feeds/api-reference)
- **Issues**: Create an issue on GitHub
- **Discussions**: Use GitHub Discussions

---

**Note**: This implementation provides Chainlink compatibility while maintaining the governance and security features of the original CosmWasm oracle hub.
