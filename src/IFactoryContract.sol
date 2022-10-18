//SPDX-License-Identifier: UnLicensed
pragma solidity ^0.8.13;

interface IFactoryContrct {
	enum Spells {
        none,
        thunderbolt,
        iceSheild,
        wallOfThrons,
        divineFavor
    }

	function updateMana(uint256 tokenId, uint256 _mana) external;

	function updateLevel(uint256 tokenId) external;

	function changeSpell(uint256 tokenId, Spells _spell) external;

}