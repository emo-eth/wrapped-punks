pragma solidity ^0.8.10;

interface CryptopunksData {
    function addAsset(uint8 index, bytes memory encoding, string memory name) external;
    function addComposites(
        uint64 key1,
        uint32 value1,
        uint64 key2,
        uint32 value2,
        uint64 key3,
        uint32 value3,
        uint64 key4,
        uint32 value4
    ) external;
    function addPunks(uint8 index, bytes memory _punks) external;
    function punkAttributes(uint16 index) external view returns (string memory text);
    function punkImage(uint16 index) external view returns (bytes memory);
    function punkImageSvg(uint16 index) external view returns (string memory svg);
    function sealContract() external;
    function setPalette(bytes memory _palette) external;
}

