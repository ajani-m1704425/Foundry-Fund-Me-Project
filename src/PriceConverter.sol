// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPriceConverter(
        uint256 ethAmount,
        AggregatorV3Interface pricefeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(pricefeed);
        uint256 ethAmountPrice = (ethPrice * ethAmount) / 1e18;
        return ethAmountPrice;
    }

    function getPrice(
        AggregatorV3Interface pricefeed
    ) internal view returns (uint256) {
        (
            ,
            /* uint80 roundID */ int price /*uint startedAt*/ /*uint timeStamp*/ /*uint80 answeredInRound*/,
            ,
            ,

        ) = pricefeed.latestRoundData();

        return uint256(price * 1e10);
    }
}
