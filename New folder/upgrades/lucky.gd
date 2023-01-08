extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Lucky"
	description  = "Increased chance for enemies to drop resources"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	var player = Globals.get_player()
	Globals.luck += 0.15
	

