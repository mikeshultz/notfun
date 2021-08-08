# Not Fun Tokens (NFTs)

Lazy minting NFT contract based on OpenZeppelin's ERC721.  Added features include:

- ownable (deployer is owner)
- owner can change metadata base URI
- minting is lazy and occurs when owner transfers an unminted token
- contract level metadata

## Development

### Install Deps

    pip install -r requirements.txt
    brownie pm install OpenZeppelin/openzeppelin-contracts@4.2.0

### Testing

    brownie test
