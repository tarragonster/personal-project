# Checklist
- [x] Deploy new contract
- [x] Withdraw coins 
- [x] Transfer NFTs
- [x] Transfer Data
  - [x] uint256 public totalOrders;
  - [x] uint256 public totalBids;
  - [x] mapping(uint256 => bool) public executed; // not migrate
  - [x] mapping(uint256 => Order) public orders;
  - [x] mapping(bytes32 => uint256) private orderID;
  - [ ] mapping(uint256 => Bid) public bids; // not migrate due to incompatibility
  - [ ] mapping(address => mapping(bytes32 => uint256)) lastBuyPriceInUSDT; // not migrate ?

  - [x] address public huuk;
  - [x] address public referralContract;
  - [x] address public huukExchangeContract;
  - [x] address public profitSender;

  - [x] uint256 public xUser; // 
  - [x] uint256 public xCreator;
  - [x] uint256 public yRefRate; // 
  - [x] uint256 public zProfitToCreator; // 
  - [x] uint256 public discountForBuyer;
  - [x] uint256 public discountForHuuk; // 
  - [x] mapping(address => bool) public paymentMethod;
  - [x] mapping(address => bool) public isHuukNFTs;
  - [x] mapping(address => bool) public isOperator; // not migrate
  - [x] uint256 public xPremium;
  - [x] mapping(address => bool) public isHuukNFTPremiums;
