extends Control


onready var upgrade1 = $Upgrade1/Upgrade
onready var upgrade2 = $Upgrade2/Upgrade

func _ready():
	pass # Replace with function body.

func upgrade_chosen():
	print("upgrade chosen")
	Globals.paused = false
	LevelManager.startLevel()
	queue_free()
