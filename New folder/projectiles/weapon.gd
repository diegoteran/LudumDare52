extends Node2D

export var projectile = preload("res://projectiles/projectile.tscn")
export var sound_string = "scalpel"

# How fast the bullet will be
export var projectileSpeed = 10
# Base damage to the bullet
export var projectileDmg = 1
# How many seconds the bullet will remain before disapearing
export var projectileAliveTime = 0.2
# Additional damage on crit
export var projectileCritDmg = 5
# probability that crit will occur each shot
export var projectileCritChance = 0.4
# How much knockbac the bullet will have
export var projectileKnockback = 1
# how long between bullets shot
export var fireRate = 0.1
# Spread of bullets in degrees
export var spray = 10
# Whether or not the gun needs to be clicked for each bullet
export var automatic = false
# How much the gun pushes the user back while firing
export var recoil = 5

var cooldown = 0
export var BUFFER_DIST = 50

func _process(delta):
	cooldown = max(0, cooldown-delta)
	var percent = (cooldown/fireRate)
	$cooldown.value = $cooldown.max_value - ($cooldown.max_value * (cooldown/fireRate))
	if percent == 0:
		$cooldown.visible = false
	else:
		$cooldown.visible = true
	
func auto_shoot(direction):
	if automatic:
		shoot(direction);

func shoot(direction):
	if cooldown > 0:
		return;
	var p = projectile.instance()
	p.ALIVE_TIME = projectileAliveTime
	p.SPEED = projectileSpeed
	p.DMG = projectileDmg
	p.CRIT_DMG = projectileCritDmg
	p.CRIT_CHANCE = projectileCritChance
	p.KNOCKBACK = projectileKnockback
	direction = direction.rotated(deg2rad(rand_range(-spray, spray)))
	p.global_position = get_parent().global_position + direction.normalized()*BUFFER_DIST
	Globals.level_root().add_child(p)

	p.shoot(direction)
	play_weapon_sound()
	screen_shake()
	get_parent().knockback += direction * -1 * recoil
	cooldown = fireRate

func play_weapon_sound():
	SoundFx.play(sound_string, global_position, rand_range(0.9, 1.1))

func screen_shake():
	Shake.shake(0.5, 0.3)
