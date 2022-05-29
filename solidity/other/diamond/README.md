
# How to DEV ERC-2535

## Add a variable into storage

```solidity
library LibDiamond {
    struct DiamondStorage {
        // maps function selector to the facet address and
        // the position of the selector in the facetFunctionSelectors.selectors array
        mapping(bytes4 => FacetAddressAndPosition) selectorToFacetAndPosition;
        // maps facet addresses to function selectors
        mapping(address => FacetFunctionSelectors) facetFunctionSelectors;
        // facet addresses
        address[] facetAddresses;
        // Used to query if a contract implements an interface.
        // Used to implement ERC-165.
        mapping(bytes4 => bool) supportedInterfaces;
        // owner of the contract
        address contractOwner;


        string a;
    }
}

```

##   

```solidity

contract DiamondCutFacet {}

```

```solidity

contract Diamond {

    constructor(address _contractOwner, address _diamondCutFacet) payable {} // Set contract owner
}
```

1. Add Contracts' interfaces in DiamondInit.

```solidity

contract DiamondInit {

    // You can add parameters to this function in order to pass in 
    // data to set your own state variables
    function init() external {
        // adding ERC165 data
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.supportedInterfaces[type(IERC165).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;
        ds.supportedInterfaces[type(IERC173).interfaceId] = true;

        // add your own state variables 
        // EIP-2535 specifies that the `diamondCut` function takes two optional 
        // arguments: address _init and bytes calldata _calldata
        // These arguments are used to execute an arbitrary function using delegatecall
        // in order to set state variables in the diamond during deployment or an upgrade
        // More info here: https://eips.ethereum.org/EIPS/eip-2535#diamond-interface 
    }
}
```

# Want to view info ?

See [Louper Docs](docs/louper.md)

# Deploy checklist

## Deploying contracts checklist.

### Prerequisite

- [ ] npm, yarn, npm install.
- [ ] Owner's Private Key.
- [ ] Provide environment variables as in the following table (**Only** provide not-changing contracts)

| **ENV**              | **/OR FILE PATH**            | **DESCRIPTION**              |
|:--------------------:|:----------------------------:|:----------------------------:|
| ERC_721_HOLDER_FACET | ./address/erc721HolderFacet  | ERC_721_HOLDER_FACET address |
| ERC_721_HOLDER_FACET | ./address/erc1155HolderFacet | ERC_721_HOLDER_FACET address |
| MARKET_FACET         | ./address/market             | MARKET_FACET  address        |
| DIAMOND_FACET        | ./address/diamond            | DIAMOND_FACET address        |
| HUUK_721             | ./address/huuk721            | HUUK_721 address             |
| HUUK_721_PREMIUM     | ./address/huuk721Premium     | HUUK_721_PREMIUM address     |
| HUUK_1155            | ./address/huuk1155           | HUUK_1155 address            |
| HUUK_1155_PREMIUM    | ./address/huuk1155Premium    | HUUK_1155_PREMIUM address    |

### Basic flow

#### Please use this checklist in this chronological order.

- [ ] Set target blockchain.

```bash
export TARGET_BC=bsc_test_net
```

- [ ] Pause the current contract if needed.

```bash
yarn hardhat run ./scripts/huuk1155.js --network ${TARGET_BC}
```

- [ ] Deploy 1155 contract

```bash
yarn hardhat run ./scripts/huuk1155.js --network ${TARGET_BC}
```

- [ ] Deploy 1155 Premium contract

```bash
yarn hardhat run ./scripts/huuk1155Premium.js --network ${TARGET_BC}
```

- [ ] Deploy 721 contract

```bash
yarn hardhat run ./scripts/huuk721.js --network ${TARGET_BC}
```

- [ ] Deploy 721 Premium contract

```bash
yarn hardhat run ./scripts/huuk721Premium.js --network ${TARGET_BC}
```

- [ ] Deploy Exchange contract

```bash
yarn hardhat run ./scripts/exchange.js --network ${TARGET_BC}
```

- [ ] Deploy Profit Estimator contract

```bash
yarn hardhat run ./scripts/profitEstimator.js --network ${TARGET_BC}
```

- [ ] Deploy Referral contract

```bash
yarn hardhat run ./scripts/referral.js --network ${TARGET_BC}
```

- [ ] Deploy ERC20 contract (For testing purposes)

```bash
yarn hardhat run ./scripts/erc20.js --network ${TARGET_BC}
```

- [ ] Deploy ERC1155HolderFacet contract

```bash
yarn hardhat run ./scripts/erc1155HolderFacet.js --network ${TARGET_BC}
```

- [ ] Deploy ERC721HolderFacet contract

```bash
yarn hardhat run ./scripts/erc721HolderFacet.js --network ${TARGET_BC}
```

- [ ] Deploy Diamond contract

```bash
yarn hardhat run ./scripts/deployDiamond.js --network ${TARGET_BC}
```

- [ ] Set/Update proxy for ERC Contracts (if deploying new erc contracts or diamond contract)

```bash
yarn hardhat run ./scripts/setProxy.js --network ${TARGET_BC}
```

- [ ] Deploy MarketFacet contract

```bash
yarn hardhat run ./scripts/market.js --network ${TARGET_BC}
```

- [ ] Remove Old Functions (if upgrade)

```bash
yarn hardhat run ./scripts/removeFacet.js --network ${TARGET_BC}
```

- [ ] Config(Add) facets

```bash
yarn hardhat run ./scripts/addFacet.js --network ${TARGET_BC}
```

- [ ] Upload market contract's code for verifying, managing, and debugging purposes

```bash
yarn hardhat verify --network ${TARGET_BC} $(cat ./address/market)
```

- [ ] Set Payment Methods

- [ ] Migrate data from old contract (See [How to migrate](./migration/README.md))