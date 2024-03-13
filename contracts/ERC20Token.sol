// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Token is ERC20, Ownable {
    // transferFee fee
    uint256 public transferFee;
    // burn fee
    uint256 public burnFee;
    // tax Receiver address
    address public taxReceiver;

    event setBurnFee(uint indexed oldBurnFee, uint indexed newBurnFee);
    event setTransferFee(
        uint indexed oldTransferFee,
        uint indexed newTransferFee
    );
    event setTaxReceiverAddress(
        address indexed oldAddress,
        address indexed newAddress
    );

    constructor(
        address initialOwner,
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        uint256 _transferFee,
        uint256 _burnFee,
        address _taxReceiver
    ) ERC20(_name, _symbol) Ownable(initialOwner) {
        _mint(initialOwner, _totalSupply * 10 ** decimals());

        transferFee = _transferFee;
        burnFee = _burnFee;
        taxReceiver = _taxReceiver;
    }

    // method to set tax receiver address
    function updateTaxReceiverAddress(
        address _newTaxReceiver
    ) public onlyOwner {
        emit setTaxReceiverAddress(taxReceiver, _newTaxReceiver);
        taxReceiver = _newTaxReceiver;
    }

    // method to update burn fee
    function updateBurnTax(uint256 _newBurnFee) public onlyOwner {
        emit setBurnFee(burnFee, _newBurnFee);
        burnFee = _newBurnFee;
    }

    // method to update sell fee
    function updateTransferTax(uint256 _newTax) public onlyOwner {
        emit setTransferFee(transferFee, _newTax);
        transferFee = _newTax;
    }

    // The following functions are overrides required by Solidity.
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20) {
        if ((from != owner()) && (to != owner())) {
            uint256 _burnAmount = (value * burnFee) / 1000;
            uint256 _transferTaxAmount = (value * transferFee) / 1000;

            super._update(from, taxReceiver, _transferTaxAmount);
            super._update(from, address(0), _burnAmount);
            super._update(
                from,
                to,
                (value - (_transferTaxAmount + _burnAmount))
            );
        } else {
            super._update(from, to, value);
        }
    }
}
