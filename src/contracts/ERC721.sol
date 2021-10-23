// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

  /*
    mint function
    1) nft to point to an address
    2) keep track of token ids
    3) keep track of token owner addresses to token ids
    4) keep track of how many tokens an owner address has
    5) create event that emits a transfer log
  */ 

contract ERC721 {

  // event creates logs
  event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed tokenId
  );

  mapping(uint256 => address) private _tokenOwner;
  mapping(address => uint256) private _ownedTokensCount;

  function _exists(uint256 tokenId) internal view returns(bool) {
    return _tokenOwner[tokenId] != address(0);
  }

  function balanceOf(address _owner) external view returns (uint256) {
    require(_owner != address(0), 'Can not be address 0');
    return _ownedTokensCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    address owner = _tokenOwner[_tokenId];
    require(owner != address(0), 'Can not be address 0');
    return _tokenOwner[_tokenId];
  }

  function _mint(address to, uint256 tokenId) internal virtual {
    // address is not address 0
    require(to != address(0), "ERC721: minting to zero address");

    // token has not been minted before
    require(!_exists(tokenId), "ERC721: Token minted before");

    _tokenOwner[tokenId] = to;
    _ownedTokensCount[to] += 1;
    emit Transfer(address(0), to, tokenId);
  }
}