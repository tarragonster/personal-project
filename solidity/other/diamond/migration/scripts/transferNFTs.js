import hre, { ethers } from "hardhat";

const fse = require("fs-extra");
const { MARKET, DIAMOND } = process.env;

export const transferNFTs = async () => {
  const accounts = await ethers.getSigners();
  const marketAddress = MARKET ?? fse.readFileSync("./address/market", "utf8");
  const diamondAddress = DIAMOND ?? fse.readFileSync("./address/diamond", "utf8");
  const newMarket = await hre.ethers.getContractAt("HuukMarketNew", marketAddress);
  const totalOrders = await newMarket.totalOrders();
  console.log("NFT amount in Old contract: ");
  for (let i = 0; i < totalOrders; i++) {
    const order = await newMarket.orders(i);
    if (order.isERC721) {
      const erc721 = await hre.ethers.getContractAt("Huuk721General", order.token.token);
      if ((await erc721.custom721Contract.ownerOf(order.token.id)) === newMarket.address) {
        console.log(`${order.token.token}-${order.token.id}:`, 1);
      } else {
        console.error(`${order.token.token}-${order.token.id}:`, 0);
      }
    } else {
      const erc1155 = await hre.ethers.getContractAt("Huuk115General", order.token.token);
      console.log(`${order.token.token}-${order.token.id}:`, await erc1155.balanceOf(marketAddress, order.token.id));
    }
  }
  console.log("Transfering........");
  const tx1 = await newMarket.transferNFTs(diamondAddress, {
    gasLimit: 800000,
  });
  await tx1.wait();
  console.log("......................Checking......................");
  console.log("NFT amount in new contract: ");
  for (let i = 0; i < totalOrders; i++) {
    const order = await newMarket.orders(i);
    if (order.isERC721) {
      const erc721 = await hre.ethers.getContractAt("Huuk721General", order.token.token);
      if ((await erc721.custom721Contract.ownerOf(order.token.id)) === diamondAddress.address) {
        console.log(`${order.token.token}-${order.token.id}:`, 1);
      } else {
        console.error(`${order.token.token}-${order.token.id}:`, 0);
      }
    } else {
      const erc1155 = await hre.ethers.getContractAt("Huuk115General", order.token.token);
      console.log(`${order.token.token}-${order.token.id}:`, await erc1155.balanceOf(diamondAddress, order.token.id));
    }
  }
};
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  transferNFTs()
    .then((add) => {
      // fse.outputFileSync("address/market", add);
    })
    // eslint-disable-next-line no-process-exit
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      // eslint-disable-next-line no-process-exit
      process.exit(1);
    });
}
