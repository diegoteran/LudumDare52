extends Control


onready var bone_count = $BoneCurrency/count
onready var skin_count = $SkinCurrency/count
onready var blood_count = $BloodCurrency/count
onready var tail_count = $TailCurrency/count
onready var lung_count = $LungCurrency/count
onready var heart_count = $HeartCurrency/count

# Called when the node enters the scene tree for the first time.
func _ready():
	update_values()
	pass # Replace with function body.

func update_values():
	bone_count.text = str(ResearchManager.bones)
	skin_count.text = str(ResearchManager.slime_skin)
	blood_count.text = str(ResearchManager.blood_bags)
	tail_count.text = str(ResearchManager.scorpion_tails)
	lung_count.text = str(ResearchManager.puffer_lungs)
	heart_count.text = str(ResearchManager.boss_hearts)


func _on_Button_pressed():
	Globals.change_to_dungeon()
