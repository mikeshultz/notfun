// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/utils/Strings.sol";
import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/access/Ownable.sol";
import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/token/ERC721/ERC721.sol";

contract NotFun is Ownable, ERC721 {
    using Strings for uint256;

    string public baseURI;

    constructor(
        string memory metadataBaseURI
    ) ERC721("Not Fun Tokens by Mike", "NOTFUN")
    {
        baseURI = metadataBaseURI;
    }

    /**
     * Used internally by OZ's ERC721
     */
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /**
     * Return the metadata URI for the contract-level metadata
     */
    function contractURI() public view returns (string memory) {
        string memory uri = _baseURI();
        return bytes(uri).length > 0 ? string(abi.encodePacked(uri, "contract.json")) : "";
    }

    /**
     * Return the metadata URI for a specific token ID
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory uri = _baseURI();
        return bytes(uri).length > 0 ? string(abi.encodePacked(uri, tokenId.toString(), ".json")) : "";
    }

    /**
     * Update the baseURI for metadata
     */
    function setBaseURI(string memory metadataBaseURI) public onlyOwner {
        baseURI = metadataBaseURI;
    }

    /**
     * safeTransferFrom updated to lazy-mint if a token doesn't exist
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        if (owner() == _msgSender() && !_exists(tokenId)) {
            _mint(to, tokenId);
        } else {
            require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
            _safeTransfer(from, to, tokenId, _data);
        }
    }
}
