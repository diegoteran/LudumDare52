extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Rocket Man"
	description  = "High weapon speed but lower movement speed"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	var player = Globals.get_player()
	var weapon = player.get_node("Weapon")
	
	weapon.projectileSpeed += 200
	weapon.projectileAliveTime += 1
	player.MAX_SPEED *= 0.5
	

