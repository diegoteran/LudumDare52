extends Node

const DELTA = 20

var enemies = [preload("res://enemies/enemy_slime.tscn"), preload("res://enemies/enemy_puffer.tscn")]
var enemiesAlive = 0
var upgradeMenu = preload("res://Menus/TempUpgradeMenu.tscn")
var level_num = 0
var max_levels = 5
var enemy_count = [2,5,10,15,20,25,30]
var pickup_count = 0
var room_cleared = false

var total_killed = 0
var total_time = 0

func _process(delta):
	if Globals.paused:
		return
	if !room_cleared:
		total_time += delta
	if room_cleared and pickup_count <= 0:
		if level_num > max_levels:
			Globals.change_to_run_end()
			Globals.paused = true
		else:
			open_upgrade_menu_with_upgrades(0,1)

func startNewRun():
	Globals.clear_entities()
	ResearchManager.apply_upgrades()
	total_killed = 0
	total_time = 0
	level_num = 0
	Globals.paused = false
	startLevel()

func startLevel():
	Globals.clear_entities()
	room_cleared = false
	pickup_count = 0
	
	spawnEnemies(enemy_count[level_num])
	
	# TODO: FIX
	SoundFx.play_music("what_must_be_done")
	level_num += 1

	
func spawnEnemies(numEnemies):
	# Determine valid positions
	# Get random assortment of enemies
	for i in range(numEnemies):
		var index = randi()%2
		var newEnemy = enemies[index].instance()
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
		room_cleared = true

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

