#How To Deploy and Use Louper

## Using free services
- [https://louper.dev](https://louper.dev)
- [https://louper.uetbc.xyz](https://louper.uetbc.xyz/)
- Example: [link](https://louper.dev/diamond/0xb1F7A9319900d5F2Cbe6e99AB7ADcCF7296ca261?network=binance_testnet)
## Self-deploy

### Prerequisite
- [ ] docker
- [ ] docker-compose
- [ ] supabase
- [ ] etherscan api key
- [ ] infura api key (if needed!)
### Docker-compose base config
```yaml
version: '3.3'
networks:
  dev:
   name: louper
services:
  louper:
    image: sonntuet1997/louper
    networks:
      - dev
    environment:
      - SUPABASE_URL
      - SUPABASE_ANON_KEY
      - BINANCE_TESTNET_ETHERSCAN_API_KEY
      - BINANCE_ETHERSCAN_API_KEY
      - POLYGON_ETHERSCAN_API_KEY
      - MUMBAI_ETHERSCAN_API_KEY
      - INFURA_API_KEY
    restart: "always"
```

