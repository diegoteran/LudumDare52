extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Full Heal"
	description  = "fully heal your character"
	iconPath = "res://assets/art/programmerArt/health.png"
	.setValues()

func apply_upgrade():
	print("Lets heal")
