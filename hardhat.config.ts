import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-gas-reporter";
import "solidity-coverage";
import * as dotenv from "dotenv";

dotenv.config();

const PRIVATE_KEY =
  process.env.PRIVATE_KEY ||
  "0x0000000000000000000000000000000000000000000000000000000000000000";
const PRIVATE_KEY1 =
  process.env.PRIVATE_KEY2 ||
  "0x0000000000000000000000000000000000000000000000000000000000000000";
const PRIVATE_KEY2 =
  process.env.PRIVATE_KEY2 ||
  "0x0000000000000000000000000000000000000000000000000000000000000000";
const PRIVATE_KEY3 =
  process.env.PRIVATE_KEY3 ||
  "0x0000000000000000000000000000000000000000000000000000000000000000";
const PRIVATE_KEY4 =
  process.env.PRIVATE_KEY4 ||
  "0x0000000000000000000000000000000000000000000000000000000000000000";
const INFURA_API_KEY = process.env.INFURA_API_KEY || "";
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "";
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || "";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      viaIR: true,
    },
  },
  networks: {
    hardhat: {
      chainId: 1337,
      allowUnlimitedContractSize: true,
    },
    localhost: {
      url: "http://127.0.0.1:8545",
      chainId: 20250626,
      accounts: [PRIVATE_KEY],
    },
    exachain: {
      url: "http://128.199.120.187:8545",
      chainId: 20250626,
      accounts: [
        PRIVATE_KEY,
        PRIVATE_KEY1,
        PRIVATE_KEY2,
        PRIVATE_KEY3,
        PRIVATE_KEY4,
      ],
      timeout: 120000, // 2 minutes timeout
      httpHeaders: {
        "User-Agent": "hardhat",
        "Content-Type": "application/json",
      },
      gas: "auto",
      gasPrice: "auto",
      gasMultiplier: 1.2,
      allowUnlimitedContractSize: true,
      blockGasLimit: 30000000,
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
    coinmarketcap: COINMARKETCAP_API_KEY,
    token: "ETH",
  },
  etherscan: {
    apiKey: {
      mainnet: ETHERSCAN_API_KEY,
      sepolia: ETHERSCAN_API_KEY,
      polygon: process.env.POLYGONSCAN_API_KEY || "",
      bsc: process.env.BSCSCAN_API_KEY || "",
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  mocha: {
    timeout: 120000, // 2 minutes timeout for tests
  },
};

export default config;
