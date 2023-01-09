extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	SoundFx.on_button_pressed()
	Globals.change_to_research()


func _on_Close_pressed():
	SoundFx.on_button_pressed()
	yield(get_tree().create_timer(SoundFx.SELECT_DURATION), "timeout")
	get_tree().quit()
