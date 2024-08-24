## Account abstraction 
It allows accounts to define custom authorization mechanisms, mutli-sig wallet, smart contract-based wallet.
It give the ability to create custom account types that can control how transactions are processed, validated, and executed, rather than relying solely on the traditional externally owned accounts (EOAs) or standard smart contracts.

### In EVM: 
IAccount: core functionality the defines core functionality that a custom account implement, validating and executing transactions. has `validateUserOp` and `executeUserOp`

PackedUserOperation: encapsulates the essential data required to perform a user operation

EntryPoint: central points, it orchestrates the flow of operations by calling the appropriate methods on the custom account



### In ZkSync:
In ZkSync, AA is deeply integrated with zk-rollup architecture, allows more system-level interaction using SystemContractsCaller, gas cost is generally low.

IAccount: logic of abstracted account, inherited by MinimalAccount contract, consist of `validateTransaction` and `executeTransaction`. This IAccount is from different repo than the above one [NOT SAME]

SystemContract: critical for managing underlying zksync system, contains system-level transactions
NonceHolder: nonce are used to ensure that each transaction is unique and can be only executed once

MessageHashUtils: compute and verify message hashed, used to check is if data has not been tampered with during its transit or execution

ECDSA: verify signature, ensures rightful account owner can authorize transactions

#### Run locally:
```
git clone https://github.com/naman1402/account-abstraction.git
cd account-abstraction
forge build
forge compile
```


#### References
https://medium.com/infinitism/erc-4337-account-abstraction-without-ethereum-protocol-changes-d75c9d94dc4a

https://eips.ethereum.org/EIPS/eip-4337
