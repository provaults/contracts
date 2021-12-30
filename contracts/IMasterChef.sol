// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';

interface IMasterChef {
    function userInfo(uint256 _pid, address _user) external view returns (uint256, uint256);
    function pendingReward(address _user, uint256 _pid) external view returns (uint256);
    function deposit(uint256 _amount, uint256 _pid) external;
    function withdraw(uint256 _amount, uint256 _pid) external;
    function emergencyWithdraw(uint256 _pid) external;
}