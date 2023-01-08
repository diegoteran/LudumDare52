extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Hardy"
	description  = "1.5x Max Health, Also heals to full"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	var player = Globals.get_player()
	player.MAX_HEALTH *= 1.5
	player.set_health(player.MAX_HEALTH)
	

