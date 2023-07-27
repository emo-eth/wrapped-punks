// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ICryptoPunks} from "./interfaces/ICryptoPunks.sol";
import {PunksWrapperMetadata} from "./PunksWrapperMetadata.sol";

/**
 * @title  PunksWrapper
 * @author James Wenzel (emo.eth)
 * @notice ERC721 wrapper for CryptoPunks. Uses 0-ether private sales as a form of "approval" to more safely wrap Punks.
 *         Uses the CryptopunksData contract to fetch metadata for the wrapped Punks fully onchain.
 */
contract PunksWrapper is PunksWrapperMetadata {
    ///@dev Used when a user attempts to wrap a punk they do not own.
    error NotPunkOwner();

    ICryptoPunks public constant PUNKS = ICryptoPunks(0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB);

    function name() public pure override returns (string memory) {
        return "Wrapped CryptoPunks";
    }

    function symbol() public pure override returns (string memory) {
        return unicode"WϾ";
    }

    /**
     * @notice Wrap a CryptoPunk. Requires that the user has set a 0-ether private sale for the wrapper contract by
     *         calling offerPunkForSaleToAddress(punkIndex, 0, address(this)) before wrapping. Users should take care
     *         to validate that the address they are creating the private sale for is the address of the wrapper and not
     *         a phishing scam.
     * @param punkIndex The index of the punk to wrap
     */
    function wrapPunk(uint256 punkIndex) public {
        address owner = PUNKS.punkIndexToAddress(punkIndex);
        if (owner != msg.sender) {
            revert NotPunkOwner();
        }
        PUNKS.buyPunk(punkIndex);
        _mint(msg.sender, punkIndex);
    }

    /**
     * @notice Unwrap a CryptoPunk. Requires that the caller owns or is approved to transfer the wrapped CryptoPunk.
     * @param punkIndex The index of the punk to unwrap
     * @param to The address to transfer the unwrapped punk to
     */
    function unwrapPunk(uint256 punkIndex, address to) public {
        address owner = ownerOf(punkIndex);
        if (owner != msg.sender) {
            if (!isApprovedForAll(owner, msg.sender)) {
                if (getApproved(punkIndex) != msg.sender) {
                    revert NotOwnerNorApproved();
                }
            }
        }
        PUNKS.transferPunk(to, punkIndex);
        _burn(punkIndex);
    }
}
