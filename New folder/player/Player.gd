extends KinematicBody2D

export var ACCELERATION = 1000
export var MAX_SPEED = 170
export var ROLL_SPEED = 130
export var FRICTION = 4000
export var ATTACK_SPEED = 15
export var MAX_HEALTH = 3
export var HEALTH_REGEN = 0

export var WEAPON: PackedScene

var health = MAX_HEALTH setget set_health

var fixedHealth = false


enum {
	MOVE,
	ROLL,
	ATTACK,
	DEAD,
	PAUSED
}

onready var debug = $Debug
onready var hurtBox = $HurtBox

var state = MOVE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
onready var sprite = $Sprite

signal health_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed", value)
	print("healthhh " + str(value))
	if health <= 0:
		on_death()

func on_death():
	
	if state == DEAD:
		return
	print("player died")
	
	SoundFx.play("dead", global_position)
	SoundFx.play_menu("game_over_cadence")
	SoundFx.fade_out()
	
	state = DEAD
	Globals.change_to_run_end()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.health = MAX_HEALTH
	Globals.set_player(self)
	var remoteTransform = RemoteTransform2D.new()
	remoteTransform.set_remote_node(get_parent().get_node("Camera2D").get_path())
	add_child(remoteTransform)

func add_weapon():
	add_child(WEAPON.instance())

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
	# Lol
	if not fixedHealth:
		call_deferred("set_health", MAX_HEALTH)
		fixedHealth = true
	
	if Input.is_action_pressed("attack"):
		var direction = (get_global_mouse_position() - global_position).normalized()
		if Input.is_action_just_pressed("attack"):
			$Weapon.shoot(direction)
		else:
			$Weapon.auto_shoot(direction)


func move():
	velocity = move_and_slide(velocity)
	sprite.flip_h = velocity.x < 0

func move_state(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
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

func regen_health():
	set_health(min(MAX_HEALTH, health + HEALTH_REGEN))

func _on_HurtBox_area_entered(area):
	print("player hit by damage: " + str(area.damage))
	self.health = health - area.damage
	knockback += area.knockback * area.knockbackDirection * 0.1
	area.get_parent().hit_something()
	SoundFx.play("hurt", global_position, rand_range(0.8, 1.2))
	Shake.shake(3, 1)
	hurtBox.start_invincibility(2)
