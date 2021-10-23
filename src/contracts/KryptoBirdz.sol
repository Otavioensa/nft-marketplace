// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {

  string[] public KryptoBirdz;

  mapping(string => bool) _kryptoBirdzExists;

  constructor() ERC721Connector('Kryptobird', 'KBIRDZ'){
  }

  function mint(string memory _kryptoBird) public {
    require(!_kryptoBirdzExists[_kryptoBird], "Error: Kryptobird already exists");
    KryptoBirdz.push(_kryptoBird);
    uint _id = KryptoBirdz.length -1;

    _mint(msg.sender, _id);
    _kryptoBirdzExists[_kryptoBird] = true;
  }
}