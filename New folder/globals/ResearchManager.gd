extends Node

var slime_skin = 0
var puffer_lungs = 0
var blood_bags = 0
var scorpion_tails = 0
var bones = 0
var boss_hearts = 0

var slime_gun_level = 0
var blow_gun_level = 0
var mosquito_rapier_level = 0
var scorpion_shotgun_level = 0
var bone_mace_level = 0

var health_upgrades = 0
var health_step = 2
var HEALTH_COST = [10, 50, 100]

var speed_upgrades = 0
var speed_step = 5
var SPEED_COST = [10, 50, 100]

var health_regen_upgrades = 0
var health_regen_step = 5
var HEALTH_REGEN_COST = [10, 50, 100]

var dash_upgrades = 0
var dash_step = 5
var DASH_COST = [10, 50, 100]

var armor_upgrades = 0
var armor_step = 5
var ARMOR_COST = [10, 50, 100]

func apply_upgrades():
	var player = Globals.get_player()
	
	player.MAX_HEALTH += health_upgrades*health_step
	player.MAX_SPEED += speed_upgrades*speed_step
	
	# Add rest
