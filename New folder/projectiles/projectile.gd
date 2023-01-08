extends KinematicBody2D

export var ALIVE_TIME = 0.5
export var SPEED = 100
export var DMG = 10.0
export var CRIT_DMG = 5.0
export var CRIT_CHANCE = 0.1 
export var KNOCKBACK = 1.0

onready var hitbox = $HitBox

var velocity = Vector2.ZERO
var timeAlive = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	return

func _process(delta):
	if Globals.paused:
		return
	timeAlive += delta;
	if (timeAlive > ALIVE_TIME):
		queue_free()

func _physics_process(delta):
	if Globals.paused:
		return
	velocity = move_and_slide(velocity)
	
func shoot(direction):
	velocity = SPEED*direction.normalized()
	hitbox.damage = DMG
	if rand_range(0,1) < CRIT_CHANCE:
		print("Crit!")
		hitbox.damage += CRIT_DMG
	hitbox.knockback = KNOCKBACK
	hitbox.knockbackDirection = direction
	
	# TODO: Delete
	SoundFx.play("menu", global_position)

func hit_something():
	queue_free()
