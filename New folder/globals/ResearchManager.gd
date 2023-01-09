extends Node

var slime_skin = 0
var puffer_lungs = 0
var scorpion_tails = 0

var slime_gun_level = 0
var SLIME_COST = [5,10,20]
var SLIME_GUN_DMG_STEP = 1

var blow_gun_level = 0
var LUNG_COST = [5,10,20]
var BLOW_GUN_DMG_STEP = 1

var scalpel_level = 1
var TAIL_COST = [5,10,20]
var SCALPEL_DMG_STEP = 1

var health_upgrades = 0
var health_step = 1
var HEALTH_COST = [1, 3, 5, 10, 50, 100]

var speed_upgrades = 0
var speed_step = 25
var SPEED_COST = [1, 3, 5, 10, 50, 100]

var dash_upgrades = 0
var dash_step = 1
var DASH_COST = [1, 3, 5, 10, 50, 100]

var FINAL_COST = 25

var weaponUpgradeStepDict = {
	"scalpel" : SCALPEL_DMG_STEP,
	"slimegun" : SLIME_GUN_DMG_STEP,
	"blowgun" : BLOW_GUN_DMG_STEP
}

func weaponToUpgradeLevel(weapon):
	if weapon == "scalpel":
		return scalpel_level
	elif weapon == "slimegun":
		return slime_gun_level
	elif weapon == "blowgun":
		return blow_gun_level

func apply_upgrades():
	var player = Globals.get_player()
	
	player.MAX_HEALTH += health_upgrades*health_step
	player.MAX_SPEED += speed_upgrades*speed_step
	player.MAX_DASH += dash_upgrades*dash_step
