// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.8.17;

/**
 * @dev The ERC20 Factory contract's address.
 */
address constant ERC20_FACTORY_PRECOMPILE_ADDRESS = 0x0000000000000000000000000000000000000900;

/**
 * @dev The ERC20 Factory contract's instance.
 */
IERC20Factory constant ERC20_FACTORY_CONTRACT = IERC20Factory(
    ERC20_FACTORY_PRECOMPILE_ADDRESS
);

interface IERC20Factory {
    /**
     * @dev Emitted when a new ERC20 token is created.
     * @param tokenAddress The address of the ERC20 token.
     * @param tokenPairType The type of token pair.
     * @param salt The salt used for deployment.
     * @param name The name of the token.
     * @param symbol The symbol of the token.
     * @param decimals The decimals of the token.
     */
    event Create(
        address indexed tokenAddress,
        uint8 tokenPairType,
        bytes32 salt,
        string name,
        string symbol,
        uint8 decimals
    );

    /**
     * @dev Emitted when a new ERC20 token is minted.
     * @param tokenAddress The address of the ERC20 token.
     * @param minter The address of the minter.
     * @param mintTo The address of the minted token.
     * @param amount The amount of tokens minted.
     */
    event Mint(
        address indexed tokenAddress,
        address indexed minter,
        address indexed mintTo,
        uint256 amount
    );

    /**
     * @dev Emitted when a new ERC20 token is burned.
     * @param tokenAddress The address of the ERC20 token.
     * @param burner The address of the burner.
     * @param burnFrom The address of the burned token.
     * @param amount The amount of tokens burned.
     */
    event Burn(
        address indexed tokenAddress,
        address indexed burner,
        address indexed burnFrom,
        uint256 amount
    );

    /**
     * @dev Defines a method for creating an ERC20 token.
     * @param tokenPairType Token Pair type
     * @param salt Salt used for deployment
     * @param name The name of the token.
     * @param symbol The symbol of the token.
     * @param decimals the decimals of the token.
     * @return tokenAddress The ERC20 token address.
     */
    function create(
        uint8 tokenPairType,
        bytes32 salt,
        string memory name,
        string memory symbol,
        uint8 decimals
    ) external returns (address tokenAddress);

    /**
     * @dev Mints a new ERC20 token.
     * @param tokenAddress The address of the ERC20 token.
     * @param mintTo The address of the minted token.
     * @param amount The amount of tokens minted.
     */
    function mint(
        address tokenAddress,
        address mintTo,
        uint256 amount
    ) external returns (bool success);

    /**
     * @dev Burns a new ERC20 token.
     * @param tokenAddress The address of the ERC20 token.
     * @param burnFrom The address of the burned token.
     * @param amount The amount of tokens burned.
     */
    function burn(
        address tokenAddress,
        address burnFrom,
        uint256 amount
    ) external returns (bool success);

    /**
     * @dev Pauses a new ERC20 token.
     * @param tokenAddress The address of the ERC20 token.
     */
    function pause(address tokenAddress) external returns (bool success);

    /**
     * @dev Unpauses a new ERC20 token.
     * @param tokenAddress The address of the ERC20 token.
     */
    function unpause(address tokenAddress) external returns (bool success);

    /**
     * @dev Calculates the deterministic address for a new token.
     * @param tokenPairType Token Pair type
     * @param salt Salt used for deployment
     * @return tokenAddress The calculated ERC20 token address.
     */
    function calculateAddress(
        uint8 tokenPairType,
        bytes32 salt
    ) external view returns (address tokenAddress);

    /**
     * @dev Updates the minter lists for a new token.
     * @param tokenAddress The address of the ERC20 token.
     * @param minters The addresses of the minters.
     * @param isAdded Whether the minters are added or removed.
     * @return success Whether the update was successful.
     */
    function updateMinterLists(
        address tokenAddress,
        address[] calldata minters,
        bool[] calldata isAdded
    ) external returns (bool success);

    /**
     * @dev Updates the burner lists for a new token.
     * @param tokenAddress The address of the ERC20 token.
     * @param burners The addresses of the burners.
     * @param isAdded Whether the burners are added or removed.
     * @return success Whether the update was successful.
     */
    function updateBurnerLists(
        address tokenAddress,
        address[] calldata burners,
        bool[] calldata isAdded
    ) external returns (bool success);

    /**
     * @dev Updates the pauser lists for a new token.
     * @param tokenAddress The address of the ERC20 token.
     * @param pausers The addresses of the pausers.
     * @param isAdded Whether the pausers are added or removed.
     * @return success Whether the update was successful.
     */
    function updatePauserLists(
        address tokenAddress,
        address[] calldata pausers,
        bool[] calldata isAdded
    ) external returns (bool success);

    /**
     * @dev Updates the owner of a new token.
     * @param tokenAddress The address of the ERC20 token.
     * @param newOwner The address of the new owner.
     * @return success Whether the update was successful.
     */
    function updateOwner(
        address tokenAddress,
        address newOwner
    ) external returns (bool success);
}
