extends KinematicBody2D

export var ALIVE_TIME = 0.5
export var SPEED = 100
export var DMG = 10.0
export var CRIT_DMG = 5.0
export var CRIT_CHANCE = 0.1 
export var KNOCKBACK = 1.0

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

func hit_something():
	fade = true
