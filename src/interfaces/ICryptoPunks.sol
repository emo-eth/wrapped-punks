// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface ICryptoPunks {
    event Assign(address indexed to, uint256 punkIndex);
    event PunkBidEntered(uint256 indexed punkIndex, uint256 value, address indexed fromAddress);
    event PunkBidWithdrawn(uint256 indexed punkIndex, uint256 value, address indexed fromAddress);
    event PunkBought(uint256 indexed punkIndex, uint256 value, address indexed fromAddress, address indexed toAddress);
    event PunkNoLongerForSale(uint256 indexed punkIndex);
    event PunkOffered(uint256 indexed punkIndex, uint256 minValue, address indexed toAddress);
    event PunkTransfer(address indexed from, address indexed to, uint256 punkIndex);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function acceptBidForPunk(uint256 punkIndex, uint256 minPrice) external;
    function allInitialOwnersAssigned() external;
    function allPunksAssigned() external returns (bool);
    function balanceOf(address) external returns (uint256);
    function buyPunk(uint256 punkIndex) external;
    function decimals() external returns (uint8);
    function enterBidForPunk(uint256 punkIndex) external;
    function getPunk(uint256 punkIndex) external;
    function imageHash() external returns (string memory);
    function name() external returns (string memory);
    function nextPunkIndexToAssign() external returns (uint256);
    function offerPunkForSale(uint256 punkIndex, uint256 minSalePriceInWei) external;
    function offerPunkForSaleToAddress(uint256 punkIndex, uint256 minSalePriceInWei, address toAddress) external;
    function pendingWithdrawals(address) external returns (uint256);
    function punkBids(uint256) external returns (bool hasBid, uint256 punkIndex, address bidder, uint256 value);
    function punkIndexToAddress(uint256) external returns (address);
    function punkNoLongerForSale(uint256 punkIndex) external;
    function punksOfferedForSale(uint256)
        external
        returns (bool isForSale, uint256 punkIndex, address seller, uint256 minValue, address onlySellTo);
    function punksRemainingToAssign() external returns (uint256);
    function setInitialOwner(address to, uint256 punkIndex) external;
    function setInitialOwners(address[] memory addresses, uint256[] memory indices) external;
    function standard() external returns (string memory);
    function symbol() external returns (string memory);
    function totalSupply() external returns (uint256);
    function transferPunk(address to, uint256 punkIndex) external;
    function withdraw() external;
    function withdrawBidForPunk(uint256 punkIndex) external;
}
