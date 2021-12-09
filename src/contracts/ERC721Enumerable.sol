// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';


contract ERC721Enumerable is ERC721, IERC721Enumerable {

  constructor() {
    _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));
  }

  uint256[] private _allTokens;

  // store index for a given token id
  mapping(uint256 => uint256) private _allTokensIndex;

  mapping(address => uint256[]) private _ownedTokens;

  // store index that a tokenid is being add to a list of tokens a given user owns
  mapping(uint256 => uint256) private _ownedTokensIndex;

  function totalSupply() public view override returns (uint256) {
    return _allTokens.length;
  }


  function tokenByIndex(uint256 _index) public view override returns (uint256) {
    require(_index < totalSupply(), 'global index is out of bounds');
    return _allTokens[_index];
  }

  function tokenOfOwnerByIndex(address _owner, uint256 _index) public view override returns (uint256) {
    require(_index < balanceOf(_owner), 'owner index out of bounds');
    return _ownedTokens[_owner][_index];
  }

  function _mint(address to, uint256 tokenId) internal override(ERC721) {
    super._mint(to, tokenId);
    _addTokensToAllTokenEnumeration(tokenId);
    _addTokensToOwnerEnumeration(to, tokenId);
  }

  function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
    _allTokensIndex[tokenId] = _allTokens.length;
    _allTokens.push(tokenId);
  }

  function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
    _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
    _ownedTokens[to].push(tokenId);
  }
}