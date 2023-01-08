extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Speedy"
	description  = "1.5x Speed"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	var player = Globals.get_player()
	player.MAX_SPEED *= 1.5
	

