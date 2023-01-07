extends KinematicBody2D

export var ACCELERATION = 400
export var MAX_SPEED = 75
export var ROLL_SPEED = 130
export var FRICTION = 1000
export var ATTACK_SPEED = 15

enum {
	MOVE,
	ROLL,
	ATTACK,
	DEAD,
	PAUSED
}

onready var debug = $Debug

var state = MOVE
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.set_player(self)

func _physics_process(delta):
	
	debug.text = str(state)
	
	match(state):
		MOVE:
			move_state(delta)
#		ROLL:
#			roll_state(delta)
	
	move()

func move():
	velocity = move_and_slide(velocity)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
#		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
#		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _on_HurtBox_area_entered(area):
	print('enemy attacked me')
