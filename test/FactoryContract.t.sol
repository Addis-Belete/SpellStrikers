// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/FactoryContract.sol";

contract SpellStrikerTest is Test {
    SpellStriker public spell_striker;

	event NewPlayerAdded(address indexed to, uint256 indexed tokenId, string name_ );
	event ManaUpdated(uint256 indexed tokenID, uint256 _mana);
	event LevelUpdated(uint256 indexed tokenId, uint256 indexed upgradedTo);
    function setUp() public {
		address gameLogicContractAddress = address(50);

        spell_striker = new SpellStriker(gameLogicContractAddress);
    }

	function mintNFT() internal {
		vm.startPrank(address(10));

		spell_striker.mintNFT("player_one");

		vm.stopPrank();
	}

	function testMintNFT() public {
		vm.startPrank(address(10));

		vm.expectEmit(true, true, false, true);

		emit NewPlayerAdded(address(10), 1, "player_one");

		spell_striker.mintNFT("player_one");

		SpellStriker.Spell_Stricker memory player1 = spell_striker.getPlayerAttribute(1);
 
		assertEq(player1.mana, 0);

		
	}
    
	function testUpdateMana() external {
		mintNFT();

		vm.startPrank(address(50));

		vm.expectEmit(true, false, false, true);

		emit ManaUpdated(1, 5);

		spell_striker.updateMana(1, 5);

		SpellStriker.Spell_Stricker memory player1 = spell_striker.getPlayerAttribute(1);

		assertEq(player1.mana, 5);
	}

	function testFailManaupdate() external {
		mintNFT();

		vm.startPrank(address(40));

		vm.expectRevert("ONLY_BY_GAMELOGIC");

	}

	function testLevelUpdate() public {
		mintNFT();

		vm.startPrank(address(50));

		vm.expectEmit(true, true, false, false);

		emit LevelUpdated(1, 2);

		spell_striker.updateLevel(1);

		SpellStriker.Spell_Stricker memory player1 = spell_striker.getPlayerAttribute(1);

		assertEq(player1.level, 2);
	}

	function testFailLevelUpdate() public {
		mintNFT();

		vm.startPrank(address(30));

		spell_striker.updateLevel(1);

		vm.expectRevert("ONLY_BY_GAMELOGIC");

	}
}
