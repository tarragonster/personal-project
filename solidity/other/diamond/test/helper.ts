import { ethers, upgrades } from "hardhat";
import {
  Huuk1155General,
  Huuk721General,
  HuukExchange,
  HuukMarketFacet,
  ERC721HolderFacet,
  ERC1155HolderFacet,
  MockERC20,
  OperationFacet,
  OwnershipFacet,
  DiamondLoupeFacet,
  DiamondCutFacet,
} from "../typechain";
import { FacetCutAction, getSelectors } from "../scripts/libraries/diamond.js";
import { deployDiamond } from "../scripts/deployDiamond";

export const MockSotaExchange = async () => {
  const MockSotaExchange = await ethers.getContractFactory("MockSotaExchange");
  const mockSotaExchange = await MockSotaExchange.deploy();
  await mockSotaExchange.deployed();
  return mockSotaExchange.address;
};

export const SOTAReferral = async () => {
  const SOTAReferral = await ethers.getContractFactory("SOTAReferral");
  const sOTAReferral = await SOTAReferral.deploy();
  await sOTAReferral.deployed();
  return sOTAReferral.address;
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

export const ContractERC1155HolderFacet = async () => {
  const ERC1155HolderFacet = await ethers.getContractFactory("ERC1155HolderFacet");
  const eRC1155HolderFacet = await ERC1155HolderFacet.deploy();
  await eRC1155HolderFacet.deployed();
  return eRC1155HolderFacet as any;
};
export const ContractERC721HolderFacet = async () => {
  const ERC721HolderFacet = await ethers.getContractFactory("ERC721HolderFacet");
  const eRC721HolderFacet = await ERC721HolderFacet.deploy();
  await eRC721HolderFacet.deployed();
  return eRC721HolderFacet as any;
};
export const ContractMarket = async () => {
  const HuukMarketFacet = await ethers.getContractFactory("HuukMarketFacet");
  const huukMarketFacet = await HuukMarketFacet.deploy();
  await huukMarketFacet.deployed();
  return huukMarketFacet;
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
export const ContractReferral = async () => {
  const contract = await ethers.getContractFactory("HuukReferral");
  return (await upgrades.deployProxy(contract, [], {
    kind: "uups",
  })) as any;
};

export const SetupContracts = async () => {
  const accounts = await ethers.getSigners();
  const custom1155Contract: Huuk1155General = await Contract1155("1155_name", "1155__version", "https://1155URI.com/");
  // const [marketContract, libSign] = await ContractMarket(
  //   "Market_name",
  //   "Market_version"
  // );
  const erc20Contract: MockERC20 = await ContractERC20("MockERC20_name", "HUK");
  const referralContract: MockERC20 = await ContractReferral();

  const diamondAddress = await deployDiamond();
  const diamondCutFacet: DiamondCutFacet = await ethers.getContractAt("DiamondCutFacet", diamondAddress);
  const diamondLoupeFacet: DiamondLoupeFacet = await ethers.getContractAt("DiamondLoupeFacet", diamondAddress);
  const ownershipFacet: OwnershipFacet = await ethers.getContractAt("OwnershipFacet", diamondAddress);
  const operationFacet: OperationFacet = await ethers.getContractAt("OperationFacet", diamondAddress);

  const eRC1155HolderFacet: ERC1155HolderFacet = await ContractERC1155HolderFacet();
  let selectors1 = getSelectors(eRC1155HolderFacet);
  let tx1 = await diamondCutFacet.diamondCut(
    [
      {
        facetAddress: eRC1155HolderFacet.address,
        action: FacetCutAction.Add,
        functionSelectors: selectors1,
      },
    ],
    ethers.constants.AddressZero,
    "0x",
    { gasLimit: 800000 }
  );
  let receipt1 = await tx1.wait();
  if (!receipt1.status) {
    throw Error(`Diamond upgrade failed: ${tx1.hash}`);
  }
  // const marketContract = await ethers.getContractAt(
  //     "HuukMarketFacet",
  //     diamondAddress
  // );
  //
  const eRC721HolderFacet: ERC721HolderFacet = await ContractERC721HolderFacet();
  selectors1 = getSelectors(eRC721HolderFacet);
  tx1 = await diamondCutFacet.diamondCut(
    [
      {
        facetAddress: eRC721HolderFacet.address,
        action: FacetCutAction.Add,
        functionSelectors: selectors1,
      },
    ],
    ethers.constants.AddressZero,
    "0x",
    { gasLimit: 800000 }
  );
  receipt1 = await tx1.wait();
  if (!receipt1.status) {
    throw Error(`Diamond upgrade failed: ${tx1.hash}`);
  }

  const huukMarketFacet: HuukMarketFacet = await ContractMarket();
  const selectors = getSelectors(huukMarketFacet);
  const tx = await diamondCutFacet.diamondCut(
    [
      {
        facetAddress: huukMarketFacet.address,
        action: FacetCutAction.Add,
        functionSelectors: selectors,
      },
    ],
    ethers.constants.AddressZero,
    "0x",
    { gasLimit: 800000 }
  );
  const receipt = await tx.wait();
  if (!receipt.status) {
    throw Error(`Diamond upgrade failed: ${tx.hash}`);
  }
  const marketContract = await ethers.getContractAt("HuukMarketFacet", diamondAddress);

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
    name: "HuukMarket_name",
    version: "Market_version_1.0",
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
    diamondLoupeFacet,
    ownershipFacet,
    operationFacet,
  };
};
