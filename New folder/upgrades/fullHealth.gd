extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Full Heal"
	description  = "fully heal your character"
	iconPath = "res://assets/art/programmerArt/health.png"
	.setValues()

func apply_upgrade():
	var player = Globals.get_player()
	player.set_health(player.MAX_HEALTH)
