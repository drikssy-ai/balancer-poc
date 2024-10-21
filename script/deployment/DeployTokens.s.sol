// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "script/Base.s.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import { console } from "@forge-std/console.sol";

contract TestToken is ERC20 {
    uint8 private _decimals;

    constructor(string memory name, string memory symbol, uint8 newDecimals) ERC20(name, symbol) {
        _decimals = newDecimals;
    }

    function mint(address recipient, uint256 amount) external {
        _mint(recipient, amount);
    }

    function burnWithoutAllowance(address sender, uint256 amount) external {
        _burn(sender, amount);
    }

    function decimals() public view override returns (uint8) {
        return _decimals;
    }
}

contract DeployTokens is BaseScript {

    function run() public virtual initConfig broadcast {
        (address usdc, address meta) = _deployTokens();
        console.log("usdc deployed at address:", usdc);
        console.log("meta deployed at address:", meta);

        if (vaultAddress != address(0)) {
            TestToken(usdc).approve(vaultAddress, 10 ether);
            TestToken(meta).approve(vaultAddress, 10 ether);
            console.log("usdc approved for vault at address:", vaultAddress);
        }
    }

    function _deployTokens() internal returns (address usdc, address meta) {
        TestToken USDC = new TestToken("USDC TEST", "USDC TEST", 6);
        TestToken META = new TestToken("META TEST", "META TEST", 18);
        USDC.mint(broadcaster, 10 ether);
        META.mint(broadcaster, 10 ether);
        
        usdc = address(USDC);
        meta = address(META);
    }
}
