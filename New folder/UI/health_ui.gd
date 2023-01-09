extends Control

onready var texture = $CenterContainer/TextureRect
# Called when the node enters the scene tree for the first time.
func _ready():
	var player = Globals.get_player()
	player.connect("health_changed", self, "set_hp")
	set_hp(player.health)

func set_hp(value):
	print("setting to " + str(value))
	texture.rect_size.x = texture.texture.get_size().x * value
