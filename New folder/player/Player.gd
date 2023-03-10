extends KinematicBody2D

export var ACCELERATION = 1000
export var MAX_SPEED = 170
export var FRICTION = 4000
export var ATTACK_SPEED = 15
export var MAX_HEALTH = 3
export var HEALTH_REGEN = 0
export var MAX_DASH = 0
export var DASH_COOLDOWN = 2
export var DASH_SPEED = 400

export var WEAPON: PackedScene
export var WALK_EFFECT: PackedScene

var health = MAX_HEALTH setget set_health

var fixedHealth = false


enum {
	IDLE,
	MOVE,
	DASH,
	ATTACK,
	DEAD,
	PAUSED
}

onready var debug = $Debug
onready var hurtBox = $HurtBox
onready var animationPlayer = $AnimationPlayer

var state = MOVE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var dash_cd = 0
var dashes = MAX_DASH setget set_dashes
onready var sprite = $Sprite

signal health_changed(value)
signal dash_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed", value)
	print("healthhh " + str(value))
	if health <= 0:
		on_death()

func set_dashes(value):
	dashes = value
	emit_signal("dash_changed", value)

func on_death():
	
	if state == DEAD:
		return
	print("player died")
	
	SoundFx.play("dead", global_position)
	SoundFx.fade_out()
	
	state = DEAD
	Globals.change_to_run_end(false)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.health = MAX_HEALTH
	Globals.set_player(self)
	var remoteTransform = RemoteTransform2D.new()
	remoteTransform.set_remote_node(Globals.level_camera().get_path())
	add_child(remoteTransform)

func add_weapon():
	add_child(WEAPON.instance())

func _physics_process(delta):
	if Globals.paused:
		return
	debug.text = str(state)
	
	if dash_cd > 0:
		dash_cd -= delta
		if dash_cd <= 0:
			self.dashes = min(dashes + 1, MAX_DASH)
			print("gained dash " + str(dashes))
	if dash_cd <= 0 and dashes < MAX_DASH:
		dash_cd = DASH_COOLDOWN
			
	match(state):
		MOVE:
			animationPlayer.play("Move")
			move_state(delta)
		DASH:
			dash_state(delta)
	
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
	
	if Input.is_action_pressed("dash") and dashes > 0 and state != DASH:
		state = DASH
		self.dashes -= 1
		print("lost dash, total: " + str(dashes))


func move():
	velocity = move_and_slide(velocity)
	sprite.flip_h = global_position.direction_to(get_global_mouse_position()).x < 0
	
	if velocity == Vector2.ZERO and state == MOVE:
		animationPlayer.play("Idle")

func dash_state(delta):
	animationPlayer.play("Dash")
	velocity = velocity.normalized() * DASH_SPEED

func end_dash():
	state = MOVE

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

func play_step():
	SoundFx.play("hit", global_position, rand_range(0.4, 0.6), -15)
	walk_effect()

func walk_effect():
	var instance = WALK_EFFECT.instance()
	Globals.level_drops().call_deferred("add_child", instance)
	instance.global_position = global_position - velocity.normalized()*3 + Vector2(0, 25)
