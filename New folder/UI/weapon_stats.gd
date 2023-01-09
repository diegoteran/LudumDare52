extends Control

onready var skin_count = $Inventory/SkinCurrency/count
onready var blood_count = $Inventory/BloodCurrency/count
onready var tail_count = $Inventory/TailCurrency/count
onready var lung_count = $Inventory/LungCurrency/count

onready var weapon_name = $WeaponStats/title
onready var dmg = $WeaponStats/Dmg/count
onready var crit_dmg = $WeaponStats/CritDmg/count
onready var crit_chance = $WeaponStats/CritChance/count
onready var weapon_speed = $WeaponStats/WeaponSpeed/count
onready var fire_rate = $WeaponStats/FireRate/count

onready var health = $PlayerStats/MaxHealth/count
onready var heals = $PlayerStats/Heals/count
onready var speed = $PlayerStats/Speed/count

func _process(delta):
	if visible:
		update_inv()
		update_weapon()
		update_player_stats()
	
	if Input.is_action_just_pressed("show_stats"):
		visible = !visible;

func update_inv():
	skin_count.text = str(ResearchManager.slime_skin)
	blood_count.text = str(ResearchManager.blood_bags)
	tail_count.text = str(ResearchManager.scorpion_tails)
	lung_count.text = str(ResearchManager.puffer_lungs)
	
func update_weapon():
	weapon_name.text = Globals.weapon
	var weapon = Globals.get_player().get_node("Weapon")
	dmg.text = str(weapon.projectileDmg)
	crit_dmg.text = str(weapon.projectileCritDmg)
	crit_chance.text = str(100*weapon.projectileCritChance) + "%"
	weapon_speed.text = str(weapon.projectileSpeed)
	fire_rate.text = str(1/weapon.fireRate) + "/s"

func update_player_stats():
	var player = Globals.get_player()
	health.text = str(player.MAX_HEALTH)
	heals.text = str(player.HEALTH_REGEN)
	speed.text = str(player.MAX_SPEED)
	
