extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Photosynthesis"
	description  = "Increase you health regen (happens at the start of each round)"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	var player = Globals.get_player()
	player.HEALTH_REGEN += 2
	

