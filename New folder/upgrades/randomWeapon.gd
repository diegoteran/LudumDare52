extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Random Weapon"
	description  = "This is probably bad, but maybe it'll be good?"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	var weapon = Globals.get_player().get_node("Weapon")
	
	weapon.projectileSpeed = rand_range(1,500)
	weapon.projectileDmg = rand_range(1,10)
	weapon.projectileAliveTime = rand_range(0.1,5)
	weapon.projectileCritDmg = rand_range(1,5)
	weapon.projectileCritChance = rand_range(0.1,0.7)
	weapon.fireRate = rand_range(0.1,1)
	weapon.spray = rand_range(0,180)
	weapon.automatic = rand_range(0,10) > 3
	weapon.projectileKnockback = rand_range(0,1000)
