extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Lucky"
	description  = "Higher chance for enemies to drop resources"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	Globals.luck += 0.1
	

