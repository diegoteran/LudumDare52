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
		Globals.get_player().get_node("Weapon").projectileDmg = 10000
		Globals.get_player().get_node("Weapon").automatic = true
		Globals.get_player().get_node("Weapon").fireRate = 0.001
		Globals.get_player().get_node("Weapon").projectileAliveTime = 3
		Globals.get_player().get_node("Weapon").projectileSpeed = 1000
		Globals.get_player().get_node("Weapon").spray = 360
		pass
	if Input.is_action_just_pressed("mute"):
		print("muting")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -500)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), -500)
	

func set_player(player_ref):
	player = player_ref
	# FIX THIS LATER
	LevelManager.startNewRun()

func get_player():
	return player
	
func level_root():
	return get_tree().root

func level_ui():
	return level_root().get_node("world/UI")

func change_to_research():
	get_tree().change_scene("res://menus/ResearchScreen.tscn")

func change_to_run_end():
	get_tree().change_scene("res://menus/RunOverScreen.tscn")

func change_to_dungeon():
	get_tree().change_scene("res://world/world.tscn")
