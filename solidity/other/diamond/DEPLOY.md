#Huuk erc2535

- [ ] Deploy ERC1155HolderFacet contract

```bash
yarn hardhat run --network bsc_test_net ./scripts/erc1155HolderFacet.js
yarn hardhat verify --network bsc_test_net ${theAddress}
```

- [ ] Deploy ERC721HolderFacet contract

```bash
yarn hardhat run --network bsc_test_net ./scripts/erc721HolderFacet.js
yarn hardhat verify --network bsc_test_net ${theAddress}
```

- [ ] Deploy Diamond contract

```bash
yarn hardhat run --network bsc_test_net ./scripts/deployDiamond.js
yarn hardhat run --network bsc_test_net scripts/verify-contract.js
```

- [ ] Set/Update proxy for ERC Contracts (if deploying new erc contracts or diamond contract)

```bash
yarn hardhat run --network bsc_test_net ./scripts/setProxy.js
yarn hardhat verify --network bsc_test_net ${theAddress}
```

- [ ] Deploy MarketFacet contract

```bash
yarn hardhat run --network bsc_test_net ./scripts/market.js
yarn hardhat verify --network bsc_test_net ${theAddress}
```

- [ ] Remove Old Functions (if upgrade)

```bash
yarn hardhat run --network bsc_test_net ./scripts/removeFacet.js
yarn hardhat verify --network bsc_test_net ${theAddress}
```

- [ ] Config(Add) facets

```bash
yarn hardhat run --network bsc_test_net ./scripts/addFacet.js
yarn hardhat verify --network bsc_test_net ${theAddress}
```

- [ ] Upload market contract's code for verifying, managing, and debugging purposes

```bash
yarn hardhat verify --network bsc_test_net $(cat ./address/market)
```

- [ ] Initial params market contract

```bash
yarn hardhat run --network bsc_test_net scripts/verify-contract.js
```


# Reference

[Link] [Louper Scanner](https://louper.huuk.market/diamond/0x0cd367c2240B2DC3598b09aa1ed37E399bD5DF85?network=binance_testnet) \