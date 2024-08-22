// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {EntryPoint} from "lib/account-abstraction/contracts/core/EntryPoint.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract Config is Script {
    error Config__InvalidChainId();

    struct NetworkConfig {
        address entryPoint;
        address account;
        address usdc;
    }

    uint256 constant POLYGON_AMOY_CHAIN_ID = 80002;
    uint256 constant ZK_SYNC_SEPOLIA_CHAIN_ID = 300;
    uint256 constant LOCAL_CHAIN_ID = 31337;
    address constant WALLET_ADDRESS = 0xc232baceb4f642b5acc96529c7Af7dE73d638C28;
    address constant ANVIL_DEFAULT_ACCOUNT = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    NetworkConfig public localNetworkConfig;
    mapping(uint256 chainId => NetworkConfig) public networkConfigs;

    constructor() {
        networkConfigs[POLYGON_AMOY_CHAIN_ID] = getPolygonAmoyConfig();
        networkConfigs[ZK_SYNC_SEPOLIA_CHAIN_ID] = getZKSyncConfig();
    }

    function getPolygonAmoyConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({entryPoint: 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789, account: WALLET_ADDRESS, usdc: 0x41E94Eb019C0762f9Bfcf9Fb1E58725BfB0e7582});
    }

    function getZKSyncConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({entryPoint: address(0), account: WALLET_ADDRESS, usdc: 0x1d17CBcF0D6D143135aE902365D2E5e2A16538D4});
    }

    function getOrCreateEthConfig() public returns (NetworkConfig memory) {
        if (localNetworkConfig.account != address(0)) {
            return localNetworkConfig;
        }

        // DEPLOY MOCK
        // https://github.com/Cyfrin/minimal-account-abstraction/blob/main/script/HelperConfig.s.sol#L115C9-L124C35
        console2.log("deploying mocks...");
        vm.startBroadcast(ANVIL_DEFAULT_ACCOUNT);
        EntryPoint entryPoint = new EntryPoint();
        ERC20Mock erc20mock = new ERC20Mock();
        vm.stopBroadcast();
        console2.log("mocks deployed!");

        localNetworkConfig = NetworkConfig({entryPoint: address(entryPoint), account: ANVIL_DEFAULT_ACCOUNT, usdc: address(erc20mock)});
        return localNetworkConfig;
    }

    function getConfigByChainId(uint256 chainId) public returns (NetworkConfig memory) {
        if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateEthConfig();
        } else if (networkConfigs[chainId].account != address(0)) {
            return networkConfigs[chainId];
        } else {
            revert Config__InvalidChainId();
        }
    }

    function getConfig() public returns (NetworkConfig memory) {
        return getConfigByChainId(block.chainid);
    }
}
