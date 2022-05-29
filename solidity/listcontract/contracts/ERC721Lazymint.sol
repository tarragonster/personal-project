// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";

contract Erc721Simple is
    Initializable,
    ERC721Upgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    using CountersUpgradeable for CountersUpgradeable.Counter;

    CountersUpgradeable.Counter private _tokenId;
    string private _baseTokenURI;

    function initialize(
        string memory name_,
        string memory symbol_,
        string memory baseURI_
    ) public initializer {
        __Erc721Simple_init(name_, symbol_, baseURI_);
    }

    function __Erc721Simple_init(
        string memory name_,
        string memory symbol_,
        string memory baseTokenURI_
    ) internal onlyInitializing {
        __ERC721_init_unchained(name_, symbol_);
        __Erc721Simple_init_unchained(baseTokenURI_);
    }

    function __Erc721Simple_init_unchained(string memory baseTokenURI_)
        internal
        onlyInitializing
    {
        _baseTokenURI = baseTokenURI_;
    }

    function create() external {
        uint256 tokenId = _tokenId.current();
        _mint(_msgSender(), tokenId);
        _tokenId.increment();
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata baseTokenURI_) external onlyOwner {
        _baseTokenURI = baseTokenURI_;
    }

    function supportsInterface(bytes4 _interfaceId)
        public
        view
        virtual
        override
        returns (bool)
    {
        return super.supportsInterface(_interfaceId);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {
        // Do something here.
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[45] private __gap;
}

// library https://medium.com/coinmonks/all-you-should-know-about-libraries-in-solidity-dd8bc953eae7
// memory and calldata https://ethereum.stackexchange.com/questions/74442/when-should-i-use-calldata-and-when-should-i-use-memory
// "using for" In solidity using X for Y directive means, library function of X is attached with type Y.
// “One condition which should be taken care is, library functions will receive the object they are called on as their first parameter”
