// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import './ERC165.sol';
import './interfaces/IERC721.sol';

  /*
    mint function
    1) nft to point to an address
    2) keep track of token ids
    3) keep track of token owner addresses to token ids
    4) keep track of how many tokens an owner address has
    5) create event that emits a transfer log
  */ 

contract ERC721 is ERC165, IERC721 {
  mapping(uint256 => address) private _tokenOwner;
  mapping(address => uint256) private _ownedTokensCount;
  mapping(uint256 => address) private _tokenApprovals;

  constructor() {
    _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
  }

  function _exists(uint256 tokenId) internal view returns(bool) {
    return _tokenOwner[tokenId] != address(0);
  }

  function balanceOf(address _owner) public override view returns (uint256) {
    require(_owner != address(0), 'Can not be address 0');
    return _ownedTokensCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public override view returns (address) {
    address owner = _tokenOwner[_tokenId];
    require(owner != address(0), 'Can not be address 0');
    return _tokenOwner[_tokenId];
  }

  function _mint(address to, uint256 tokenId) internal virtual {
    // address is not address 0
    require(to != address(0), 'ERC721: minting to zero address');

    // token has not been minted before
    require(!_exists(tokenId), 'ERC721: Token minted before');

    _tokenOwner[tokenId] = to;
    _ownedTokensCount[to] += 1;
    emit Transfer(address(0), to, tokenId);
  }

  function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
    require(_to != address(0), 'ERC721: Transfer to zero address');
    require(ownerOf(_tokenId) == _from, 'Trying to transfer a token the address does not own');

    _ownedTokensCount[_from] -= 1;
    _ownedTokensCount[_to] += 1;

    _tokenOwner[_tokenId] = _to;

    emit Transfer(_from, _to, _tokenId); 
  }


  function transferFrom(address _from, address _to, uint256 _tokenId) override public {
    require(isApprovedOrOwner(msg.sender, _tokenId), 'Must have approval');
    _transferFrom(_from, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public {
    address owner = ownerOf(_tokenId);
    require(_to != owner, 'Error: Approval to current owner');
    require(msg.sender == owner, 'Error: Current caller is not the owner of the token');

    _tokenApprovals[_tokenId] = _to;

    emit Approval(owner, _to, _tokenId);
  }

  function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
    require(_exists(tokenId), 'Token does not exist');
    address owner = ownerOf(tokenId);
    return (spender == owner);
  }
}