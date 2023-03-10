extends "res://upgrades/UpgradeBase.gd"

func setValues():
	upgradeName = "Slip n Slide"
	description  = "Increased speed but decreased friction"
	iconPath = "res://assets/art/programmerArt/greenHealthIGuess.png"
	.setValues()

func apply_upgrade():
	var player = Globals.get_player()
	var weapon = player.get_node("Weapon")
	
	player.MAX_SPEED +=  player.MAX_SPEED * 0.5
	player.FRICTION -= player.FRICTION * 0.2
	player.FRICTION = max(player.FRICTION, 200)
	

