extends "res://UpgradesAndMenus/upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Random Weapon"
	description  = "Lets get wacky"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues();

func apply_upgrade():
	print("this is going to be wild");
