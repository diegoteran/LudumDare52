extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var KNOCKBACK_FRICTION = 150
export var hp = 5 setget set_hp

enum {
	IDLE,
	CHASE,
	TELEGRAPH,
	ATTACK,
	DEAD
}

onready var sprite = $Sprite
onready var hurtBox = $HurtBox
onready var hitBox = $HitBox
onready var debug = $Debug
onready var softCollision = $SoftCollision

var state = CHASE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var player

func set_hp(new_value):
	if new_value != hp:
		hp = new_value
#		if hp <= 0:
#			_on_death()

# Called when the node enters the scene tree for the first time.
func _ready():
	player = Globals.get_player()

func _physics_process(delta):
	debug.text = str(state)
	
	if state == DEAD:
		return
	
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#			seek_player()
			
		CHASE:
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	# For enemies to stay away from each other.
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
