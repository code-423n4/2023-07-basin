# Report


## Non Critical Issues


| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Expressions for constant values such as a call to keccak256(), should use immutable rather than constant | 1 |
| [NC-2](#NC-2) | Constants in comparisons should appear on the left side | 100 |
| [NC-3](#NC-3) |  `require()` / `revert()` statements should have descriptive reason strings | 20 |
| [NC-4](#NC-4) | Event is missing `indexed` fields | 7 |
| [NC-5](#NC-5) | Constants should be defined rather than using magic numbers | 19 |
| [NC-6](#NC-6) | Functions not used internally could be marked external | 8 |
### <a name="NC-1"></a>[NC-1] Expressions for constant values such as a call to keccak256(), should use immutable rather than constant
constants should be used for literal values written into the code, and immutable variables should be used for expressions, or values calculated in, or passed into the constructor.

*Instances (1)*:
```solidity
File: Well.sol

29:     bytes32 constant RESERVES_STORAGE_SLOT = bytes32(uint256(keccak256("reserves.storage.slot")) - 1);

```

### <a name="NC-2"></a>[NC-2] Constants in comparisons should appear on the left side
Constants should appear on the left side of comparisons, to avoid accidental assignment

*Instances (100)*:
```solidity
File: Well.sol

95:         if (numberOfPumps() == 0) return _pumps;

424:                 if (tokenAmountsIn[i] == 0) continue;

430:                 if (tokenAmountsIn[i] == 0) continue;

648:         if (numberOfPumps() == 0) {

653:         if (numberOfPumps() == 1) {

```

```solidity
File: functions/ConstantProduct2.sol

66:         reserve = LibMath.roundUpDiv(reserve, reserves[j == 1 ? 0 : 1] * EXP_PRECISION);

85:         uint256 i = j == 1 ? 0 : 1;

98:         uint256 i = j == 1 ? 0 : 1;

```

```solidity
File: libraries/ABDKMathQuad.sol

53:             if (x == 0) {

109:             if (x == 0) {

125:                 } else if (bytes16(uint128(result)) == 0x3FFF0000000000000000000000000000) {

129:                     if (xExponent == 0x7FFF) {

133:                         if (xExponent == 0) xExponent = 1;

136:                         if (xSignifier == 0) return NEGATIVE_INFINITY;

158:                         if (xSignifier == 0x80000000000000000000000000000000) {

190:             if (x == 0) {

242:             if (x == 0) {

299:             if (x == 0) {

360:             if (exponent == 0x7FFFF) {

397:             if (exponent == 0x7FFF) {

400:             else if (exponent == 0) {

432:             if (exponent == 0x7FF) {

435:             else if (exponent == 0) {

468:             if (exponent == 0x7FFF) {

525:             return uint128(x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0x7FFF0000000000000000000000000000;

542:             if (absoluteX == 0) return 0;

623:             if (xExponent == 0x7FFF) {

624:                 if (yExponent == 0x7FFF) {

630:             } else if (yExponent == 0x7FFF) {

635:                 if (xExponent == 0) xExponent = 1;

640:                 if (yExponent == 0) yExponent = 1;

643:                 if (xSignifier == 0) {

645:                 } else if (ySignifier == 0) {

669:                         if (xExponent == 0x7FFF) {

702:                         if (xSignifier == 0) {

708:                         if (msb == 113) {

724:                         if (xExponent == 0x7FFF) {

783:             if (xExponent == 0x7FFF) {

784:                 if (yExponent == 0x7FFF) {

786:                     else if (x ^ y == 0x80000000000000000000000000000000) return x | y;

789:                     if (y & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;

792:             } else if (yExponent == 0x7FFF) {

793:                 if (x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;

797:                 if (xExponent == 0) xExponent = 1;

801:                 if (yExponent == 0) yExponent = 1;

805:                 if (xSignifier == 0) {

890:             if (xExponent == 0x7FFF) {

891:                 if (yExponent == 0x7FFF) return NaN;

893:             } else if (yExponent == 0x7FFF) {

896:             } else if (y & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) {

897:                 if (x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;

901:                 if (yExponent == 0) yExponent = 1;

905:                 if (xExponent == 0) {

919:                 if (xSignifier == 0) {

1002:                 if (xExponent == 0x7FFF) {

1006:                     if (xExponent == 0) xExponent = 1;

1009:                     if (xSignifier == 0) return POSITIVE_ZERO;

1011:                     bool oddExponent = xExponent & 0x1 == 0;

1061:             } else if (x == 0x3FFF0000000000000000000000000000) {

1065:                 if (xExponent == 0x7FFF) {

1069:                     if (xExponent == 0) xExponent = 1;

1072:                     if (xSignifier == 0) return NEGATIVE_INFINITY;

1094:                     if (xSignifier == 0x80000000000000000000000000000000) {

1147:             if (xExponent == 0x7FFF && xSignifier != 0) {

1154:                 if (xExponent == 0) xExponent = 1;

1580:             if (xExponent == 0x7FFF && xSignifier != 0) {

1587:                 if (xExponent == 0) xExponent = 1;

```

```solidity
File: libraries/LibBytes.sol

39:         if (reserves.length == 2) {

62:             if (reserves.length & 1 == 1) {

83:         if (n == 2) {

98:             if (i & 1 == 1) {

```

```solidity
File: libraries/LibBytes16.sol

21:         if (reserves.length == 2) {

40:             if (reserves.length & 1 == 1) {

60:         if (n == 2) {

75:             if (i & 1 == 1) {

```

```solidity
File: libraries/LibLastReserveBytes.sol

22:         if (n == 1) {

53:             if (reserves.length & 1 == 1) {

80:         if (n == 0) return (n, lastTimestamp, reserves);

86:         if (n == 1) return (n, lastTimestamp, reserves);

99:                 if (i & 1 == 1) {

```

```solidity
File: libraries/LibMath.sol

15:         if (a == 0) return 0;

34:         if (a == 0) return 0;

36:         if (n & 1 == 0) {

37:             if (n == 2) return sqrt(a); // shortcut for square root

38:             if (n == 4) return sqrt(sqrt(a));

39:             if (n == 8) return sqrt(sqrt(sqrt(a)));

40:             if (n == 16) return sqrt(sqrt(sqrt(sqrt(a))));

158:         if (prod1 == 0) {

```

```solidity
File: pumps/MultiFlowPump.sol

83:         if (pumpState.lastTimestamp == 0) {

86:                 if (reserves[i] == 0) return;

153:             if (reserves[i] == 0) return;

174:         if (numberOfReserves == 0) {

205:         if (lastReserve.cmp(reserve) == 1) {

208:             if (minReserve.cmp(reserve) == 1) reserve = minReserve;

215:             if (reserve.cmp(maxReserve) == 1) reserve = maxReserve;

225:         if (numberOfReserves == 0) {

243:         if (numberOfReserves == 0) {

270:         if (numberOfReserves == 0) {

289:         if (numberOfReserves == 0) {

```

```solidity
File: utils/ClonePlus.sol

31:         if (bytesLen == 0) return data;

```

### <a name="NC-3"></a>[NC-3]  `require()` / `revert()` statements should have descriptive reason strings

*Instances (20)*:
```solidity
File: libraries/ABDKMathQuad.sol

82:             require(exponent <= 16_638); // Overflow

92:                 require(result <= 0x8000000000000000000000000000000000000000000000000000000000000000);

95:                 require(result <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);

221:             require(uint128(x) < 0x80000000000000000000000000000000); // Negative

223:             require(exponent <= 16_638); // Overflow

271:             require(exponent <= 16_510); // Overflow

281:                 require(result <= 0x8000000000000000000000000000000000000000000000000000000000000000);

284:                 require(result <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);

328:             require(exponent <= 16_446); // Overflow

338:                 require(result <= 0x80000000000000000000000000000000);

341:                 require(result <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);

540:             require(absoluteX <= 0x7FFF0000000000000000000000000000); // Not NaN

560:             require(absoluteX <= 0x7FFF0000000000000000000000000000); // Not NaN

564:             require(absoluteY <= 0x7FFF0000000000000000000000000000); // Not NaN

567:             require(x != y || absoluteX < 0x7FFF0000000000000000000000000000);

2008:                 require(y < 0x80000000000000000000000000000000); // Negative

2010:                 require(exponent <= 16_638); // Overflow

2043:             require(x > 0);

```

```solidity
File: libraries/LibMath.sol

159:             require(denominator > 0);

168:         require(denominator > prod1);

```

### <a name="NC-4"></a>[NC-4] Event is missing `indexed` fields
Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

*Instances (7)*:
```solidity
File: interfaces/IAquifer.sol

33:     event BoreWell(

```

```solidity
File: interfaces/IWell.sol

27:     event Swap(IERC20 fromToken, IERC20 toToken, uint256 amountIn, uint256 amountOut, address recipient);

35:     event AddLiquidity(uint256[] tokenAmountsIn, uint256 lpAmountOut, address recipient);

44:     event RemoveLiquidity(uint256 lpAmountIn, uint256[] tokenAmountsOut, address recipient);

56:     event RemoveLiquidityOneToken(uint256 lpAmountIn, IERC20 tokenOut, uint256 tokenAmountOut, address recipient);

65:     event Shift(uint256[] reserves, IERC20 toToken, uint256 minAmountOut, address recipient);

71:     event Sync(uint256[] reserves);

```

### <a name="NC-5"></a>[NC-5] Constants should be defined rather than using magic numbers

*Instances (19)*:
```solidity
File: libraries/ABDKMathQuad.sol

1019:                             uint256 shift = (226 - msb) & 0xFE;

1028:                             uint256 shift = (225 - msb) & 0xFE;

```

```solidity
File: libraries/LibClone.sol

434:             mstore(0x01, shl(96, deployer))

447:             if iszero(or(iszero(shr(96, salt)), eq(caller(), shr(96, salt)))) {

```

```solidity
File: libraries/LibContractInfo.sol

23:                 mstore(add(symbol, 0x20), shl(224, shr(128, _contract)))

41:                 mstore(add(name, 0x20), shl(224, shr(128, _contract)))

```

```solidity
File: libraries/LibLastReserveBytes.sol

15:             _numberOfReserves := shr(248, sload(slot))

24:                 sstore(slot, or(or(shl(208, lastTimestamp), shl(248, n)), shl(104, shr(152, mload(add(reserves, 32))))))

32:                     or(shl(208, lastTimestamp), shl(248, n)),

33:                     or(shl(104, shr(152, mload(add(reserves, 32)))), shr(152, mload(add(reserves, 64))))

77:             n := shr(248, temp)

78:             lastTimestamp := shr(208, temp)

84:             mstore(add(reserves, 32), shl(152, shr(104, temp)))

88:             mstore(add(reserves, 64), shl(152, temp))

```

```solidity
File: libraries/LibMath.sol

86:                 z := shl(64, z)

89:                 y := shr(64, y)

94:                 z := shl(16, z)

97:                 y := shr(16, y)

117:             z := shr(18, mul(z, add(y, 65536))) // A mul() is saved from starting z at 181.

```

### <a name="NC-6"></a>[NC-6] Functions not used internally could be marked external

*Instances (8)*:
```solidity
File: Well.sol

31:     function init(string memory name, string memory symbol) public initializer {

```

```solidity
File: libraries/LibWellConstructor.sol

87:     function encodeCall(address target, bytes memory data) public pure returns (Call memory) {

```

```solidity
File: pumps/MultiFlowPump.sol

171:     function readLastReserves(address well) public view returns (uint256[] memory reserves) {

222:     function readLastInstantaneousReserves(address well) public view returns (uint256[] memory reserves) {

239:     function readInstantaneousReserves(address well, bytes memory) public view returns (uint256[] memory emaReserves) {

267:     function readLastCumulativeReserves(address well) public view returns (bytes16[] memory reserves) {

280:     function readCumulativeReserves(address well, bytes memory) public view returns (bytes memory cumulativeReserves) {

307:     function readTwaReserves(

```


## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | Divide before Multiplication | 4 |
| [L-2](#L-2) | Empty Function Body - Consider commenting why | 4 |
| [L-3](#L-3) | Initializers could be front-run | 7 |
| [L-4](#L-4) | ERC20 tokens that do not implement optional decimals method cannot be used | 1 |
| [L-5](#L-5) | _safeMint() should be used rather than _mint() | 1 |
### <a name="L-1"></a>[L-1] Divide before Multiplication
Unnecessary loss of precision caused by divide before multiplication

*Instances (4)*:
```solidity
File: functions/ConstantProduct.sol

40:         reserve = uint256((lpTokenSupply / n) ** n);

```

```solidity
File: libraries/LibBytes.sol

96:             iByte = (i - 1) / 2 * 32;

```

```solidity
File: libraries/LibBytes16.sol

73:             iByte = (i - 1) / 2 * 32;

```

```solidity
File: libraries/LibLastReserveBytes.sol

97:                 iByte = (i - 1) / 2 * 32;

```

### <a name="L-2"></a>[L-2] Empty Function Body - Consider commenting why

*Instances (4)*:
```solidity
File: Aquifer.sol

27:     constructor() ReentrancyGuard() {}

```

```solidity
File: Well.sol

114:     function wellData() public pure returns (bytes memory) {}

656:             try IPump(_pump.target).update(reserves, _pump.data) {}

664:                 try IPump(_pumps[i].target).update(reserves, _pumps[i].data) {}

```

### <a name="L-3"></a>[L-3] Initializers could be front-run
Initializers could be front-run, allowing an attacker to either set their own values, take ownership of the contract, and in the best case forcing a re-deployment

*Instances (7)*:
```solidity
File: Well.sol

31:     function init(string memory name, string memory symbol) public initializer {

31:     function init(string memory name, string memory symbol) public initializer {

32:         __ERC20Permit_init(name);

33:         __ERC20_init(name, symbol);

```

```solidity
File: libraries/LibWellConstructor.sol

81:         initFunctionCall = abi.encodeWithSignature("init(string,string)", name, symbol);

```

```solidity
File: pumps/MultiFlowPump.sol

88:             _init(slot, uint40(block.timestamp), reserves);

146:     function _init(bytes32 slot, uint40 lastTimestamp, uint256[] memory reserves) internal {

```

### <a name="L-4"></a>[L-4] ERC20 tokens that do not implement optional decimals method cannot be used
Underlying token that does not implement optional decimals method cannot be used 
 
 > [EIP-20](https://eips.ethereum.org/EIPS/eip-20#decimals) OPTIONAL - This method can be used to improve usability, but interfaces and other contracts MUST NOT expect these values to be present.

*Instances (1)*:
```solidity
File: libraries/LibContractInfo.sol

53:         (bool success, bytes memory data) = _contract.staticcall(abi.encodeWithSignature("decimals()"));

```

### <a name="L-5"></a>[L-5] _safeMint() should be used rather than _mint()
_mint() is discouraged in favor of _safeMint() which ensures that the recipient is either an EOA or implements IERC721Receiver. Both OpenZeppelin and solmate have versions of this function

*Instances (1)*:
```solidity
File: Well.sol

441:         _mint(recipient, lpAmountOut);

```

