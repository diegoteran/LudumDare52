extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Sniper Scope"
	description  = "Increase weapon range and speed"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	var player = Globals.get_player()
	var weapon = player.get_node("Weapon")
	
	weapon.projectileAliveTime += 1
	weapon.projectileSpeed += 300
	

