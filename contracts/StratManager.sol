// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/security/Pausable.sol';




contract StratManager is Ownable, Pausable {
    /**
     * @dev proVaults Contracts:
     * {keeper} - Address to manage a few lower risk features of the strat
     * {strategist} - Address of the strategy author/deployer where strategist fee will go.
     * {vault} - Address of the vault that controls the strategy's funds.
     * {unirouter} - Address of exchange to execute swaps.
     */
    address public keeper;
    address public strategist;
    address public unirouter;
    address public vault;
    address public proVaultsFeeRecipient;

    /**
     * @dev Initializes the base strategy.
     * @param _keeper address to use as alternative owner.
     * @param _strategist address where strategist fees go.
     * @param _unirouter router to use for swaps
     * @param _vault address of parent vault.
     * @param _proVaultsFeeRecipient address where to send proVaults's fees.
     */
    constructor(
        address _keeper,
        address _strategist,
        address _unirouter,
        address _vault,
        address _proVaultsFeeRecipient
    ) public {
        keeper = _keeper;
        strategist = _strategist;
        unirouter = _unirouter;
        vault = _vault;
        proVaultsFeeRecipient = _proVaultsFeeRecipient;
    }

    // checks that caller is either owner or keeper.
    modifier onlyManager() {
        require(msg.sender == owner() || msg.sender == keeper, "!manager");
        _;
    }

    /**
     * @dev Updates address of the strat keeper.
     * @param _keeper new keeper address.
     */
    function setKeeper(address _keeper) external onlyManager {
        keeper = _keeper;
    }

    /**
     * @dev Updates address where strategist fee earnings will go.
     * @param _strategist new strategist address.
     */
    function setStrategist(address _strategist) external {
        require(msg.sender == strategist, "!strategist");
        strategist = _strategist;
    }

    /**
     * @dev Updates router that will be used for swaps.
     * @param _unirouter new unirouter address.
     */
    function setUnirouter(address _unirouter) external onlyOwner {
        unirouter = _unirouter;
    }

    /**
     * @dev Updates parent vault.
     * @param _vault new vault address.
     */
    function setVault(address _vault) external onlyOwner {
        vault = _vault;
    }

    /**
     * @dev Updates proVaults fee recipient.
     * @param _proVaultsFeeRecipient new proVaults fee recipient address.
     */
    function setproVaultsFeeRecipient(address _proVaultsFeeRecipient) external onlyOwner {
        proVaultsFeeRecipient = _proVaultsFeeRecipient;
    }

    /**
     * @dev Function to synchronize balances before new user deposit.
     * Can be overridden in the strategy.
     */
    function beforeDeposit() external virtual {}
}
