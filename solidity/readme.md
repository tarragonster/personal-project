# Solidity working document

###Problem
####Context
It's hard to debug smart-contract
####Solutions
- force execution of smart-contract on testnet
- pass struct object as params (pass as tuple)

```shell
[["0xFF08483293718b26a098f662EA3B232332DFe02E","0x7057B47d965707a6d0b70BeE1F157A12bba5Bb49",0,"test",1,1,10,27,true],"0x0000000000000000000000000000000000000000","100000000000000",1]
```

- Use Tenderly

Ref: [How to pass struct params in remix ide?](https://ethereum.stackexchange.com/questions/72435/how-to-pass-struct-params-in-remix-ide) \
Ref: [Tenderly failed transaction example](https://dashboard.tenderly.co/Stiffpillow/project/tx/bsc-testnet/0x1a6f01ce0592781b2db8c2c67a963f7c5686784a06f703af35c685ab21a313ff) \

###Gasless Transaction
[DOCS] - EasyFi Network [Meta Transactions: What are Gasless Transactions?](https://easyfinetwork.medium.com/meta-transactions-what-are-gasless-transactions-ee71b88d7fad) \
[DOCS] - OpenZeppelin [Relay](https://docs.openzeppelin.com/defender/relay) \
[DOCS] - Philippe Castonguay [Off-Chain Whitelist with On-Chain Verification](https://medium.com/@PhABC/off-chain-whitelist-with-on-chain-verification-for-ethereum-smart-contracts-1563ca4b8f11) \
[DEMO] - OpenZeppelin [Gasless MetaTransactions with OpenZeppelin Defender](https://www.youtube.com/watch?v=mhAUmULLV44) \
[DEMO] - CHANG DING [On-chain Digital Signatures Verification](https://www.youtube.com/watch?v=rtyaD-RASbQ) \
[CODE] - YosephKS [metatransactions](https://github.com/YosephKS/moralis-biconomy-metatransactions) \
[CODE] - Pascal Marco Caversaccio [Understanding Ethereum ERC-20 Meta-Transactions](https://betterprogramming.pub/ethereum-erc-20-meta-transactions-4cacbb3630ee) \


###Reference
[Series] [Solidity by Example](https://solidity-by-example.org) \
[Series] [Smart Contract Programmer](https://www.youtube.com/watch?v=nopo9KwwRg4&list=PLO5VPQH6OWdVQwpQfw9rZ67O6Pjfo6q-p&index=33) \

[Proposal] [EIP](https://eips.ethereum.org/meta) \
[ENV] - NomicFoundation [hardhat](https://hardhat.org/getting-started/) \
[DOCS] - Gavin Wood [Solidity](https://docs.soliditylang.org/en/v0.8.12/introduction-to-smart-contracts.html) \
[DOCS] - OpenZeppelin [openzeppelin-docs](https://docs.openzeppelin.com) \

[CODE] - NomicFoundation [hardhat](https://github.com/NomicFoundation/hardhat) \
[CODE-LIB] - OpenZeppelin [openzeppelin-contracts](https://github.com/OpenZeppelin/openzeppelin-contracts) \

[TOOL] - OpenZeppelin [wizard](https://wizard.openzeppelin.com) \
[DOCS] - Solidity [Cheatsheet](https://docs.soliditylang.org/en/v0.8.10/cheatsheet.html?highlight=interfaceId#global-variables) \
[Community] - abcoathup [Why use _msgSender() rather than msg.sender?](https://forum.openzeppelin.com/t/why-use-msgsender-rather-than-msg-sender/4370) \

[Tool] - [Ethereum input data decoder](https://lab.miguelmota.com/ethereum-input-data-decoder/example/) \