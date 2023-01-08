extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Hard Hitter"
	description  = "+ 3 Damage"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	Globals.get_player().get_node("Weapon").projectileDmg += 3
	

