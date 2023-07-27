// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {PunksWrapper} from "src/PunksWrapper.sol";
import {ICryptoPunks} from "src/ICryptoPunks.sol";
import {ERC721} from "solady/tokens/ERC721.sol";

contract PunksWrapperTest is Test {
    PunksWrapper test;
    ICryptoPunks punks;

    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("mainnet"), 17781059);
        test = new PunksWrapper();
        punks = test.PUNKS();
    }

    function testWrapPunk() public {
        address owner = approvePunk(1234);
        vm.prank(owner);
        test.wrapPunk(1234);
        assertEq(test.balanceOf(address(owner)), 1);
        assertEq(punks.punkIndexToAddress(1234), address(test));
        assertEq(test.ownerOf(1234), address(owner));
    }

    function testWrapPunk_NotPunkOwner() public {
        approvePunk(1234);

        vm.expectRevert(PunksWrapper.NotPunkOwner.selector);
        test.wrapPunk(1234);
    }

    function testWrapPunk_NotApproved() public {
        address owner = punks.punkIndexToAddress(1234);
        vm.prank(owner);
        vm.expectRevert();
        test.wrapPunk(1234);
    }

    function testUnwrapPunk() public {
        address owner = wrapPunk(1234);
        vm.prank(owner);
        test.unwrapPunk(1234, owner);
        assertEq(test.balanceOf(address(owner)), 0, "balance should be 0 after unwrap");
        assertEq(punks.punkIndexToAddress(1234), address(owner), "owner should own original punk");
    }

    function testUnwrapPunk_approved() public {
        address owner = wrapPunk(1234);
        vm.prank(owner);
        test.approve(address(this), 1234);
        test.unwrapPunk(1234, address(this));
        assertEq(test.balanceOf(address(owner)), 0, "balance should be 0 after unwrap");
        assertEq(punks.punkIndexToAddress(1234), address(this), "owner should own original punk");
    }

    function testUnwrapPunk_approvedForAll() public {
        address owner = wrapPunk(1234);
        vm.prank(owner);
        test.setApprovalForAll(address(this), true);
        test.unwrapPunk(1234, address(this));
        assertEq(test.balanceOf(address(owner)), 0, "balance should be 0 after unwrap");
        assertEq(punks.punkIndexToAddress(1234), address(this), "owner should own original punk");
    }

    function testUnwrapPunk_NotApproved() public {
        wrapPunk(1234);
        vm.expectRevert(ERC721.NotOwnerNorApproved.selector);
        test.unwrapPunk(1234, address(this));
    }

    function wrapPunk(uint256 punkId) internal returns (address) {
        address owner = approvePunk(punkId);
        vm.prank(owner);
        test.wrapPunk(punkId);
        return owner;
    }

    function approvePunk(uint256 punkIndex) internal returns (address owner) {
        owner = punks.punkIndexToAddress(punkIndex);
        vm.prank(owner);
        punks.offerPunkForSaleToAddress(punkIndex, 0, address(test));
    }
}