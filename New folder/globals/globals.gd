extends Node

const WORLD_WIDTH = 1280
const WORLD_HEIGHT = 600

var player
var paused = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed("debug"):
		pass
	if Input.is_action_just_pressed("mute"):
		print("muting")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -500)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), -500)
	

func set_player(player_ref):
	player = player_ref
	# FIX THIS LATER
	LevelManager.startLevel()

func get_player():
	return player
	
func level_root():
	return get_tree().root

func level_ui():
	return level_root().get_node("world/UI")
