// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract SpellStriker is ERC721 {
    // spells to choose when preparing for duel
    enum Spells {
        none,
        thunderbolt,
        iceSheild,
        wallOfThrons,
        divineFavor
    }
    // players attributes
    struct Spell_Stricker {
        string name;
        uint256 power;
        uint256 resistance;
        uint256 mana;
        Spells spell;
        uint256 level;
    }

    address gameLogicAddress; // The address of the game logic;
    mapping(uint256 => Spell_Stricker) private players; //Mapping that stores players details

    uint256 tokenID; //Assigns unique ID to the NFT

	/**
	 * @notice Emitted when a new player mints an NFT
	 * @param to The address where NFT is minted
	 * @param tokenId The unique Id of the newly minted NFT
	 * @param name_ Name of the player			
	 */
    event NewPlayerAdded(
        address indexed to,
        uint256 indexed tokenId,
        string name_
    );

	/**
	 * @notice Emitted when mana is updated of a particular NFT
	 * @param tokenId The ID of the NFT
	 * @param _mana The amount of mana added
	 */
    event ManaUpdated(uint256 indexed tokenId, uint256 _mana);

	/**
     * @notice Emitted when level of player is upgraded
	 * @param tokenId The ID of the NFT
	 * @param upgradedTo The upgraded level
	 */
	event LevelUpdated(uint256 indexed tokenId, uint256 indexed upgradedTo);

	/**
	 * @notice Used to check if the function marked with modifier called by the game logic contract
	 */
    modifier onlyByGameLogicContract() {
        require(msg.sender == gameLogicAddress, "ONLY_BY_GAMELOGIC");
        _;
    }

	/**
     * @notice Initializes the the contract with necessary variables
	 * @param gameLogicAddress_ The address of the game logic contract
	 */
    constructor(address gameLogicAddress_) ERC721("Spell_Striker", "SP") {
        gameLogicAddress = gameLogicAddress_;
    }

	/**
	 * @notice Add new player to the game
	 * @dev Mints new NFT added assigns its attributes
	 * @param name_ The name of the player 
	 */
    function mintNFT(string calldata name_) external {
        tokenID++;
        uint256 _power = _generateRandomNumber();
        uint256 _resistance = _generateRandomNumber();
        Spell_Stricker memory _spellStriker = Spell_Stricker(
            name_,
            _power,
            _resistance,
            0,
            Spells.none,
            1
        );
        players[tokenID] = _spellStriker;

        _safeMint(msg.sender, tokenID);

        emit NewPlayerAdded(msg.sender, tokenID, name_);
    }

    /**
     * @notice Used to update the mana of a particular NFT
     * @param tokenId The unique Id of a particular NFT
     */
    function updateMana(uint256 tokenId, uint256 _mana)
        external
        onlyByGameLogicContract
    {
        players[tokenId].mana += _mana;

        emit ManaUpdated(tokenId, _mana);
    }

    /**
     * @notice Used to change the level of a particlular NFT
     * @param tokenId The unique Id of a particular NFT
     */
    function updateLevel(uint256 tokenId) external onlyByGameLogicContract {
        players[tokenId].level++;

		emit LevelUpdated(tokenId, players[tokenId].level);
    }

    /**
     * @notice used to change the Spell of a particular NFT
     * @param tokenId The unique Id of a particular NFT
     * @param _spell The type of Spells
     */

    function changeSpell(uint256 tokenId, Spells _spell)
        external
        onlyByGameLogicContract
    {
        players[tokenId].spell = _spell;
    }

    /**
     * @notice Used to get Attributes of a particular NFT
     * @param tokenId The unique Id of a particular NFT
     */
    function getPlayerAttribute(uint256 tokenId)
        external
        view
        returns (Spell_Stricker memory)
    {
        return players[tokenId];
    }

    /**
     * @notice Used to generate Random number between 1-50 for Power and resistance;
     * @dev Since blockchain is deterministic generating this way is not secure. Just we are using
     * for learning purpose only
     * Generates Same random for resistance and power.
     */
    function _generateRandomNumber() private view returns (uint256) {
        return
            uint(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        msg.sender
                    )
                )
            ) % 50;
    }
}
