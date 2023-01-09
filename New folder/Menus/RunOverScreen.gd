extends Control


onready var kill_count = $KillStat/stat
onready var time_count = $TimeStat/stat

onready var win = $victory
onready var lose = $lose

onready var winColor = $winColor
onready var loseColor = $loseColor

# Called when the node enters the scene tree for the first time.
func _ready():

	update_values()
	
	if Globals.dungeonWin:
		SoundFx.play_menu("victory_cadence")
		win.visible = true
		winColor.visible = true
	else:
		SoundFx.play_menu("game_over_cadence")
		lose.visible = true
		loseColor.visible = true
	
	pass # Replace with function body.

func update_values():
	kill_count.text = str(LevelManager.total_killed)
	time_count.text = str(LevelManager.total_time)


func _on_Button_pressed():
	Globals.change_to_research()
