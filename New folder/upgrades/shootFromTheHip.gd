extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Shoot from the hip"
	description  = "Double your damage and increased range but attack with higher spread"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	var player = Globals.get_player()
	var weapon = player.get_node("Weapon")
	
	weapon.projectileDmg += weapon.projectileDmg * 0.5
	weapon.projectileSpeed += weapon.projectileSpeed * 0.8
	weapon.projectileAliveTime += 0.4
	weapon.spray += 30
	

