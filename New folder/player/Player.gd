extends KinematicBody2D

export var ACCELERATION = 600
export var MAX_SPEED = 150
export var ROLL_SPEED = 130
export var FRICTION = 4000
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
	var remoteTransform = RemoteTransform2D.new()
	print(get_parent().get_node("Camera2D").get_path())
	remoteTransform.set_remote_node(get_parent().get_node("Camera2D").get_path())
	add_child(remoteTransform)

func _physics_process(delta):
	if Globals.paused:
		return
	debug.text = str(state)
	
	match(state):
		MOVE:
			move_state(delta)
#		ROLL:
#			roll_state(delta)
	
	move()
	
func _process(delta):
	if Globals.paused:
		return;
	if Input.is_action_pressed("attack"):
		var direction = (get_global_mouse_position() - global_position).normalized()
		if Input.is_action_just_pressed("attack"):
			$Weapon.shoot(direction)
		else:
			$Weapon.auto_shoot(direction)
			
	if Input.is_action_pressed("debug"):
		Globals.open_upgrade_menu_with_upgrades(0,1)


func move():
	velocity = move_and_slide(velocity)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
#		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
#		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _on_HurtBox_area_entered(area):
	print('enemy attacked me')
