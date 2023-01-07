extends Node

var enemy = preload("res://enemies/Enemy.tscn")
var enemiesAlive = 0
var upgradeMenu = preload("res://UpgradesAndMenus/Menus/TempUpgradeMenu.tscn")

func startLevel():
	var numEnemies = rand_range(5,20)
	spawnEnemies(numEnemies)
	
func spawnEnemies(numEnemies):
	# Determine valid positions
	# Get random assortment of enemies
	for i in range(numEnemies):
		var newEnemy = enemy.instance()
		Globals.level_root().call_deferred("add_child", newEnemy)
		var enemyPos = Globals.get_player().global_position
		enemyPos += (Vector2(50,50) + Vector2(1,1)*rand_range(1,500)).rotated(deg2rad(rand_range(0,360)))
		newEnemy.global_position = enemyPos
		enemiesAlive += 1
		
func enemyDied():
	enemiesAlive -= 1
	if enemiesAlive <= 0:
		print("all enemies dead")
		# TODO Check to see if we made it through the last room
		open_upgrade_menu_with_upgrades(0,1)

func open_upgrade_menu_with_upgrades(upgrade1, upgrade2):
	Globals.paused = true
	var menu = upgradeMenu.instance()
	Globals.level_root().add_child(menu)
	var basePath = "res://UpgradesAndMenus/Upgrades/"
	var upgrade1Script = load(basePath + UpgradeDict.upgrades[upgrade1])
	menu.upgrade1.set_script(upgrade1Script)
	menu.upgrade1.setValues()
	var upgrade2Script = load(basePath + UpgradeDict.upgrades[upgrade2])
	menu.upgrade2.set_script(upgrade2Script)
	menu.upgrade2.setValues()
