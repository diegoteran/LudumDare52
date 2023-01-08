extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Shoot from the hip"
	description  = "Double your damage but increase spread by 50%"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	var player = Globals.get_player()
	var weapon = player.get_node("Weapon")
	
	weapon.projectileDmg *= 2
	weapon.spray *= 1.5
	

