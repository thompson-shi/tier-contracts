// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

import "erc-payable-token/contracts/token/ERC1363/ERC1363.sol";
import "eth-token-recover/contracts/TokenRecover.sol";


contract TierToken is ERC1363, ERC20Capped, ERC20Burnable, Pausable, AccessControl, TokenRecover {

    string  private constant NAME = "Tier Monsters Governance Token";
    string  private constant SYMBOL = "TIER";
    uint256 private constant CAP = 10000000000 * (10**18);
    uint256 private constant INITIAL_SUPPLY = 10000000000 * (10**18);

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor() 
        ERC20(NAME, SYMBOL)
        ERC20Capped(CAP)
    {
        require(CAP == INITIAL_SUPPLY, "CAP should be equal to init supply");

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);

        _mint(msg.sender, INITIAL_SUPPLY);    
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function _mint(address to, uint256 amount) internal override(ERC20, ERC20Capped) onlyRole(MINTER_ROLE)
    {
        ERC20._mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1363, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    } 
      
}