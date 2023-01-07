extends Node

var player
var upgradeMenu = preload("res://UpgradesAndMenus/Menus/TempUpgradeMenu.tscn")
var paused = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_player(player_ref):
	player = player_ref

func get_player():
	return player

func open_upgrade_menu_with_upgrades(upgrade1, upgrade2):
	paused = true;
	var menu = upgradeMenu.instance();
	get_tree().root.add_child(menu);
	var basePath = "res://UpgradesAndMenus/Upgrades/";
	var upgrade1Script = load(basePath + UpgradeDict.upgrades[upgrade1])
	menu.upgrade1.set_script(upgrade1Script)
	menu.upgrade1.setValues()
	var upgrade2Script = load(basePath + UpgradeDict.upgrades[upgrade2])
	menu.upgrade2.set_script(upgrade2Script)
	menu.upgrade2.setValues()

