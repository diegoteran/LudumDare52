extends Control

# INVENTORY:
onready var skin_count = $Inventory/SkinCurrency/count
onready var blood_count = $Inventory/BloodCurrency/count
onready var tail_count = $Inventory/TailCurrency/count
onready var lung_count = $Inventory/LungCurrency/count
onready var heart_count = $Inventory/HeartCurrency/count

# STAT UPGRADES:
onready var health_level = $"Stat Upgrades/HealthUpgrade/currentLevel"
onready var heals_level = $"Stat Upgrades/HealsUpgrade/currentLevel"
onready var dash_level = $"Stat Upgrades/DashUpgrade/currentLevel"
onready var speed_level = $"Stat Upgrades/SpeedUpgrade/currentLevel"

onready var health_cost = $"Stat Upgrades/HealthUpgrade/cost"
onready var heals_cost = $"Stat Upgrades/HealsUpgrade/cost"
onready var dash_cost = $"Stat Upgrades/DashUpgrade/cost"
onready var speed_cost = $"Stat Upgrades/SpeedUpgrade/cost"

onready var health_button = $"Stat Upgrades/HealthUpgrade/Button"
onready var heals_button = $"Stat Upgrades/HealsUpgrade/Button"
onready var dash_button = $"Stat Upgrades/DashUpgrade/Button"
onready var speed_button = $"Stat Upgrades/SpeedUpgrade/Button"

# WEAPON UPGRADES
onready var scalpel_level = $"Weapon Upgrades/ScalpelGun/currentLevel"
onready var scalpel_level_label = $"Weapon Upgrades/ScalpelGun/levelLabel"
onready var scalpel_locked = $"Weapon Upgrades/ScalpelGun/lockedLabel"
onready var scalpel_equip = $"Weapon Upgrades/ScalpelGun/equip"

onready var slime_gun_level = $"Weapon Upgrades/SlimeGun/currentLevel"
onready var slime_gun_level_label = $"Weapon Upgrades/SlimeGun/levelLabel"
onready var slime_gun_locked = $"Weapon Upgrades/SlimeGun/lockedLabel"
onready var slime_gun_equip = $"Weapon Upgrades/SlimeGun/equip"

onready var stat_upgrades = $"Stat Upgrades"
onready var weapon_upgrades = $"Weapon Upgrades"
onready var swap_button = $SwapButton

# Called when the node enters the scene tree for the first time.
func _ready():
	update_values()
	pass # Replace with function body.

func update_values():
	skin_count.text = str(ResearchManager.slime_skin)
	blood_count.text = str(ResearchManager.blood_bags)
	tail_count.text = str(ResearchManager.scorpion_tails)
	lung_count.text = str(ResearchManager.puffer_lungs)
	
	health_level.text = str(ResearchManager.health_upgrades)
	heals_level.text = str(ResearchManager.health_regen_upgrades)
	dash_level.text = str(ResearchManager.dash_upgrades)
	speed_level.text = str(ResearchManager.speed_upgrades)
	
	health_cost.text = str(ResearchManager.HEALTH_COST[min(ResearchManager.health_upgrades, len(ResearchManager.HEALTH_COST)-1)])
	heals_cost.text = str(ResearchManager.HEALTH_REGEN_COST[min(ResearchManager.health_regen_upgrades, len(ResearchManager.HEALTH_REGEN_COST)-1)])
	dash_cost.text = str(ResearchManager.DASH_COST[min(ResearchManager.dash_upgrades, len(ResearchManager.DASH_COST)-1)])
	speed_cost.text = str(ResearchManager.SPEED_COST[min(ResearchManager.speed_upgrades, len(ResearchManager.SPEED_COST)-1)])
	
	health_button.disabled = (ResearchManager.HEALTH_COST[min(ResearchManager.health_upgrades, len(ResearchManager.HEALTH_COST)-1)] > ResearchManager.slime_skin)
	heals_button.disabled = (ResearchManager.HEALTH_REGEN_COST[min(ResearchManager.health_regen_upgrades, len(ResearchManager.HEALTH_REGEN_COST)-1)] > ResearchManager.blood_bags)
	dash_button.disabled = (ResearchManager.DASH_COST[min(ResearchManager.dash_upgrades, len(ResearchManager.DASH_COST)-1)] > ResearchManager.scorpion_tails)
	speed_button.disabled = (ResearchManager.SPEED_COST[min(ResearchManager.speed_upgrades, len(ResearchManager.SPEED_COST)-1)] > ResearchManager.puffer_lungs)

	for button in [health_button, heals_button, dash_button, speed_button]:
		if button.disabled:
			button.text = "NOT ENOUGH"
		else:
			button.text = "PURCHASE"

	if ResearchManager.slime_gun_level == 0:
		slime_gun_locked.visible = true
		slime_gun_level.visible = false
		slime_gun_level_label.visible = false
		slime_gun_equip.visible = false
	else:
		slime_gun_locked.visible = false
		slime_gun_level.visible = true
		slime_gun_level_label.visible = true
		slime_gun_level.text = str(ResearchManager.slime_gun_level)
		slime_gun_equip.visible = true

	if ResearchManager.scalpel_level == 0:
		scalpel_locked.visible = true
		scalpel_level.visible = false
		scalpel_level_label.visible = false
		scalpel_equip.visible = false
	else:
		scalpel_locked.visible = false
		scalpel_level.visible = true
		scalpel_level_label.visible = true
		scalpel_level.text = str(ResearchManager.scalpel_level)
		scalpel_equip.visible = true

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


func _on_dash_button_pressed():
	ResearchManager.scorpion_tails -= ResearchManager.DASH_COST[min(ResearchManager.dash_upgrades, len(ResearchManager.DASH_COST)-1)]
	ResearchManager.dash_upgrades += 1
	update_values()
	pass # Replace with function body.


func _on_SwapButton_pressed():
	stat_upgrades.visible = !stat_upgrades.visible
	weapon_upgrades.visible = !weapon_upgrades.visible
	
	var text = "Swap to weapon screen"
	if !stat_upgrades.visible:
		text = "Swap to stat screen"
	swap_button.text = text
	pass # Replace with function body.


func _on_scalpel_buyButton_pressed():
	ResearchManager.scorpion_tails -= ResearchManager.TAIL_COST[min(ResearchManager.scalpel_level, len(ResearchManager.TAIL_COST)-1)]
	ResearchManager.scalpel_level += 1
	update_values()
	pass # Replace with function body.


func _on_slimegun_buyButton_pressed():
	ResearchManager.slime_skin -= ResearchManager.SLIME_COST[min(ResearchManager.slime_gun_level, len(ResearchManager.SLIME_COST)-1)]
	ResearchManager.slime_gun_level += 1
	update_values()
	pass # Replace with function body.


func _on_slime_equip_pressed():
	if ResearchManager.slime_gun_level <= 0:
		return
	Globals.weapon = "slimegun"
	pass # Replace with function body.


func _on_scalpel_equip_pressed():
	if ResearchManager.scalpel_level <= 0:
		return
	Globals.weapon = "scalpel"
	pass # Replace with function body.
