extends Node

var slime_skin = 10
var puffer_lungs = 10
var blood_bags = 10
var scorpion_tails = 10

var slime_gun_level = 0
var SLIME_COST = [5,10,20]
var SLIME_GUN_DMG_STEP = 5

var blow_gun_level = 0
var LUNG_COST = [5,10,20]
var BLOW_GUN_DMG_STEP = 5

var mosquito_rapier_level = 0
var BLOOD_COST = [5,10,20]
var RAPIER_DMG_STEP = 5

var scalpel_level = 1
var TAIL_COST = [5,10,20]
var SCALPEL_DMG_STEP = 5

var health_upgrades = 0
var health_step = 2
var HEALTH_COST = [1, 3, 5, 10, 50, 100]

var speed_upgrades = 0
var speed_step = 5
var SPEED_COST = [1, 3, 5, 10, 50, 100]

var health_regen_upgrades = 0
var health_regen_step = 1
var HEALTH_REGEN_COST = [1, 3, 5, 10, 50, 100]

var dash_upgrades = 0
var dash_step = 5
var DASH_COST = [1, 3, 5, 10, 50, 100]


func apply_upgrades():
	var player = Globals.get_player()
	
	player.MAX_HEALTH += health_upgrades*health_step
	player.MAX_SPEED += speed_upgrades*speed_step
	player.HEALTH_REGEN += health_regen_upgrades*health_regen_step
	
	# Add rest
