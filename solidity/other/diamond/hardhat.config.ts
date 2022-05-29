import * as dotenv from "dotenv";

// import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "@openzeppelin/hardhat-upgrades";
require("hardhat-contract-sizer");

dotenv.config();
const { BSCSCAN_API_KEY, ENDPOINT, PRIVATE_KEY } = process.env;

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: any = {
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: false,
  },
  solidity: {
    version: "0.8.13",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      // forking: {
      //   enabled: true,
      //   url: process.env.MORALIS_ENDPOINT || "",
      // },
      allowUnlimitedContractSize: true,
      initialBaseFeePerGas: 0, // workaround from https://github.com/sc-forks/solidity-coverage/issues/652#issuecomment-896330136 . Remove when that issue is closed.
    },

    bsc_test_net: {
      chainId: 97,
      url: ENDPOINT || "https://data-seed-prebsc-1-s1.binance.org:8545/",
      // gas: 5000000000,
      // gasPrice: 100000000000000,
      accounts: [
        PRIVATE_KEY ||
          "cbb22eb483998270a509edac5cfcf2a7ad5861b23744c2b04b5e2387c4c95112"
      ],
    },
  },

  etherscan: {
    apiKey: BSCSCAN_API_KEY || "YI6YH86A2MFWH5N9GTZGZRTM54GASPVY69",
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
};

export default config;
