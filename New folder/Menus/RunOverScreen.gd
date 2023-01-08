extends Control


onready var kill_count = $KillStat/stat
onready var time_count = $TimeStat/stat

# Called when the node enters the scene tree for the first time.
func _ready():
	update_values()
	pass # Replace with function body.

func update_values():
	kill_count.text = str(LevelManager.total_killed)
	time_count.text = str(LevelManager.total_time)



func _on_Button_pressed():
	Globals.change_to_research()
