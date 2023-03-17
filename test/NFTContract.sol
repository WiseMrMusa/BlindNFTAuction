// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
contract NFTContract is ERC721 , Ownable {
    constructor(string memory _NFTname , string memory _NFTsymbol) ERC721(_NFTname, _NFTsymbol) {}

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _mint(to, tokenId);
        // _safeMint(to, tokenId);
    }
}