// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract TokenSwap {
    address public token1;
    address public token2;
    uint256 public reserve1;
    uint256 public reserve2;

    event LiquidityAdded(address indexed provider, uint256 amount1, uint256 amount2);
    event TokensSwapped(address indexed swapper, address inputToken, uint256 inputAmount, uint256 outputAmount);
    
    constructor(address _token1, address _token2) {
        token1 = _token1;
        token2 = _token2;
    }

    function addLiquidity(uint256 _amount1, uint256 _amount2) external {
        require(_amount1 > 0 && _amount2 > 0, "Invalid amount");

        IERC20(token1).transferFrom(msg.sender, address(this), _amount1);
        IERC20(token2).transferFrom(msg.sender, address(this), _amount2);

        reserve1 += _amount1;
        reserve2 += _amount2;

        emit LiquidityAdded(msg.sender, _amount1, _amount2);
    }

    function getSwapAmount(uint256 _inputAmount, bool _isToken1) public view returns (uint256) {
        require(_inputAmount > 0, "Invalid input amount");

        uint256 inputReserve = _isToken1 ? reserve1 : reserve2;
        uint256 outputReserve = _isToken1 ? reserve2 : reserve1;

        uint256 outputAmount = (_inputAmount * outputReserve) / (inputReserve + _inputAmount);
        return outputAmount;
    }

    function swap(uint256 _inputAmount, bool _isToken1) external {
        require(_inputAmount > 0, "Invalid input amount");

        uint256 outputAmount = getSwapAmount(_inputAmount, _isToken1);

        if (_isToken1) {
            IERC20(token1).transferFrom(msg.sender, address(this), _inputAmount);
            IERC20(token2).transfer(msg.sender, outputAmount);
            reserve1 += _inputAmount;
            reserve2 -= outputAmount;
        } else {
            IERC20(token2).transferFrom(msg.sender, address(this), _inputAmount);
            IERC20(token1).transfer(msg.sender, outputAmount);
            reserve2 += _inputAmount;
            reserve1 -= outputAmount;
        }

        emit TokensSwapped(msg.sender, _isToken1 ? token1 : token2, _inputAmount, outputAmount);
    }

    function getReserves() external view returns (uint256, uint256) {
        return (reserve1, reserve2);
    }
}

