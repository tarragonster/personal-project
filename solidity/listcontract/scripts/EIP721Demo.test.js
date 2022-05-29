const abi = require("./EIP721Demo.abi")
const ganache = require("ganache-cli");
const { ethers } = require("ethers")
const provider = new ethers.providers.JsonRpcProvider("http://127.0.0.1:8545");
const signer = new ethers.Wallet("c7e5439e7044a2a62763e3710b106e653157d47b15a9015d5262d3515fa69119", provider);
const contractAddress = "0x32c6eEeE4cE8Ce4a2E3b9057e33c00653085781C";

async function main() {
  const numA = 11;
  const numB = 12;
  const textA = "abc";
  const contract = new ethers.Contract(contractAddress, abi.EIP721DemoAbi, provider);

  const _createSignature = async () => {
    const data = await _createData();
    const domain = await _createDomain();
    const types = await _createTypes();
    return signer._signTypedData(domain, types, data)
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
    return { numA, numB, textA }
  }

  const _createDomain = async () => {
    const chainId = await contract.getChainID();
    return {
      name: "EIP721Demo",
      version: "V1",
      verifyingContract: contractAddress,
      chainId,
    }
  }

  const _createTypes = async () => {
    return {
      Data: [
        {name: "numA", type: "uint256"},
        {name: "numB", type: "uint256"},
        {name: "textA", type: "string"},
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
// ethers _signTypedData https://docs.ethers.io/v5/api/signer/
// https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct%5Bhashed%20struct%5D