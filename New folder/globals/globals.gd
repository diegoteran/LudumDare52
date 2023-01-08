extends Node

const WORLD_WIDTH = 1280
const WORLD_HEIGHT = 600

var player
var paused = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_player(player_ref):
	player = player_ref
	# FIX THIS LATER
	LevelManager.startLevel()

func get_player():
	return player
	
func level_root():
	return get_tree().root
