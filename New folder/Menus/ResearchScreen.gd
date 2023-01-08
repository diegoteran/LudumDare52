extends Control


onready var bone_count = $Inventory/BoneCurrency/count
onready var skin_count = $Inventory/SkinCurrency/count
onready var blood_count = $Inventory/BloodCurrency/count
onready var tail_count = $Inventory/TailCurrency/count
onready var lung_count = $Inventory/LungCurrency/count
onready var heart_count = $Inventory/HeartCurrency/count

onready var armor_level = $"Stat Upgrades/ArmorUpgrade/currentLevel"
onready var health_level = $"Stat Upgrades/HealthUpgrade/currentLevel"
onready var heals_level = $"Stat Upgrades/HealsUpgrade/currentLevel"
onready var dash_level = $"Stat Upgrades/DashUpgrade/currentLevel"
onready var speed_level = $"Stat Upgrades/SpeedUpgrade/currentLevel"

onready var armor_cost = $"Stat Upgrades/ArmorUpgrade/cost"
onready var health_cost = $"Stat Upgrades/HealthUpgrade/cost"
onready var heals_cost = $"Stat Upgrades/HealsUpgrade/cost"
onready var dash_cost = $"Stat Upgrades/DashUpgrade/cost"
onready var speed_cost = $"Stat Upgrades/SpeedUpgrade/cost"

onready var armor_button = $"Stat Upgrades/ArmorUpgrade/Button"
onready var health_button = $"Stat Upgrades/HealthUpgrade/Button"
onready var heals_button = $"Stat Upgrades/HealsUpgrade/Button"
onready var dash_button = $"Stat Upgrades/DashUpgrade/Button"
onready var speed_button = $"Stat Upgrades/SpeedUpgrade/Button"

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
	
	armor_level.text = str(ResearchManager.armor_upgrades)
	health_level.text = str(ResearchManager.health_upgrades)
	heals_level.text = str(ResearchManager.health_regen_upgrades)
	dash_level.text = str(ResearchManager.dash_upgrades)
	speed_level.text = str(ResearchManager.speed_upgrades)
	
	armor_cost.text = str(ResearchManager.ARMOR_COST[min(ResearchManager.armor_upgrades, len(ResearchManager.ARMOR_COST)-1)])
	health_cost.text = str(ResearchManager.HEALTH_COST[min(ResearchManager.health_upgrades, len(ResearchManager.HEALTH_COST)-1)])
	heals_cost.text = str(ResearchManager.HEALTH_REGEN_COST[min(ResearchManager.health_regen_upgrades, len(ResearchManager.HEALTH_REGEN_COST)-1)])
	dash_cost.text = str(ResearchManager.DASH_COST[min(ResearchManager.dash_upgrades, len(ResearchManager.DASH_COST)-1)])
	speed_cost.text = str(ResearchManager.SPEED_COST[min(ResearchManager.speed_upgrades, len(ResearchManager.SPEED_COST)-1)])
	
	armor_button.disabled = (ResearchManager.ARMOR_COST[min(ResearchManager.armor_upgrades, len(ResearchManager.ARMOR_COST)-1)] > ResearchManager.bones)
	health_button.disabled = (ResearchManager.HEALTH_COST[min(ResearchManager.health_upgrades, len(ResearchManager.HEALTH_COST)-1)] > ResearchManager.slime_skin)
	heals_button.disabled = (ResearchManager.HEALTH_REGEN_COST[min(ResearchManager.health_regen_upgrades, len(ResearchManager.HEALTH_REGEN_COST)-1)] > ResearchManager.blood_bags)
	dash_button.disabled = (ResearchManager.DASH_COST[min(ResearchManager.dash_upgrades, len(ResearchManager.DASH_COST)-1)] > ResearchManager.scorpion_tails)
	speed_button.disabled = (ResearchManager.SPEED_COST[min(ResearchManager.speed_upgrades, len(ResearchManager.SPEED_COST)-1)] > ResearchManager.puffer_lungs)

	for button in [armor_button, health_button, heals_button, dash_button, speed_button]:
		if button.disabled:
			button.text = "NOT ENOUGH"
		else:
			button.text = "PURCHASE"

func _on_Button_pressed():
	Globals.change_to_dungeon()


func _on_health_button_pressed():
	ResearchManager.slime_skin -= ResearchManager.HEALTH_COST[min(ResearchManager.health_upgrades, len(ResearchManager.HEALTH_COST)-1)]
	ResearchManager.health_upgrades += 1
	update_values()
	pass # Replace with function body.


func _on_speed_button_pressed():
	ResearchManager.puffer_lungs -= ResearchManager.SPEED_COST[min(ResearchManager.speed_upgrades, len(ResearchManager.SPEED_COST)-1)]
	ResearchManager.speed_upgrades += 1
	update_values()
	pass # Replace with function body.


func _on_heals_button_pressed():
	ResearchManager.blood_bags -= ResearchManager.HEALTH_REGEN_COST[min(ResearchManager.health_regen_upgrades, len(ResearchManager.HEALTH_REGEN_COST)-1)]
	ResearchManager.health_regen_upgrades += 1
	update_values()
	pass # Replace with function body.


func _on_armor_button_pressed():
	ResearchManager.bones -= ResearchManager.ARMOR_COST[min(ResearchManager.armor_upgrades, len(ResearchManager.ARMOR_COST)-1)]
	ResearchManager.armor_upgrades += 1
	update_values()
	pass # Replace with function body.


func _on_dash_button_pressed():
	ResearchManager.scorpion_tails -= ResearchManager.DASH_COST[min(ResearchManager.dash_upgrades, len(ResearchManager.DASH_COST)-1)]
	ResearchManager.dash_upgrades += 1
	update_values()
	pass # Replace with function body.
