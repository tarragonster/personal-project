import { ethers } from "hardhat";
const provider = ethers.providers.getDefaultProvider(
  "https://data-seed-prebsc-1-s2.binance.org:8545/"
);
const marketAddress = "0x219CBE6128FFB9568564E876F2E6C18a9889111C";
const userAddress = "0xC4c615c9e22a76272417cAFBA726317c36957a33";
const userPrivateKey =
  "e6bf2d3c72fee1c81721e0039fa0bbbfb28ea15a7c49917e44d7cc1efd51e62c";

const signer = new ethers.Wallet(userPrivateKey).connect(provider);

async function main() {
  const owner = "0xFF08483293718b26a098f662EA3B232332DFe02E";
  const token = "0x4Db3f02644968A9c4e3D8Cc244d89c25e442BCA8";
  const id = 0;
  const uri = "test";
  const initialSupply = 1;
  const maxSupply = 1;
  const royaltyFee = 10;
  const signerNonce = 10; // TODO change this value
  const isERC721 = true;

  const paymentToken = "0xA9389B343559E4c201d22BC573edfE17D81Da7D1";
  const price = ethers.utils.parseUnits("1", "ether");
  const amount = 1;
  const signature =
    "0xd42e4dab0b67df327a5ba4b4049d519d8a67c1fd63b1a8ab93a6b6f28c4c6c77187626e7837f027bd02732282969271e3db8fc249f3f18bd66a173e9497645f41b"; // TODO create signature
  const order = {
    token: {
      owner,
      token,
      id,
      uri,
      initialSupply,
      maxSupply,
      royaltyFee,
      nonce: signerNonce,
      isERC721,
    },
    paymentToken,
    price,
    amount,
  };

  console.log(order);
  const nonce = await provider.getTransactionCount(userAddress);
  const marketContract = (await ethers.getContractFactory("HuukMarket")).attach(
    marketAddress
  );

  const a = marketContract.connect(signer);

  try {
    await (await a.lazyBuy(order, amount, signature, { nonce })).wait();
  } catch (error) {
    console.log(error);
  }
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
