extends "res://enemies/enemy.gd"

func shoot():
	.shoot()
	SoundFx.play("pufferfish_gun", global_position, rand_range(0.8, 1.2))
