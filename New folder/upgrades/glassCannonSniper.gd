extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Glass Cannon Sniper"
	description  = "Triple your weapons damage and attack speed, but lose 3 health"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	var player = Globals.get_player()
	var weapon = player.get_node("Weapon")
	
	weapon.projectileDmg *= 3
	weapon.projectileSpeed *= 5
	player.MAX_HEALTH -= 3
	player.set_health(min(player.MAX_HEALTH, player.health))
	

