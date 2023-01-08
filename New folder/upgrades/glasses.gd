extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "20/20 vision"
	description  = "increased crit chance"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	Globals.get_player().get_node("Weapon").projectileCritChance += 0.25
	

