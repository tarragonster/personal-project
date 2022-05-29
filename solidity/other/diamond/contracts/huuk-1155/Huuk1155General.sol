// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";

/**
 * @dev {ERC1155} token, including:
 *
 *  - ability for holders to burn (destroy) their tokens
 *  - a minter role that allows for token minting (creation)
 *  - a pauser role that allows to stop all token transfers
 *
 * This contract uses {AccessControl} to lock permissioned functions using the
 * different roles - head to its documentation for details.
 *
 * The account that deploys the contract will be granted the minter and pauser
 * roles, as well as the default admin role, which will let it grant both minter
 * and pauser roles to other accounts.
 *
 * _Deprecated in favor of https://wizard.openzeppelin.com/[Contracts Wizard]._
 */
contract Huuk1155General is
    Initializable,
    ContextUpgradeable,
    AccessControlEnumerableUpgradeable,
    ERC1155PausableUpgradeable,
    EIP712Upgradeable,
    UUPSUpgradeable
{
    using CountersUpgradeable for CountersUpgradeable.Counter;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant TOKEN_INFO_TYPE_HASH =
        keccak256(
            "TokenInfo(address owner,uint256 maxSupply,uint256 initialSupply,uint256 royaltyFee,string uri,bytes data,uint256 nonce)"
        );

    event Create(
        address indexed _creator,
        uint256 indexed _id,
        uint256 indexed _royaltyFee,
        uint256 _maxSupply,
        uint256 _initSupply
    );

    address proxyRegistryAddress;

    CountersUpgradeable.Counter private _tokenIdTracker;

    mapping(uint256 => address) public creators;
    mapping(uint256 => uint256) public royaltyFees;
    mapping(uint256 => uint256) public tokenSupplys;
    mapping(uint256 => uint256) public tokenMaxSupplys;
    mapping(uint256 => string) public tokenURIs;

    mapping(uint256 => bool) public executed;

    function initialize(
        string memory name_,
        string memory version_,
        string memory uri_
    ) public virtual initializer {
        __Huuk1155General_init(name_, version_, uri_);
    }

    /**
     * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE`, and `PAUSER_ROLE` to the account that
     * deploys the contract.
     */
    function __Huuk1155General_init(
        string memory name_,
        string memory version_,
        string memory uri_
    ) internal onlyInitializing {
        __ERC1155_init_unchained(uri_);
        __Pausable_init_unchained();
        __EIP712_init(name_, version_);
        __Huuk1155General_init_unchained();
    }

    function __Huuk1155General_init_unchained() internal onlyInitializing {
        _tokenIdTracker.increment();
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());
    }

    /**
     * @dev Returns the total quantity for a token ID
     * @param _id uint256 ID of the token to query
     * @return amount of token in existence
     */
    function totalSupply(uint256 _id) public view returns (uint256) {
        return tokenSupplys[_id];
    }

    /**
     * @dev Returns the max quantity for a token ID
     * @param _id uint256 ID of the token to query
     * @return amount of token in existence
     */
    function maxSupply(uint256 _id) public view returns (uint256) {
        return tokenMaxSupplys[_id];
    }

    function getCreator(uint256 _id) public view returns (address) {
        return creators[_id];
    }

    function getRoyaltyFee(uint256 _id) public view returns (uint256) {
        return royaltyFees[_id];
    }

    function getCurrentTokenID() public view returns (uint256) {
        return _tokenIdTracker.current();
    }

    function _exists(uint256 _id) internal view returns (bool) {
        return creators[_id] != address(0);
    }

    function uri(uint256 _id) public view override returns (string memory) {
        require(
            _exists(_id),
            "Huuk1155General: URI query for nonexistent token"
        );
        string memory baseURI = ERC1155Upgradeable.uri(_id);
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenURIs[_id]))
                : "";
    }

    modifier adminGuard() {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "Huuk1155General: must have admin role"
        );
        _;
    }

    modifier minterGuard() {
        require(
            hasRole(MINTER_ROLE, _msgSender()),
            "Huuk1155General: must have minter role"
        );
        _;
    }

    modifier pauserGuard() {
        require(
            hasRole(PAUSER_ROLE, _msgSender()),
            "Huuk1155General: must have pauser role"
        );
        _;
    }

    function create(
        uint256 _maxSupply,
        uint256 _initialSupply,
        uint256 _royaltyFee,
        string memory _uri,
        bytes memory _data
    ) public returns (uint256 tokenId) {
        require(
            _initialSupply <= _maxSupply,
            "Huuk1155General: initial supply cannot be more than max supply"
        );
        require(
            0 <= _royaltyFee && _royaltyFee <= 10000,
            "Huuk1155General: invalid-royalty-fee"
        );
        uint256 _id = _tokenIdTracker.current();
        _tokenIdTracker.increment();
        creators[_id] = _msgSender();
        royaltyFees[_id] = _royaltyFee;
        tokenURIs[_id] = _uri;

        if (_initialSupply != 0)
            _mint(_msgSender(), _id, _initialSupply, _data);
        tokenSupplys[_id] = _initialSupply;
        tokenMaxSupplys[_id] = _maxSupply;
        emit Create(_msgSender(), _id, _royaltyFee, _maxSupply, _initialSupply);
        return _id;
    }

    function mint(
        address _to,
        uint256 _id,
        uint256 _quantity,
        bytes memory _data
    ) public {
        uint256 tokenId = _id;
        require(
            creators[tokenId] == _msgSender(),
            "Huuk1155General: only-creator-can-mint"
        );
        require(
            tokenSupplys[tokenId] < tokenMaxSupplys[tokenId],
            "Huuk1155General: max supply reached"
        );
        _mint(_to, _id, _quantity, _data);
        tokenSupplys[_id] += _quantity;
    }

    /**
     * Set proxyRegistryAddress
     */
    function setProxyAddress(address _proxyRegistryAddress)
        public
        adminGuard
        returns (bool)
    {
        proxyRegistryAddress = _proxyRegistryAddress;
        return true;
    }

    /**
     * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
     */
    function isApprovedForAll(address _owner, address _operator)
        public
        view
        override
        returns (bool isOperator)
    {
        if (proxyRegistryAddress != address(0)) {
            if (proxyRegistryAddress == _operator) {
                return true;
            }
        }
        return ERC1155Upgradeable.isApprovedForAll(_owner, _operator);
    }

    function create(
        address _owner,
        uint256 _maxSupply,
        uint256 _initialSupply,
        uint256 _royaltyFee,
        string memory _uri,
        bytes memory _data,
        uint256 _nonce,
        bytes memory _signature
    ) public returns (uint256 tokenId) {
        require(!executed[_nonce], "Huuk1155General: duplicated nonce");
        executed[_nonce] = true;
        require(
            _initialSupply <= _maxSupply,
            "Huuk1155General: initial supply cannot be more than max supply"
        );
        require(
            0 <= _royaltyFee && _royaltyFee <= 10000,
            "Huuk1155General: invalid-royalty-fee"
        );

        require(
            _recover(
                _owner,
                _maxSupply,
                _initialSupply,
                _royaltyFee,
                _uri,
                _data,
                _nonce,
                _signature
            ) == _owner,
            "Huuk1155General: signer and owner mismatched"
        );

        uint256 _id = _tokenIdTracker.current();
        _tokenIdTracker.increment();
        creators[_id] = _owner;
        royaltyFees[_id] = _royaltyFee;
        tokenURIs[_id] = _uri;

        if (_initialSupply != 0) _mint(_owner, _id, _initialSupply, _data);
        tokenSupplys[_id] = _initialSupply;
        tokenMaxSupplys[_id] = _maxSupply;
        emit Create(_owner, _id, _royaltyFee, _maxSupply, _initialSupply);
        return _id;
    }

    function _recover(
        address _owner,
        uint256 _maxSupply,
        uint256 _initialSupply,
        uint256 _royaltyFee,
        string memory _uri,
        bytes memory _data,
        uint256 _nonce,
        bytes memory _signature
    ) internal view returns (address) {
        bytes32 ethTypedDataHash = _hashTypedDataV4(
            _getTokenInfoHash(
                _owner,
                _maxSupply,
                _initialSupply,
                _royaltyFee,
                _uri,
                _data,
                _nonce
            )
        );
        address signer = ECDSAUpgradeable.recover(ethTypedDataHash, _signature);

        return signer;
    }

    function recover(
        address _owner,
        uint256 _maxSupply,
        uint256 _initialSupply,
        uint256 _royaltyFee,
        string memory _uri,
        bytes memory _data,
        uint256 _nonce,
        bytes memory _signature
    ) public view returns (address signer) {
        signer = _recover(
            _owner,
            _maxSupply,
            _initialSupply,
            _royaltyFee,
            _uri,
            _data,
            _nonce,
            _signature
        );
    }

    function _getTokenInfoHash(
        address _owner,
        uint256 _maxSupply,
        uint256 _initialSupply,
        uint256 _royaltyFee,
        string memory _uri,
        bytes memory _data,
        uint256 _nonce
    ) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    TOKEN_INFO_TYPE_HASH,
                    _owner,
                    _maxSupply,
                    _initialSupply,
                    _royaltyFee,
                    keccak256(bytes(_uri)),
                    keccak256(_data),
                    _nonce
                )
            );
    }

    function getChainID() external view returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }

    function setBaseURI(string memory newuri) external adminGuard {
        _setURI(newuri);
    }

    /**
     * @dev Pauses all token transfers.
     *
     * See {ERC1155Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function pause() public virtual pauserGuard {
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     *
     * See {ERC1155Pausable} and {Pausable-_unpause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function unpause() public virtual pauserGuard {
        _unpause();
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControlEnumerableUpgradeable, ERC1155Upgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override(ERC1155PausableUpgradeable) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        adminGuard
    {
        // Do something here.
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}
