// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';


contract ERC721Enumerable is ERC721 {

  uint256[] private _allTokens;

  // store index for a given token id
  mapping(uint256 => uint256) private _allTokensIndex;
  mapping(address => uint256[]) private _ownedTokens;
  mapping(uint256 => uint256) private _ownedTokensIndex;

  function totalSupply() public view returns (uint256) {
    return _allTokens.length;
  }


  // function tokenByIndex(uint256 _index) external view returns (uint256);

  // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);

  function _mint(address to, uint256 tokenId) internal override(ERC721) {
    super._mint(to, tokenId);
    _addTokensToAllTokenEnumeration(tokenId);
  }

  function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
    _allTokensIndex[tokenId] = _allTokens.length;
    _allTokens.push(tokenId);
  }
}