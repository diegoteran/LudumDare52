extends "res://enemies/enemy.gd"

# Called when the node enters the scene tree for the first time.
func shoot():
	var p = ENEMY_PROJECTILE.instance()
	Globals.level_root().add_child(p)
	var shootDirection = (Globals.get_player().global_position - global_position).normalized()
	p.global_position = global_position + (shootDirection * BUFFER_DIST)
	p.shoot(shootDirection)
