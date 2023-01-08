extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "I'm a betting man"
	description  = "increased crit damage"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	Globals.get_player().get_node("Weapon").projectileCritDmg += 3
	

