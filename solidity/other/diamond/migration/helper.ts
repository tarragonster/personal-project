import { ethers, upgrades } from "hardhat";
import { Huuk1155General, Huuk721General, HuukExchange, HuukMarket, MockERC20 } from "../typechain";

export const MockSotaExchange = async () => {
  const MockSotaExchange = await ethers.getContractFactory("MockSotaExchange");
  const mockSotaExchange = await MockSotaExchange.deploy();
  await mockSotaExchange.deployed();
  return mockSotaExchange.address;
};

export const Contract1155 = async (name: string, version: string, baseURI: string) => {
  const contract = await ethers.getContractFactory("Huuk1155General");
  return (await upgrades.deployProxy(contract, [name, version, baseURI], {
    kind: "uups",
  })) as any;
};
export const Contract721 = async (name: string, symbol: string, version: string, baseURI: string) => {
  const contract = await ethers.getContractFactory("Huuk721General");
  return (await upgrades.deployProxy(contract, [name, symbol, version, baseURI], {
    kind: "uups",
  })) as any;
};

export const ContractMarket = async (name: string, version: string) => {
  const contract = await ethers.getContractFactory("HuukMarket");
  return (await upgrades.deployProxy(contract, [name, version], {
    kind: "uups",
  })) as any;
};
export const ContractERC20 = async (name: string, symbol: string) => {
  const contract = await ethers.getContractFactory("MockERC20");
  return (await upgrades.deployProxy(contract, [name, symbol], {
    kind: "uups",
  })) as any;
};
export const ContractExchange = async (uniswapRouterAddress: string, USDTAddress: string, wrappedCoinAddress: string) => {
  const contract = await ethers.getContractFactory("HuukExchange");
  return (await upgrades.deployProxy(contract, [uniswapRouterAddress, USDTAddress, wrappedCoinAddress], {
    kind: "uups",
  })) as any;
};
export const ContractReferral = async (adminAddress: string) => {
  const contract = await ethers.getContractFactory("HuukReferral");
  return (await upgrades.deployProxy(contract, [], {
    kind: "uups",
  })) as any;
};

export const SetupContracts = async () => {
  const accounts = await ethers.getSigners();
  const custom1155Contract: Huuk1155General = await Contract1155("1155_name", "1155__version", "https://1155URI.com/");
  const marketContract: HuukMarket = await ContractMarket("Market_name", "Market_version");
  const erc20Contract: MockERC20 = await ContractERC20("MockERC20_name", "HUK");
  const referralContract: MockERC20 = await ContractReferral(accounts[0].address);

  let a = await marketContract.setPaymentMethod(erc20Contract.address, true);
  await a.wait();

  a = await marketContract.setReferralContract(referralContract.address);
  await a.wait();

  const ExchangeContract: HuukExchange = await ContractExchange("0x10ED43C718714eb63d5aA57B78B54704E256024E", erc20Contract.address, erc20Contract.address);
  a = await marketContract.setHuukExchangeContract(ExchangeContract.address);
  await a.wait();

  a = await erc20Contract.transfer(accounts[1].address, ethers.utils.parseEther("10000"));
  await a.wait();

  a = await custom1155Contract.setProxyAddress(marketContract.address);
  await a.wait();

  const custom721Contract: Huuk721General = await Contract721("721_name", "HUK", "721__version", "https://721URI.com/");

  a = await custom721Contract.setProxyAddress(marketContract.address);
  await a.wait();
  const contract1155Domain = {
    name: "1155_name",
    version: "1155__version",
    chainId: (await ethers.provider.getNetwork()).chainId,
    verifyingContract: custom1155Contract.address,
  };
  const contract721Domain = {
    name: "721_name",
    version: "721__version",
    chainId: (await ethers.provider.getNetwork()).chainId,
    verifyingContract: custom721Contract.address,
  };
  const contractMarketDomain = {
    name: "Market_name",
    version: "Market_version",
    chainId: (await ethers.provider.getNetwork()).chainId,
    verifyingContract: marketContract.address,
  };
  return {
    custom1155Contract,
    erc20Contract,
    marketContract,
    referralContract,
    custom721Contract,
    contract1155Domain,
    contract721Domain,
    contractMarketDomain,
  };
};
