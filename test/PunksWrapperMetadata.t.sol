// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {PunksWrapper} from "src/PunksWrapper.sol";
import {BaseTest} from "./BaseTest.sol";

contract PunksWrapperMetadataTest is BaseTest {
    function setUp() public override {
        super.setUp();
        wrapPunk(1234);
        wrapPunk(5822);
    }

    function testStringURI() public {
        string memory uri = test.getStringURI(1234);
        emit log(uri);

        string memory tokenUri = test.tokenURI(1234);
        emit log(tokenUri);
    }

    function testNonHuman() public {
        string memory uri = test.getStringURI(5822);
        emit log(uri);

        string memory tokenUri = test.tokenURI(5822);
        emit log(tokenUri);
    }
}
