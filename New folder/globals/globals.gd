extends Node

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_player(player_ref):
	player = player_ref

func get_player():
	return player