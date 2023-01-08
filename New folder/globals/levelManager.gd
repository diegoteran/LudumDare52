extends Node

const DELTA = 20

var enemy = preload("res://enemies/Enemy.tscn")
var enemiesAlive = 0
var upgradeMenu = preload("res://Menus/TempUpgradeMenu.tscn")
var level_num = 0
var max_levels = 5

var total_killed = 0
var total_time = 0

func _process(delta):
	if Globals.paused:
		return
	total_time += delta

func startNewRun():
	ResearchManager.apply_upgrades()
	total_killed = 0
	total_time = 0
	level_num = 0
	startLevel()

func startLevel():
	var numEnemies = rand_range(5,10)
	spawnEnemies(numEnemies)
	
	# TODO: FIX
	SoundFx.play_music("what_must_be_done")
	level_num += 1

	
func spawnEnemies(numEnemies):
	# Determine valid positions
	# Get random assortment of enemies
	for i in range(numEnemies):
		var newEnemy = enemy.instance()
		Globals.level_root().call_deferred("add_child", newEnemy)
		var enemyPos = Globals.get_player().global_position
		enemyPos += (Vector2(50,50) + Vector2(1,1)*rand_range(1,500)).rotated(deg2rad(rand_range(0,360)))
		enemyPos.x = min(Globals.WORLD_WIDTH - DELTA, max(DELTA, enemyPos.x))
		enemyPos.y = min(Globals.WORLD_HEIGHT - DELTA, max(DELTA, enemyPos.y))
		newEnemy.global_position = enemyPos
		enemiesAlive += 1
		
func enemyDied():
	total_killed += 1
	enemiesAlive -= 1
	if enemiesAlive <= 0:
		print("all enemies dead")
		if level_num > max_levels:
			Globals.change_to_run_end()
		else:
			open_upgrade_menu_with_upgrades(0,1)

func open_upgrade_menu_with_upgrades(upgrade1, upgrade2):
	Globals.paused = true
	var menu = upgradeMenu.instance()
	Globals.level_ui().add_child(menu)
	var basePath = "res://Upgrades/"
	var upgrade1Script = load(basePath + UpgradeDict.upgrades[upgrade1])
	menu.upgrade1.set_script(upgrade1Script)
	menu.upgrade1.setValues()
	var upgrade2Script = load(basePath + UpgradeDict.upgrades[upgrade2])
	menu.upgrade2.set_script(upgrade2Script)
	menu.upgrade2.setValues()

