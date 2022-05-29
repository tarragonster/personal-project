// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract EIP721Demo is
    Initializable,
    EIP712Upgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    string private constant SIGNING_DOMAIN = "EIP721Demo";
    string private constant SIGNATURE_VERSION = "V1";
    struct Data {
        uint256 numA;
        uint256 numB;
        string textA;
        bytes signature;
    }

    function initialize() public initializer {
        __EIP721Demo_init();
    }

    function __EIP721Demo_init() internal onlyInitializing {
        __EIP712_init_unchained(SIGNING_DOMAIN, SIGNATURE_VERSION);
        __EIP721Demo_init_unchained();
    }

    function __EIP721Demo_init_unchained() internal onlyInitializing {}

    function getSignerAddress(Data calldata data)
        external
        view
        returns (address signer)
    {
        signer = _verify(data);
    }

    function _verify(Data calldata data)
        internal
        view
        returns (address signer)
    {
        bytes32 hashData = _hash(data);
        signer = ECDSAUpgradeable.recover(hashData, data.signature);
    }

    function _hash(Data calldata data) internal view returns (bytes32) {
        return
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        keccak256(
                            "Data(uint256 numA,uint256 numB,string textA)"
                        ),
                        data.numA,
                        data.numB,
                        keccak256(bytes(data.textA))
                    )
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
