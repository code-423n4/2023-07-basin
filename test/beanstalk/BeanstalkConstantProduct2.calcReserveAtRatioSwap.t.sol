// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {console, TestHelper} from "test/TestHelper.sol";
import {ConstantProduct2} from "src/functions/ConstantProduct2.sol";
import {IBeanstalkWellFunction} from "src/interfaces/IBeanstalkWellFunction.sol";

/// @dev Tests the {ConstantProduct2} Well function directly.
contract BeanstalkConstantProduct2SwapTest is TestHelper {
    IBeanstalkWellFunction _f;

    //////////// SETUP ////////////

    function setUp() public {
        _f = new ConstantProduct2();
    }

    function test_calcReserveAtRatioSwap_equal_equal() public {
        uint256[] memory reserves = new uint256[](2);
        reserves[0] = 100;
        reserves[1] = 100;
        uint256[] memory ratios = new uint256[](2);
        ratios[0] = 1;
        ratios[1] = 1;

        uint256 reserve0 = _f.calcReserveAtRatioSwap(reserves, 0, ratios, new bytes(0));
        uint256 reserve1 = _f.calcReserveAtRatioSwap(reserves, 1, ratios, new bytes(0));

        assertEq(reserve0, 100);
        assertEq(reserve1, 100);
    }

    function test_calcReserveAtRatioSwap_equal_diff() public {
        uint256[] memory reserves = new uint256[](2);
        reserves[0] = 50;
        reserves[1] = 100;
        uint256[] memory ratios = new uint256[](2);
        ratios[0] = 12_984_712_098_521;
        ratios[1] = 12_984_712_098_521;

        uint256 reserve0 = _f.calcReserveAtRatioSwap(reserves, 0, ratios, new bytes(0));
        uint256 reserve1 = _f.calcReserveAtRatioSwap(reserves, 1, ratios, new bytes(0));

        assertEq(reserve0, 70);
        assertEq(reserve1, 70);
    }

    function test_calcReserveAtRatioSwap_diff_equal() public {
        uint256[] memory reserves = new uint256[](2);
        reserves[0] = 100;
        reserves[1] = 100;
        uint256[] memory ratios = new uint256[](2);
        ratios[0] = 2;
        ratios[1] = 1;

        uint256 reserve0 = _f.calcReserveAtRatioSwap(reserves, 0, ratios, new bytes(0));
        uint256 reserve1 = _f.calcReserveAtRatioSwap(reserves, 1, ratios, new bytes(0));

        assertEq(reserve0, 141);
        assertEq(reserve1, 70);
    }

    function test_calcReserveAtRatioSwap_diff_diff() public {
        uint256[] memory reserves = new uint256[](2);
        reserves[0] = 50;
        reserves[1] = 100;
        uint256[] memory ratios = new uint256[](2);
        ratios[0] = 12_984_712_098_520;
        ratios[1] = 12_984_712_098;

        uint256 reserve0 = _f.calcReserveAtRatioSwap(reserves, 0, ratios, new bytes(0));
        uint256 reserve1 = _f.calcReserveAtRatioSwap(reserves, 1, ratios, new bytes(0));

        assertEq(reserve0, 2236);
        assertEq(reserve1, 2);
    }

    function test_calcReserveAtRatioSwap_fuzz(uint256[2] memory reserves, uint256[2] memory ratios) public {
        for (uint256 i; i < 2; ++i) {
            // TODO: Upper bound is limited by constant product 2
            reserves[i] = bound(reserves[i], 1e6, 1e32);
            ratios[i] = bound(ratios[i], 1e6, 1e18);
        }

        uint256 lpTokenSupply = _f.calcLpTokenSupply(uint2ToUintN(reserves), new bytes(0));
        console.log(lpTokenSupply);

        uint256[] memory reservesOut = new uint256[](2);
        for (uint256 i; i < 2; ++i) {
            reservesOut[i] = _f.calcReserveAtRatioSwap(uint2ToUintN(reserves), i, uint2ToUintN(ratios), new bytes(0));
        }

        // Get LP token supply with bound reserves.
        uint256 lpTokenSupplyOut = _f.calcLpTokenSupply(reservesOut, new bytes(0));

        // Precision is set to the minimum number of digits of the reserves out.
        uint256 precision = numDigits(reservesOut[0]) > numDigits(reservesOut[1])
            ? numDigits(reservesOut[1])
            : numDigits(reservesOut[0]);

        // Check LP Token Supply after = lp token supply before.
        assertApproxEqRelN(lpTokenSupplyOut, lpTokenSupply, 1, precision);

        // Check ratio of `reservesOut` = ratio of `ratios`.
        assertApproxEqRelN(reservesOut[0] * ratios[1], ratios[0] * reservesOut[1], 1, precision);
    }
}