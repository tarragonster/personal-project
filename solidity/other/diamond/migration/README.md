#How to do
### Prerequisite

- [ ] npm, yarn, npm install.
- [ ] Owner's Private Key.
- [ ] Provide environment variables as in the following table

|     **ENV**     | **/OR FILE PATH** | **DESCRIPTION** |
|:---------------:|:-----------------:|:---------------:|
|     MARKET      | ./address/market  | MARKET address  |
|     DIAMOND     | ./address/diamond | DIAMOND address |
| PAYMENT_METHODS |                   | payment methods |

### Checklist

- [ ] Set target blockchain.

```bash
export TARGET_BC=bsc_test_net
```

- [ ] Upgrade contract.

```bash
yarn hardhat run ./scripts/deployNewMarket.js --network ${TARGET_BC}
```

- [ ] Withdraw coins.

```bash
yarn hardhat run ./scripts/withdrawCoin.js --network ${TARGET_BC}
```

- [ ] Transfer NFTs.

```bash
yarn hardhat run ./scripts/transferNFT.js --network ${TARGET_BC}
```

- [ ] Transfer Data.

```bash
yarn hardhat run ./scripts/transferData.js --network ${TARGET_BC}
```

- [ ] Manually checking data (Optionally).

- [ ] MUST remove MigrationFacet (!Important: This facet allows any update on contract without any authorization).

```bash
yarn hardhat run ./scripts/removeMigrationFacet.js --network ${TARGET_BC}
```
