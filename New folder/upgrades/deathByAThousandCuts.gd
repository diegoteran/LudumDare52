extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Death by 1000 cuts"
	description  = "1/10 damage but much faster firerate at full auto"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	var weapon = Globals.get_player().get_node("Weapon")
	weapon.fireRate = 0.1
	weapon.projectileDmg *= 0.25
	

