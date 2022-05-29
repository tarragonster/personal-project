const abi = require("./Huuk721.abi")
const { ethers } = require("ethers");
const provider = new ethers.providers.JsonRpcProvider("http://127.0.0.1:8545");
const signer = new ethers.Wallet("e4c992e6fe314bb3286c3c6fe273003f690346ff2aa2c3868c4f508605e56580", provider); // getPrivateKey https://ethereum.stackexchange.com/questions/103502/how-to-set-private-key-for-ethers-signer
const contractAddress = "0xc9E9d887B3A05f3a068fA9D36098649837c55Cf0"; //TODO change this

async function main() {
  const owner = String(signer.address);
  const uri = "abc";
  const royaltyFee = 10;
  const nonce = await provider.getTransactionCount(signer.address);
  const contract = new ethers.Contract(contractAddress, abi.Huuk721DemoAbi, provider);

  const _createSignature = async () => {
    const data = await _createData();
    const domain = await _createDomain();
    const types = await _createTypes();

    const sign = String(await signer._signTypedData(domain, types, data));
    return sign
  }

  const inputValue = async () => {
    const data = await _createData();
    const signature = await _createSignature();
    console.log({
      ...data,
      signature
    })
  }

  const _createData = async () => {
    return { owner, uri, royaltyFee, nonce }
  }

  const _createDomain = async () => {
    let chainId = await contract.getChainID();
    chainId = chainId.toString()
    
    return {
      name: "Huuk721",
      version: "V1",
      verifyingContract: contractAddress,
      chainId,
    }
  }

  const _createTypes = async () => {
    return {
      TokenInfo: [
        {name: "owner", type: "address"},
        {name: "uri", type: "string"},
        {name: "royaltyFee", type: "uint256"},
        {name: "nonce", type: "uint256"},
      ]
    }
  }
  inputValue();
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// ganache-cli --account_keys_path keys.json -> https://stackoverflow.com/questions/65470112/ganache-cli-how-to-read-private-key-from-account-json-file
// tuple param [11,12,"abc","0xcbe590d212822eb654605e0286b7232eec0f06136aaa6cf4b85c8bd529e30a5031ad863a6c371741b78d26cda61ddb72b7c0616e20b22012243ea9f5390444681c"]