extends Node

const WORLD_WIDTH = 1280
const WORLD_HEIGHT = 600

var player

var paused = false;
var luck = 0

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
	LevelManager.startNewRun()
	

func get_player():
	return player
	
func level_root():
	return get_tree().root

func level_ui():
	return level_root().get_node("world/UI")

func level_camera():
	if level_root().has_node("world"):
		return level_root().get_node("world/Camera2D")
	return null

func clear_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.queue_free()
	pass

func clear_projectiles():
	var projectiles = get_tree().get_nodes_in_group("projectile")
	for projectile in projectiles:
		projectile.queue_free()

func clear_pickups():
	var pickups = get_tree().get_nodes_in_group("pickup")
	for pickup in pickups:
		pickup.queue_free()
	LevelManager.pickup_count = 0

func clear_entities():
	clear_enemies()
	clear_pickups()
	clear_projectiles()

func change_to_research():
	clear_entities()
	Globals.paused = true
	get_tree().change_scene("res://menus/ResearchScreen.tscn")

func change_to_run_end():
	clear_entities()
	Globals.paused = true
	get_tree().change_scene("res://menus/RunOverScreen.tscn")

func change_to_dungeon():
	clear_entities()
	get_tree().change_scene("res://world/world.tscn")
