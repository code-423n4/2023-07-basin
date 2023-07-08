# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Use assembly to check for `address(0)` | 3 |
| [GAS-2](#GAS-2) | `array[index] += amount` is cheaper than `array[index] = array[index] + amount` (or related variants) | 1 |
| [GAS-3](#GAS-3) | Cache array length outside of loop | 24 |
| [GAS-4](#GAS-4) | Use calldata instead of memory for function arguments that do not get mutated | 20 |
| [GAS-5](#GAS-5) | Use Custom Errors | 6 |
| [GAS-6](#GAS-6) | Don't initialize variables with default value | 5 |
| [GAS-7](#GAS-7) | `++i` costs less gas than `i++`, especially when it's used in `for`-loops (`--i`/`i--` too) | 1 |
| [GAS-8](#GAS-8) | Use shift Right/Left instead of division/multiplication if possible | 4 |
| [GAS-9](#GAS-9) | Use != 0 instead of > 0 for unsigned integer comparison | 286 |
| [GAS-10](#GAS-10) | `internal` functions not called by the contract should be removed | 53 |
### <a name="GAS-1"></a>[GAS-1] Use assembly to check for `address(0)`
*Saves 6 gas per instance*

*Instances (3)*:
```solidity
File: Aquifer.sol

41:             if (salt != bytes32(0)) {

47:             if (salt != bytes32(0)) {

```

```solidity
File: pumps/MultiFlowPump.sol

319:         if (deltaTimestamp == bytes16(0)) {

```

### <a name="GAS-2"></a>[GAS-2] `array[index] += amount` is cheaper than `array[index] = array[index] + amount` (or related variants)
When updating a value in an array with arithmetic, using `array[index] += amount` is cheaper than `array[index] = array[index] + amount`.
This is because you avoid an additonal `mload` when the array is stored in memory, and an `sload` when the array is stored in storage.
This can be applied for any arithmetic operation including `+=`, `-=`,`/=`,`*=`,`^=`,`&=`, `%=`, `<<=`,`>>=`, and `>>>=`.
This optimization can be particularly significant if the pattern occurs during a loop.

*Saves 28 gas for a storage array, 38 for a memory array*

*Instances (1)*:
```solidity
File: Well.sol

514:         reserves[j] = reserves[j] - tokenAmountOut;

```

### <a name="GAS-3"></a>[GAS-3] Cache array length outside of loop
If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (24)*:
```solidity
File: Well.sol

36:         for (uint256 i; i < _tokens.length - 1; ++i) {

37:             for (uint256 j = i + 1; j < _tokens.length; ++j) {

101:         for (uint256 i; i < _pumps.length; i++) {

363:         for (uint256 i; i < _tokens.length; ++i) {

382:         for (uint256 i; i < _tokens.length; ++i) {

423:             for (uint256 i; i < _tokens.length; ++i) {

429:             for (uint256 i; i < _tokens.length; ++i) {

452:         for (uint256 i; i < _tokens.length; ++i) {

473:         for (uint256 i; i < _tokens.length; ++i) {

557:         for (uint256 i; i < _tokens.length; ++i) {

579:         for (uint256 i; i < _tokens.length; ++i) {

593:         for (uint256 i; i < _tokens.length; ++i) {

607:         for (uint256 i; i < _tokens.length; ++i) {

633:         for (uint256 i; i < reserves.length; ++i) {

662:             for (uint256 i; i < _pumps.length; ++i) {

738:         for (uint256 k; k < _tokens.length; ++k) {

760:         for (j; j < _tokens.length; ++j) {

```

```solidity
File: functions/ConstantProduct.sol

71:         for (uint256 i; i < reserves.length; ++i) {

86:         for (uint256 i; i < reserves.length; ++i) {

```

```solidity
File: functions/ProportionalLPToken.sol

22:         for (uint256 i; i < reserves.length; ++i) {

```

```solidity
File: libraries/LibWellConstructor.sol

43:         for (uint256 i; i < _pumps.length; ++i) {

73:         for (uint256 i = 1; i < _tokens.length; ++i) {

```

```solidity
File: pumps/MultiFlowPump.sol

301:         for (uint256 i; i < cumulativeReserves.length; ++i) {

322:         for (uint256 i; i < byteCumulativeReserves.length; ++i) {

```

### <a name="GAS-4"></a>[GAS-4] Use calldata instead of memory for function arguments that do not get mutated
Mark data types as `calldata` instead of `memory` where possible. This makes it so that the data is not automatically loaded into memory. If the data passed into the function does not need to be changed (like updating values in an array), it can be passed in as `calldata`. The one exception to this is if the argument must later be passed into another function that takes an argument that specifies `memory` storage.

*Instances (20)*:
```solidity
File: Well.sol

31:     function init(string memory name, string memory symbol) public initializer {

31:     function init(string memory name, string memory symbol) public initializer {

393:         uint256[] memory tokenAmountsIn,

402:         uint256[] memory tokenAmountsIn,

449:     function getAddLiquidityOut(uint256[] memory tokenAmountsIn) external view returns (uint256 lpAmountOut) {

```

```solidity
File: interfaces/IWell.sol

248:         uint256[] memory tokenAmountsIn,

265:         uint256[] memory tokenAmountsIn,

276:     function getAddLiquidityOut(uint256[] memory tokenAmountsIn) external view returns (uint256 lpAmountOut);

```

```solidity
File: interfaces/IWellFunction.sol

23:         uint256[] memory reserves,

37:         uint256[] memory reserves,

54:         uint256[] memory reserves,

```

```solidity
File: interfaces/pumps/ICumulativePump.sol

19:         bytes memory data

35:         bytes memory data

```

```solidity
File: interfaces/pumps/IInstantaneousPump.sol

16:         bytes memory data

```

```solidity
File: libraries/LibWellConstructor.sol

68:         IERC20[] memory _tokens,

69:         Call memory _wellFunction

87:     function encodeCall(address target, bytes memory data) public pure returns (Call memory) {

```

```solidity
File: pumps/MultiFlowPump.sol

239:     function readInstantaneousReserves(address well, bytes memory) public view returns (uint256[] memory emaReserves) {

280:     function readCumulativeReserves(address well, bytes memory) public view returns (bytes memory cumulativeReserves) {

311:         bytes memory

```

### <a name="GAS-5"></a>[GAS-5] Use Custom Errors
[Source](https://blog.soliditylang.org/2021/04/21/custom-errors/)
Instead of using error strings, to reduce deployment and runtime cost, you should use Custom Errors. This would save both deployment and runtime cost.

*Instances (6)*:
```solidity
File: Well.sol

617:         require(!_reentrancyGuardEntered(), "ReentrancyGuard: reentrant call");

```

```solidity
File: libraries/LibBytes.sol

40:             require(reserves[0] <= type(uint128).max, "ByteStorage: too large");

41:             require(reserves[1] <= type(uint128).max, "ByteStorage: too large");

49:                 require(reserves[2 * i] <= type(uint128).max, "ByteStorage: too large");

50:                 require(reserves[2 * i + 1] <= type(uint128).max, "ByteStorage: too large");

63:                 require(reserves[reserves.length - 1] <= type(uint128).max, "ByteStorage: too large");

```

### <a name="GAS-6"></a>[GAS-6] Don't initialize variables with default value

*Instances (5)*:
```solidity
File: Well.sol

77:     uint256 constant LOC_AQUIFER_ADDR = 0;

735:         bool foundI = false;

736:         bool foundJ = false;

```

```solidity
File: functions/ConstantProduct.sol

70:         uint256 sumRatio = 0;

```

```solidity
File: libraries/ABDKMathQuad.sol

2045:             uint256 result = 0;

```

### <a name="GAS-7"></a>[GAS-7] `++i` costs less gas than `i++`, especially when it's used in `for`-loops (`--i`/`i--` too)
*Saves 5 gas per loop*

*Instances (1)*:
```solidity
File: Well.sol

101:         for (uint256 i; i < _pumps.length; i++) {

```

### <a name="GAS-8"></a>[GAS-8] Use shift Right/Left instead of division/multiplication if possible

*Instances (4)*:
```solidity
File: libraries/LibBytes.sol

46:             uint256 maxI = reserves.length / 2; // number of fully-packed slots

```

```solidity
File: libraries/LibBytes16.sol

26:             uint256 maxI = reserves.length / 2; // number of fully-packed slots

```

```solidity
File: libraries/LibLastReserveBytes.sol

39:             uint256 maxI = n / 2; // number of fully-packed slots

```

```solidity
File: pumps/MultiFlowPump.sol

343:         return ((numberOfReserves - 1) / 2 + 1) << 5;

```

### <a name="GAS-9"></a>[GAS-9] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (286)*:
```solidity
File: Aquifer.sol

40:         if (immutableData.length > 0) {

54:         if (initFunctionCall.length > 0) {

```

```solidity
File: Well.sol

609:             if (skimAmounts[i] > 0) {

```

```solidity
File: libraries/ABDKMathQuad.sol

57:                 uint256 result = uint256(x > 0 ? x : -x);

123:                 if (uint128(result) > 0x80000000000000000000000000000000) {

246:                 uint256 result = uint256(x > 0 ? x : -x);

303:                 uint256 result = uint128(x > 0 ? x : -x);

355:             bool negative = x & 0x8000000000000000000000000000000000000000000000000000000000000000 > 0;

361:                 if (significand > 0) return NaN;

401:                 if (result > 0) {

436:                 if (result > 0) {

447:             if (x & 0x8000000000000000 > 0) {

469:                 if (significand > 0) {

512:             return uint128(x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF > 0x7FFF0000000000000000000000000000;

653:                         } else if (delta > 0) {

682:                         if (delta > 0) {

806:                     return (x ^ y) & 0x80000000000000000000000000000000 > 0 ? NEGATIVE_ZERO : POSITIVE_ZERO;

920:                     return (x ^ y) & 0x80000000000000000000000000000000 > 0 ? NEGATIVE_ZERO : POSITIVE_ZERO;

935:                 } else if (xExponent + msb + 16_380 < yExponent) {

943:                     } else if (xExponent + 16_380 < yExponent) {

998:             if (uint128(x) > 0x80000000000000000000000000000000) {

1059:             if (uint128(x) > 0x80000000000000000000000000000000) {

1143:             bool xNegative = uint128(x) > 0x80000000000000000000000000000000;

1163:                 if (xNegative && xSignifier > 0x406E00000000000000000000000000000000) {

1167:                 if (!xNegative && xSignifier > 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) {

1179:                 if (xSignifier & 0x80000000000000000000000000000000 > 0) {

1182:                 if (xSignifier & 0x40000000000000000000000000000000 > 0) {

1185:                 if (xSignifier & 0x20000000000000000000000000000000 > 0) {

1188:                 if (xSignifier & 0x10000000000000000000000000000000 > 0) {

1191:                 if (xSignifier & 0x8000000000000000000000000000000 > 0) {

1194:                 if (xSignifier & 0x4000000000000000000000000000000 > 0) {

1197:                 if (xSignifier & 0x2000000000000000000000000000000 > 0) {

1200:                 if (xSignifier & 0x1000000000000000000000000000000 > 0) {

1203:                 if (xSignifier & 0x800000000000000000000000000000 > 0) {

1206:                 if (xSignifier & 0x400000000000000000000000000000 > 0) {

1209:                 if (xSignifier & 0x200000000000000000000000000000 > 0) {

1212:                 if (xSignifier & 0x100000000000000000000000000000 > 0) {

1215:                 if (xSignifier & 0x80000000000000000000000000000 > 0) {

1218:                 if (xSignifier & 0x40000000000000000000000000000 > 0) {

1221:                 if (xSignifier & 0x20000000000000000000000000000 > 0) {

1224:                 if (xSignifier & 0x10000000000000000000000000000 > 0) {

1227:                 if (xSignifier & 0x8000000000000000000000000000 > 0) {

1230:                 if (xSignifier & 0x4000000000000000000000000000 > 0) {

1233:                 if (xSignifier & 0x2000000000000000000000000000 > 0) {

1236:                 if (xSignifier & 0x1000000000000000000000000000 > 0) {

1239:                 if (xSignifier & 0x800000000000000000000000000 > 0) {

1242:                 if (xSignifier & 0x400000000000000000000000000 > 0) {

1245:                 if (xSignifier & 0x200000000000000000000000000 > 0) {

1248:                 if (xSignifier & 0x100000000000000000000000000 > 0) {

1251:                 if (xSignifier & 0x80000000000000000000000000 > 0) {

1254:                 if (xSignifier & 0x40000000000000000000000000 > 0) {

1257:                 if (xSignifier & 0x20000000000000000000000000 > 0) {

1260:                 if (xSignifier & 0x10000000000000000000000000 > 0) {

1263:                 if (xSignifier & 0x8000000000000000000000000 > 0) {

1266:                 if (xSignifier & 0x4000000000000000000000000 > 0) {

1269:                 if (xSignifier & 0x2000000000000000000000000 > 0) {

1272:                 if (xSignifier & 0x1000000000000000000000000 > 0) {

1275:                 if (xSignifier & 0x800000000000000000000000 > 0) {

1278:                 if (xSignifier & 0x400000000000000000000000 > 0) {

1281:                 if (xSignifier & 0x200000000000000000000000 > 0) {

1284:                 if (xSignifier & 0x100000000000000000000000 > 0) {

1287:                 if (xSignifier & 0x80000000000000000000000 > 0) {

1290:                 if (xSignifier & 0x40000000000000000000000 > 0) {

1293:                 if (xSignifier & 0x20000000000000000000000 > 0) {

1296:                 if (xSignifier & 0x10000000000000000000000 > 0) {

1299:                 if (xSignifier & 0x8000000000000000000000 > 0) {

1302:                 if (xSignifier & 0x4000000000000000000000 > 0) {

1305:                 if (xSignifier & 0x2000000000000000000000 > 0) {

1308:                 if (xSignifier & 0x1000000000000000000000 > 0) {

1311:                 if (xSignifier & 0x800000000000000000000 > 0) {

1314:                 if (xSignifier & 0x400000000000000000000 > 0) {

1317:                 if (xSignifier & 0x200000000000000000000 > 0) {

1320:                 if (xSignifier & 0x100000000000000000000 > 0) {

1323:                 if (xSignifier & 0x80000000000000000000 > 0) {

1326:                 if (xSignifier & 0x40000000000000000000 > 0) {

1329:                 if (xSignifier & 0x20000000000000000000 > 0) {

1332:                 if (xSignifier & 0x10000000000000000000 > 0) {

1335:                 if (xSignifier & 0x8000000000000000000 > 0) {

1338:                 if (xSignifier & 0x4000000000000000000 > 0) {

1341:                 if (xSignifier & 0x2000000000000000000 > 0) {

1344:                 if (xSignifier & 0x1000000000000000000 > 0) {

1347:                 if (xSignifier & 0x800000000000000000 > 0) {

1350:                 if (xSignifier & 0x400000000000000000 > 0) {

1353:                 if (xSignifier & 0x200000000000000000 > 0) {

1356:                 if (xSignifier & 0x100000000000000000 > 0) {

1359:                 if (xSignifier & 0x80000000000000000 > 0) {

1362:                 if (xSignifier & 0x40000000000000000 > 0) {

1365:                 if (xSignifier & 0x20000000000000000 > 0) {

1368:                 if (xSignifier & 0x10000000000000000 > 0) {

1371:                 if (xSignifier & 0x8000000000000000 > 0) {

1374:                 if (xSignifier & 0x4000000000000000 > 0) {

1377:                 if (xSignifier & 0x2000000000000000 > 0) {

1380:                 if (xSignifier & 0x1000000000000000 > 0) {

1383:                 if (xSignifier & 0x800000000000000 > 0) {

1386:                 if (xSignifier & 0x400000000000000 > 0) {

1389:                 if (xSignifier & 0x200000000000000 > 0) {

1392:                 if (xSignifier & 0x100000000000000 > 0) {

1395:                 if (xSignifier & 0x80000000000000 > 0) {

1398:                 if (xSignifier & 0x40000000000000 > 0) {

1401:                 if (xSignifier & 0x20000000000000 > 0) {

1404:                 if (xSignifier & 0x10000000000000 > 0) {

1407:                 if (xSignifier & 0x8000000000000 > 0) {

1410:                 if (xSignifier & 0x4000000000000 > 0) {

1413:                 if (xSignifier & 0x2000000000000 > 0) {

1416:                 if (xSignifier & 0x1000000000000 > 0) {

1419:                 if (xSignifier & 0x800000000000 > 0) {

1422:                 if (xSignifier & 0x400000000000 > 0) {

1425:                 if (xSignifier & 0x200000000000 > 0) {

1428:                 if (xSignifier & 0x100000000000 > 0) {

1431:                 if (xSignifier & 0x80000000000 > 0) {

1434:                 if (xSignifier & 0x40000000000 > 0) {

1437:                 if (xSignifier & 0x20000000000 > 0) {

1440:                 if (xSignifier & 0x10000000000 > 0) {

1443:                 if (xSignifier & 0x8000000000 > 0) {

1446:                 if (xSignifier & 0x4000000000 > 0) {

1449:                 if (xSignifier & 0x2000000000 > 0) {

1452:                 if (xSignifier & 0x1000000000 > 0) {

1455:                 if (xSignifier & 0x800000000 > 0) {

1458:                 if (xSignifier & 0x400000000 > 0) {

1461:                 if (xSignifier & 0x200000000 > 0) {

1464:                 if (xSignifier & 0x100000000 > 0) {

1467:                 if (xSignifier & 0x80000000 > 0) {

1470:                 if (xSignifier & 0x40000000 > 0) {

1473:                 if (xSignifier & 0x20000000 > 0) {

1476:                 if (xSignifier & 0x10000000 > 0) {

1479:                 if (xSignifier & 0x8000000 > 0) {

1482:                 if (xSignifier & 0x4000000 > 0) {

1485:                 if (xSignifier & 0x2000000 > 0) {

1488:                 if (xSignifier & 0x1000000 > 0) {

1491:                 if (xSignifier & 0x800000 > 0) {

1494:                 if (xSignifier & 0x400000 > 0) {

1497:                 if (xSignifier & 0x200000 > 0) {

1500:                 if (xSignifier & 0x100000 > 0) {

1503:                 if (xSignifier & 0x80000 > 0) {

1506:                 if (xSignifier & 0x40000 > 0) {

1509:                 if (xSignifier & 0x20000 > 0) {

1512:                 if (xSignifier & 0x10000 > 0) {

1515:                 if (xSignifier & 0x8000 > 0) {

1518:                 if (xSignifier & 0x4000 > 0) {

1521:                 if (xSignifier & 0x2000 > 0) {

1524:                 if (xSignifier & 0x1000 > 0) {

1527:                 if (xSignifier & 0x800 > 0) {

1530:                 if (xSignifier & 0x400 > 0) {

1533:                 if (xSignifier & 0x200 > 0) {

1536:                 if (xSignifier & 0x100 > 0) {

1539:                 if (xSignifier & 0x80 > 0) {

1542:                 if (xSignifier & 0x40 > 0) {

1545:                 if (xSignifier & 0x20 > 0) {

1548:                 if (xSignifier & 0x10 > 0) {

1551:                 if (xSignifier & 0x8 > 0) {

1554:                 if (xSignifier & 0x4 > 0) {

1576:             bool xNegative = uint128(x) > 0x80000000000000000000000000000000;

1596:                 if (xNegative && xSignifier > 0x406E00000000000000000000000000000000) {

1600:                 if (!xNegative && xSignifier > 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) {

1612:                 if (xSignifier & 0x80000000000000000000000000000000 > 0) {

1615:                 if (xSignifier & 0x40000000000000000000000000000000 > 0) {

1618:                 if (xSignifier & 0x20000000000000000000000000000000 > 0) {

1621:                 if (xSignifier & 0x10000000000000000000000000000000 > 0) {

1624:                 if (xSignifier & 0x8000000000000000000000000000000 > 0) {

1627:                 if (xSignifier & 0x4000000000000000000000000000000 > 0) {

1630:                 if (xSignifier & 0x2000000000000000000000000000000 > 0) {

1633:                 if (xSignifier & 0x1000000000000000000000000000000 > 0) {

1636:                 if (xSignifier & 0x800000000000000000000000000000 > 0) {

1639:                 if (xSignifier & 0x400000000000000000000000000000 > 0) {

1642:                 if (xSignifier & 0x200000000000000000000000000000 > 0) {

1645:                 if (xSignifier & 0x100000000000000000000000000000 > 0) {

1648:                 if (xSignifier & 0x80000000000000000000000000000 > 0) {

1651:                 if (xSignifier & 0x40000000000000000000000000000 > 0) {

1654:                 if (xSignifier & 0x20000000000000000000000000000 > 0) {

1657:                 if (xSignifier & 0x10000000000000000000000000000 > 0) {

1660:                 if (xSignifier & 0x8000000000000000000000000000 > 0) {

1663:                 if (xSignifier & 0x4000000000000000000000000000 > 0) {

1666:                 if (xSignifier & 0x2000000000000000000000000000 > 0) {

1669:                 if (xSignifier & 0x1000000000000000000000000000 > 0) {

1672:                 if (xSignifier & 0x800000000000000000000000000 > 0) {

1675:                 if (xSignifier & 0x400000000000000000000000000 > 0) {

1678:                 if (xSignifier & 0x200000000000000000000000000 > 0) {

1681:                 if (xSignifier & 0x100000000000000000000000000 > 0) {

1684:                 if (xSignifier & 0x80000000000000000000000000 > 0) {

1687:                 if (xSignifier & 0x40000000000000000000000000 > 0) {

1690:                 if (xSignifier & 0x20000000000000000000000000 > 0) {

1693:                 if (xSignifier & 0x10000000000000000000000000 > 0) {

1696:                 if (xSignifier & 0x8000000000000000000000000 > 0) {

1699:                 if (xSignifier & 0x4000000000000000000000000 > 0) {

1702:                 if (xSignifier & 0x2000000000000000000000000 > 0) {

1705:                 if (xSignifier & 0x1000000000000000000000000 > 0) {

1708:                 if (xSignifier & 0x800000000000000000000000 > 0) {

1711:                 if (xSignifier & 0x400000000000000000000000 > 0) {

1714:                 if (xSignifier & 0x200000000000000000000000 > 0) {

1717:                 if (xSignifier & 0x100000000000000000000000 > 0) {

1720:                 if (xSignifier & 0x80000000000000000000000 > 0) {

1723:                 if (xSignifier & 0x40000000000000000000000 > 0) {

1726:                 if (xSignifier & 0x20000000000000000000000 > 0) {

1729:                 if (xSignifier & 0x10000000000000000000000 > 0) {

1732:                 if (xSignifier & 0x8000000000000000000000 > 0) {

1735:                 if (xSignifier & 0x4000000000000000000000 > 0) {

1738:                 if (xSignifier & 0x2000000000000000000000 > 0) {

1741:                 if (xSignifier & 0x1000000000000000000000 > 0) {

1744:                 if (xSignifier & 0x800000000000000000000 > 0) {

1747:                 if (xSignifier & 0x400000000000000000000 > 0) {

1750:                 if (xSignifier & 0x200000000000000000000 > 0) {

1753:                 if (xSignifier & 0x100000000000000000000 > 0) {

1756:                 if (xSignifier & 0x80000000000000000000 > 0) {

1759:                 if (xSignifier & 0x40000000000000000000 > 0) {

1762:                 if (xSignifier & 0x20000000000000000000 > 0) {

1765:                 if (xSignifier & 0x10000000000000000000 > 0) {

1768:                 if (xSignifier & 0x8000000000000000000 > 0) {

1771:                 if (xSignifier & 0x4000000000000000000 > 0) {

1774:                 if (xSignifier & 0x2000000000000000000 > 0) {

1777:                 if (xSignifier & 0x1000000000000000000 > 0) {

1780:                 if (xSignifier & 0x800000000000000000 > 0) {

1783:                 if (xSignifier & 0x400000000000000000 > 0) {

1786:                 if (xSignifier & 0x200000000000000000 > 0) {

1789:                 if (xSignifier & 0x100000000000000000 > 0) {

1792:                 if (xSignifier & 0x80000000000000000 > 0) {

1795:                 if (xSignifier & 0x40000000000000000 > 0) {

1798:                 if (xSignifier & 0x20000000000000000 > 0) {

1801:                 if (xSignifier & 0x10000000000000000 > 0) {

1804:                 if (xSignifier & 0x8000000000000000 > 0) {

1807:                 if (xSignifier & 0x4000000000000000 > 0) {

1810:                 if (xSignifier & 0x2000000000000000 > 0) {

1813:                 if (xSignifier & 0x1000000000000000 > 0) {

1816:                 if (xSignifier & 0x800000000000000 > 0) {

1819:                 if (xSignifier & 0x400000000000000 > 0) {

1822:                 if (xSignifier & 0x200000000000000 > 0) {

1825:                 if (xSignifier & 0x100000000000000 > 0) {

1828:                 if (xSignifier & 0x80000000000000 > 0) {

1831:                 if (xSignifier & 0x40000000000000 > 0) {

1834:                 if (xSignifier & 0x20000000000000 > 0) {

1837:                 if (xSignifier & 0x10000000000000 > 0) {

1840:                 if (xSignifier & 0x8000000000000 > 0) {

1843:                 if (xSignifier & 0x4000000000000 > 0) {

1846:                 if (xSignifier & 0x2000000000000 > 0) {

1849:                 if (xSignifier & 0x1000000000000 > 0) {

1852:                 if (xSignifier & 0x800000000000 > 0) {

1855:                 if (xSignifier & 0x400000000000 > 0) {

1858:                 if (xSignifier & 0x200000000000 > 0) {

1861:                 if (xSignifier & 0x100000000000 > 0) {

1864:                 if (xSignifier & 0x80000000000 > 0) {

1867:                 if (xSignifier & 0x40000000000 > 0) {

1870:                 if (xSignifier & 0x20000000000 > 0) {

1873:                 if (xSignifier & 0x10000000000 > 0) {

1876:                 if (xSignifier & 0x8000000000 > 0) {

1879:                 if (xSignifier & 0x4000000000 > 0) {

1882:                 if (xSignifier & 0x2000000000 > 0) {

1885:                 if (xSignifier & 0x1000000000 > 0) {

1888:                 if (xSignifier & 0x800000000 > 0) {

1891:                 if (xSignifier & 0x400000000 > 0) {

1894:                 if (xSignifier & 0x200000000 > 0) {

1897:                 if (xSignifier & 0x100000000 > 0) {

1900:                 if (xSignifier & 0x80000000 > 0) {

1903:                 if (xSignifier & 0x40000000 > 0) {

1906:                 if (xSignifier & 0x20000000 > 0) {

1909:                 if (xSignifier & 0x10000000 > 0) {

1912:                 if (xSignifier & 0x8000000 > 0) {

1915:                 if (xSignifier & 0x4000000 > 0) {

1918:                 if (xSignifier & 0x2000000 > 0) {

1921:                 if (xSignifier & 0x1000000 > 0) {

1924:                 if (xSignifier & 0x800000 > 0) {

1927:                 if (xSignifier & 0x400000 > 0) {

1930:                 if (xSignifier & 0x200000 > 0) {

1933:                 if (xSignifier & 0x100000 > 0) {

1936:                 if (xSignifier & 0x80000 > 0) {

1939:                 if (xSignifier & 0x40000 > 0) {

1942:                 if (xSignifier & 0x20000 > 0) {

1945:                 if (xSignifier & 0x10000 > 0) {

1948:                 if (xSignifier & 0x8000 > 0) {

1951:                 if (xSignifier & 0x4000 > 0) {

1954:                 if (xSignifier & 0x2000 > 0) {

1957:                 if (xSignifier & 0x1000 > 0) {

1960:                 if (xSignifier & 0x800 > 0) {

1963:                 if (xSignifier & 0x400 > 0) {

1966:                 if (xSignifier & 0x200 > 0) {

1969:                 if (xSignifier & 0x100 > 0) {

1972:                 if (xSignifier & 0x80 > 0) {

1975:                 if (xSignifier & 0x40 > 0) {

1978:                 if (xSignifier & 0x20 > 0) {

1981:                 if (xSignifier & 0x10 > 0) {

1984:                 if (xSignifier & 0x8 > 0) {

1987:                 if (xSignifier & 0x4 > 0) {

2043:             require(x > 0);

2092:         result = y & 1 > 0 ? x : uUint;

2095:         for (y >>= 1; y > 0; y >>= 1) {

2099:             if (y & 1 > 0) {

```

```solidity
File: libraries/LibMath.sol

159:             require(denominator > 0);

```

```solidity
File: pumps/MultiFlowPump.sol

119:                 pumpState.lastReserves[i], (reserves[i] > 0 ? reserves[i] : 1).fromUIntToLog2(), blocksPassed

```

### <a name="GAS-10"></a>[GAS-10] `internal` functions not called by the contract should be removed
If the functions are required by an interface, the contract should inherit from that interface and use the `override` keyword

*Instances (53)*:
```solidity
File: libraries/ABDKMathQuad.sol

51:     function fromInt(int x) internal pure returns (bytes16) {

78:     function toInt(bytes16 x) internal pure returns (int) {

107:     function fromUIntToLog2(uint256 x) internal pure returns (bytes16) {

240:     function from128x128(int x) internal pure returns (bytes16) {

267:     function to128x128(bytes16 x) internal pure returns (int) {

297:     function from64x64(int128 x) internal pure returns (bytes16) {

324:     function to64x64(bytes16 x) internal pure returns (int128) {

353:     function fromOctuple(bytes32 x) internal pure returns (bytes16) {

391:     function toOctuple(bytes16 x) internal pure returns (bytes32) {

426:     function fromDouble(bytes8 x) internal pure returns (bytes16) {

461:     function toDouble(bytes16 x) internal pure returns (bytes8) {

510:     function isNaN(bytes16 x) internal pure returns (bool) {

523:     function isInfinity(bytes16 x) internal pure returns (bool) {

536:     function sign(bytes16 x) internal pure returns (int8) {

556:     function cmp(bytes16 x, bytes16 y) internal pure returns (int8) {

594:     function eq(bytes16 x, bytes16 y) internal pure returns (bool) {

753:     function sub(bytes16 x, bytes16 y) internal pure returns (bytes16) {

885:     function div(bytes16 x, bytes16 y) internal pure returns (bytes16) {

972:     function neg(bytes16 x) internal pure returns (bytes16) {

984:     function abs(bytes16 x) internal pure returns (bytes16) {

996:     function sqrt(bytes16 x) internal pure returns (bytes16) {

1129:     function ln(bytes16 x) internal pure returns (bytes16) {

1574:     function pow_2ToUInt(bytes16 x) internal pure returns (uint256) {

2028:     function exp(bytes16 x) internal pure returns (bytes16) {

2089:     function powu(bytes16 x, uint256 y) internal pure returns (bytes16 result) {

```

```solidity
File: libraries/LibBytes.sol

21:     function getBytes32FromBytes(bytes memory data, uint256 i) internal pure returns (bytes32 _bytes) {

37:     function storeUint128(bytes32 slot, uint256[] memory reserves) internal {

78:     function readUint128(bytes32 slot, uint256 n) internal view returns (uint256[] memory reserves) {

```

```solidity
File: libraries/LibBytes16.sol

19:     function storeBytes16(bytes32 slot, bytes16[] memory reserves) internal {

55:     function readBytes16(bytes32 slot, uint256 n) internal view returns (bytes16[] memory reserves) {

```

```solidity
File: libraries/LibClone.sol

39:             /**

117:         /// @solidity memory-safe-assembly

169:             let mBefore3 := mload(sub(data, 0x60))

305:             // Compute the boundaries of the data and cache the memory slots around it.

448:                 // Store the function selector of `SaltDoesNotStartWithCaller()`.

```

```solidity
File: libraries/LibContractInfo.sol

16:     function getSymbol(address _contract) internal view returns (string memory symbol) {

34:     function getName(address _contract) internal view returns (string memory name) {

52:     function getDecimals(address _contract) internal view returns (uint8 decimals) {

```

```solidity
File: libraries/LibLastReserveBytes.sol

13:     function readNumberOfReserves(bytes32 slot) internal view returns (uint8 _numberOfReserves) {

19:     function storeLastReserves(bytes32 slot, uint40 lastTimestamp, bytes16[] memory reserves) internal {

68:     function readLastReserves(bytes32 slot)

116:     function readBytes(bytes32 slot) internal view returns (bytes32 value) {

```

```solidity
File: libraries/LibMath.sol

14:     function roundUpDiv(uint256 a, uint256 b) internal pure returns (uint256) {

32:     function nthRoot(uint256 a, uint256 n) internal pure returns (uint256 root) {

143:     function mulDiv(uint256 a, uint256 b, uint256 denominator) internal pure returns (uint256 result) {

```

```solidity
File: libraries/LibWellConstructor.sol

13:     function encodeWellDeploymentData(

```

```solidity
File: utils/Clone.sol

14:     function _getArgAddress(uint256 argOffset)

29:     function _getArgUint256(uint256 argOffset)

45:     function _getArgUint256Array(uint256 argOffset, uint256 arrLen)

66:     function _getArgUint64(uint256 argOffset)

81:     function _getArgUint8(uint256 argOffset) internal pure returns (uint8 arg) {

```

```solidity
File: utils/ClonePlus.sol

16:     function _getArgIERC20Array(uint256 argOffset, uint256 arrLen) internal pure returns (IERC20[] memory arr) {

30:     function _getArgBytes(uint256 argOffset, uint256 bytesLen) internal pure returns (bytes memory data) {

```

