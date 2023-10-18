// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {PunksWrapper} from "src/PunksWrapper.sol";
import {ICryptoPunks} from "src/interfaces/ICryptoPunks.sol";

contract PunksWrapperHelper is PunksWrapper {
    /**
     * @dev expose internal method for testing
     */
    function getStringURI(uint256 tokenId) public view returns (string memory) {
        return stringURI(tokenId);
    }
}

contract BaseTest is Test {
    PunksWrapperHelper test;
    ICryptoPunks punks;

    function setUp() public virtual {
        // specifying a fork block allows forge to cache rpc requests which greatly speeds up local tests
        vm.createSelectFork(vm.rpcUrl("mainnet"), 17781059);

        test = new PunksWrapperHelper();
        punks = test.PUNKS();
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
