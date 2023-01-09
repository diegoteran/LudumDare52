extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Sticky Rocket"
	description  = "You can't walk but you can DASH"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	var player = Globals.get_player()
	player.DASH_COOLDOWN = 0.1
	player.MAX_SPEED = 20
	player.MAX_DASH = 20
	player.dashes = 20
	

