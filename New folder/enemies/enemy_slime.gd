extends "res://enemies/Enemy.gd"

export var SPREAD_DIRECTIONS = 6
export var SPREAD_BUFFER_DIST = 30


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func shoot():
	for i in range(SPREAD_DIRECTIONS):
		var p = ENEMY_PROJECTILE.instance()
		var direction = Vector2.RIGHT.rotated(deg2rad(360/SPREAD_DIRECTIONS) * i)
		p.global_position = global_position + direction.normalized() * SPREAD_BUFFER_DIST
		Globals.level_root().add_child(p)
		p.shoot(direction)
		
		SoundFx.play("slime_jump", global_position, rand_range(0.9, 1.2))
	
	.end_attack()
