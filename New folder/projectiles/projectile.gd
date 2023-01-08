extends KinematicBody2D

export var ALIVE_TIME = 3
export var SPEED = 100
export var DMG = 1
export var CRIT_DMG = 5.0
export var CRIT_CHANCE = 0.1 
export var KNOCKBACK = 1.0
export var SPREAD_AT_CONTACT = false
export var SPREAD_DIRECTIONS = 6
export var SPREAD_MOD = 2
export var SPREAD_BUFFER_DIST = 0

onready var hitbox = $HitBox
onready var sprite = $Sprite

var velocity = Vector2.ZERO
var timeAlive = 0
var fade = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	return

func _process(delta):
	if Globals.paused:
		return
	timeAlive += delta
	if (timeAlive > ALIVE_TIME):
		fade = true
	
	if (fade):
		if SPREAD_AT_CONTACT:
			SPREAD_AT_CONTACT = false
			spread_at_contact()
		hitbox.collision_layer = 0
		sprite.modulate.a -= 10*delta
		if sprite.modulate.a <= 0:
			queue_free()

func _physics_process(delta):
	if Globals.paused:
		return
	velocity = move_and_slide(velocity)
	
func shoot(direction):
	look_at(global_position + direction.normalized()*500)
	velocity = SPEED*direction.normalized()
	hitbox.damage = DMG
	if rand_range(0,1) < CRIT_CHANCE:
		print("Crit!")
		hitbox.damage += CRIT_DMG
	hitbox.knockback = KNOCKBACK
	hitbox.knockbackDirection = direction
	
	# TODO: Delete
	SoundFx.play("menu", global_position)

func spread_at_contact():
	for i in range(SPREAD_DIRECTIONS):
		var p = duplicate()
		p.ALIVE_TIME = ALIVE_TIME/SPREAD_MOD
		p.SPEED = SPEED
		p.DMG = DMG/SPREAD_MOD
		p.CRIT_DMG = CRIT_DMG/SPREAD_MOD
		p.CRIT_CHANCE = CRIT_CHANCE
		p.KNOCKBACK = KNOCKBACK/SPREAD_MOD
		p.timeAlive = 0
		p.fade = false
		var direction = Vector2.RIGHT.rotated(deg2rad(360/SPREAD_DIRECTIONS) * i)
		p.global_position = global_position + direction.normalized() * SPREAD_BUFFER_DIST
		Globals.level_root().add_child(p)
		p.shoot(direction)

func hit_something():
	fade = true
