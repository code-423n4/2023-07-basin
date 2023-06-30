### Table of Contents

- [Basin Contest Details](#basin-contest-details)
- [Basin Introduction](#basin-introduction)
    - [Code Walkthrough](#code-walkthrough)
    - [Architecture Diagram](#architecture-diagram)
    - [Documentation](#documentation)
    - [Motivation](#motivation)
    - [Past Audits](#past-audits)
- [C4 Contest](#c4-contest)
    - [Scope](#scope)
    - [Setup](#setup)
    - [Tests](#tests)
    - [Scoping Details](#scoping-details)
- [Contact Us](#contact-us)

<img src="https://github.com/BeanstalkFarms/Beanstalk-Brand-Assets/blob/main/basin/basin(green)-512x512.png" alt="Basin logo" align="right" width="120" />

# Basin Contest Details
- Total Prize Pool: $40,000 USDC 
  - HM awards: $27,637.50 USDC 
  - Analysis awards: $1,675 USDC 
  - QA awards: $837.50 USDC 
  - Bot Race awards: $2,512.50 USDC 
  - Gas awards: $837.50 USDC 
  - Judge awards: $3,600 USDC 
  - Lookout awards: $2,400 USDC 
  - Scout awards: $500 USDC 
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2023-07-beanstalk/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts July 03, 2023 20:00 UTC 
- Ends July 10, 2023 20:00 UTC 

# Introduction to Basin

Website: https://basin.exchange

Welcome, C4 Wardens! Basin is the next step in the evolution of EVM-native DEXs.

Exchanging is a core piece of economic activity. However, currect decentralized exchange (DEX) architectures are not composable, such that adding an exchange function or oracle to them is difficult. The nature of open source software is that each problem should only need to be solved once in a given execution environment. Non-composable DEX architectures prevent this. We propose an EVM-native DEX architecture which (1) allows for composing arbitrary exchange functions, oracles and exchange implementations for ERC-20 standard
tokens and (2) includes a registry to verify exchange implementations.

Well designed open source protocols enable anyone to (1) compose existing components together, (2) develop new components when existing ones fail to meet the needs of users or are cost-inefficient and (3) verify the proper use of existing components in a simple fashion. Basin allows for anyone to compose new and existing (1) *Well Functions* (i.e. exchange functions), (2) *Pumps* (i.e., network native oracles) and (3) *Well Implementations* (i.e., exchange implementations) to create a *Well* (i.e., a customized liquidity pool). *Aquifers* (i.e., Well registries) store a mapping from Well addresses to Well Implementations to enable verification of a Well Implementation given a Well address.

**The whitepapers for Basin and Multi Flow Pump are by far the best resources for learning about how the DEX architecture is intended the work, the motivations for building it, detailed overviews of the math that is implemented, etc. We highly recommend reading these drafts as you begin your review:**
* [Basin Whitepaper](https://basin.exchange/basin.pdf)
* [Multi Flow Pump Whitepaper](https://basin.exchange/multi-flow-pump.pdf)

## Code Walkthrough

Check out the following code walkthrough of Basin, starting at 29:00: https://youtu.be/SEM2AJwTvfg?t=1740

## Architecture Diagram

Architecture diagram of Basin: https://www.figma.com/file/u3IUVxVF8IOfYVIUEYc3sm/Technical-Graphic%3A-Wells-System-Architecture?node-id=0%3A1&t=fjHB8lY8WsrwyhZj-0

## Documentation

A draft of the Basin whitepaper is available [here](https://basin.exchange/basin.pdf). A draft of the Multi Flow Pump whitepaper is available [here](https://basin.exchange/multi-flow-pump.pdf).

A [{Well}](/src/Well.sol) is a constant function AMM that allows the provisioning of liquidity into a single pooled on-chain liquidity position.

Each Well is defined by its Tokens, Well function, and Pump.
- The **Tokens** define the set of ERC-20 tokens that can be exchanged in the Well.
- The **Well function** defines an invariant relationship between the Well's reserves and the supply of LP tokens. See [{IWellFunction}](/src//interfaces/IWellFunction.sol).
- **Pumps** are an on-chain oracles that are updated upon each interaction with the Well. See [{IPump}](/src/interfaces/IPump.sol).

A Well's tokens, Well function, and Pump are stored as immutable variables during Well construction to prevent unnecessary SLOAD calls during operation.

Wells support swapping, adding liquidity, and removing liquidity in balanced or imbalanced proportions.

Wells maintain two components of state:
- a balance of tokens received through Well operations ("reserves")
- an ERC-20 LP token representing pro-rata ownership of the reserves

Well functions and Pumps can independently choose to be stateful or stateless.

Including a Pump is optional.

Each Well implements ERC-20, ERC-2612 and the [{IWell}](/src/interfaces/IWell.sol) interface.

## Motivation

Allowing composability of the pricing function and oracle at the Well level is a deliberate design decision with significant implications. 

In particular, a standard AMM interface invoking composable components allows for developers to iterate upon the underlying pricing functions and oracles, which greatly impacts gas and capital efficiency. 

However, this architecture shifts much of the attack surface area to the Well's components. Users of Wells should be aware that anyone can deploy a Well with malicious components, and that new Wells SHOULD NOT be trusted without careful review. This understanding is particularly important in the DeFi context in which Well data may be consumed via on-chain registries or off-chain indexing systems.

The Wells architecture aims to outline a simple interface for composable AMMs and leave the process of evaluating a given Well's trustworthiness as the responsibility of the user. To this end, future work may focus on development of on-chain Well registries and factories which create or highlight Wells composed of known components.

An example factory implementation is provided in [{Aquifer}](/src/Auquifer.sol) without any opinion regarding the trustworthiness of Well functions and the Pumps using it. Wells are not required to be deployed via this mechanism.

## Past Audits

These audits reports may provide insight on known issues and acknowledged findings in Basin:

* [Cyfrin Basin Audit](https://basin.exchange/cyfrin-basin-audit.pdf)
* [Halborn Basin Audit](https://basin.exchange/halborn-basin-audit.pdf)

# C4 Contest

## Scope

*List all files in scope in the table below (along with hyperlinks) -- and feel free to add notes here to emphasize areas of focus.*

All code for Basin can be found in the [src/](src/) folder. Each contract has documentation at the top of the respective file.

**In Scope**

| Contract                                                                       | SLOC       | Purpose                                                                              | Libraries used                                                               |  
|:-------------------------------------------------------------------------------|:-----------|:-------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------|
| [functions/ConstantProduct2.sol](src/functions/ConstantProduct2.sol)           | 29         | Gas efficient Constant Product pricing function for Wells with 2 tokens.             | `LibMath`                                                                    |
| [functions/ProportionalLPToken2.sol](src/functions/ProportionalLPToken2.sol)   | 9          | Defines a proportional relationship between the supply of LP token and the amount of each underlying token for a two-token Well.  |                                 |
| [libraries/LibBytes.sol](src/libraries/LibBytes.sol)                           | 73         | Contains byte operations used during storage reads & writes.                                                                      |                                 |
| [libraries/LibBytes16.sol](src/libraries/LibBytes16.sol)                       | 58         | Contains byte operations used during storage reads & writes for Pumps.                                                            |                                 |
| [libraries/LibContractInfo.sol](src/libraries/LibContractInfo.sol)             | 29         | Contains logic to call functions that return information about a given contract.                                                  |                                 |
| [libraries/LibLastReserveBytes.sol](src/libraries/LibLastReserveBytes.sol)     | 88         | Contains byte operations used during storage reads & writes for Pumps.                                                            |                                 |
| [libraries/LibWellConstructor.sol](src/libraries/LibWellConstructor.sol)       | 42         | Contains logic for constructing a Well.                                                                                           |                                 |
| [pumps/MultiFlowPump.sol](src/pumps/MultiFlowPump.sol)                         | 222        | Stores a geometric EMA and cumulative geometric SMA for each reserve. (See Multi Flow whitepaper) | `ABDKMathQuad`, `LibBytes16`, `LibLastReserveBytes`, `SafeCast` |
| [Aquifer.sol](src/Aquifer.sol)                                                 | 53         | A permissionless Well registry and factory.                                                       | `LibClone`, `SafeCast`, `ReentrancyGuard`                       |
| [Well.sol](src/Well.sol)                                                       | 368        | A constant function AMM allowing the provisioning of liquidity into a single pooled on-chain liquidity position. |  `LibBytes`, `ClonePlus`, `SafeCast`, `SafeERC20`, `ReentrancyGuardUpgradeable`, `ERC20PermitUpgradeable`  |

**Out of Scope**

* functions/ConstantProduct.sol
* functions/ProportionalLPToken.sol
* libraries/ABDKMathQuad.sol
* libraries/LibClone.sol
* libraries/LibMath.sol
* utils/

## Setup

This repository uses Foundry as a smart contract development toolchain.

See the [Foundry Docs](https://book.getfoundry.sh/) for more info on installation and usage.

```bash
foundryup
forge install
forge build
```

## Tests

Prior to running tests, you should set up your environment. At present this repository contains fork tests against ETH mainnet; your environment will need an `MAINNET_RPC_URL` key to run these tests. This is used in `IntegrationTestGasComparisons.sol`.


Additionally, the `--ffi` cheatcode is used to verify certain actions. Due to the arbitrary code execution nature of `--ffi`, it is advised to review the executed code prior to running. 

To setup the python enviornment: 
`python3 -m venv env`
`source env/bin/activate`
`python3 -m pip install -r requirements.txt`

The test using `-ffi` are:
  - `testFuzz_powu()` 
  - `testSim_capReserve_decrease()`
  - `testSim_capReserve_increase()` 
The code being executed are: 
  - `test/pumps/simulate.py`
  - `test/differential/powu.py`
  
The main command to run tests is:

`forge test -vv --ffi`

## Scoping Details

```
- If you have a public code repo, please share it here:  https://github.com/BeanstalkFarms/Basin (made private during the C4 contest)
- How many contracts are in scope?:   10
- Total SLoC for these contracts?:  971
- How many external imports are there?: 5 
- How many separate interfaces and struct definitions are there for the contracts within scope?:  5 interfaces, 1 struct
- Does most of your code generally use composition or inheritance?:   Inheritance
- How many external calls?:   0
- What is the overall line coverage percentage provided by your tests?:  95
- Is there a need to understand a separate part of the codebase / get context in order to audit this part of the protocol?:   False
- Please describe required context:   n/a
- Does it use an oracle?:  True; on-chain oracles-  MultiFlowPump.sol is an implementation of Pumps, the oracle framework of Basin — Basin itself does not "use" an oracle per se
- Does the token conform to the ERC20 standard?: Wells issue LP tokens that conform to the ERC-20 standard 
- Are there any novel or unique curve logic or mathematical models?: All formulas are documented in detail in the various whitepapers linked to from the contest
- Does it use a timelock function?:  No
- Is it an NFT?: No
- Does it have an AMM?:   True (Basin is an AMM!)
- Is it a fork of a popular project?:   False
- Does it use rollups?:   False
- Is it multi-chain?:  False
- Does it use a side-chain?: False 
```

# Contact Us

If you have questions, please contact us! Please use the Warden channel in the C4 Discord if it isn't sensitive. Otherwise:

**Publius (Dev)**
* Discord: @publiuss

**Brean (Dev)**
* Discord: @brean

If you are having trouble getting in touch with Publius and/or Brean, please message **Guy**:
* Discord: @hellofromguy
* Telegram: @hellofromguy
