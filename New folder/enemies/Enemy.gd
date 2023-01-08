extends KinematicBody2D

export var ENEMY_PROJECTILE : PackedScene
export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var KNOCKBACK_FRICTION = 150
export var MAX_HP = 5
export var DISTANCE_FROM_PLAYER = 100
export var ATTACK_COOLDOWN = 5
export var DROP_CHANCE = 0.3
var hp = MAX_HP setget set_hp

enum {
	IDLE,
	CHASE,
	TELEGRAPH,
	ATTACK,
	DEAD
}

export var drop = preload("res://pickups/pickup.tscn")

onready var sprite = $Sprite
onready var hurtBox = $HurtBox
onready var hitBox = $HitBox
onready var debug = $Debug
onready var softCollision = $SoftCollision
onready var healthBar = $HealthBar
onready var attackTimer = $AttackTimer
onready var animationPlayer = $AnimationPlayer

var state = CHASE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var player

func set_hp(new_value):
	if new_value != hp:
		hp = new_value
		healthBar.value = hp;
		healthBar.visible = healthBar.value < MAX_HP
		if hp <= 0:
			on_death()
			state = DEAD

# Called when the node enters the scene tree for the first time.
func _ready():
	set_attack_cooldown()
	player = Globals.get_player()
	$HealthBar.max_value = MAX_HP

func set_attack_cooldown():
	attackTimer.start(ATTACK_COOLDOWN + (rand_range(-1, 1)))

func _physics_process(delta):
	if Globals.paused:
		return
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
			animationPlayer.play("Move")
			if player != null:
				accelerate_towards_point(distance_from_player(player.global_position), delta)
			else:
				state = IDLE
		
		ATTACK:
			animationPlayer.play("Attack")
			if player != null:
				accelerate_towards_point(distance_from_player(player.global_position), delta)
			else:
				state = IDLE
			
	
	# For enemies to stay away from each other.
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x > 0

func hit_something():
	print("HIT THE HUMAN")

func on_death():
	LevelManager.enemyDied()
	if rand_range(0,1) < DROP_CHANCE:
		var drop_inst = drop.instance()
		Globals.level_root().call_deferred("add_child", drop_inst)
		drop_inst.global_position = global_position
	queue_free()

func _on_HurtBox_area_entered(area):
	var newHp = max(0, hp - area.damage)
	print("enemy hit for " + str(area.damage))
	set_hp(newHp)
	knockback += area.knockback * area.knockbackDirection
	area.get_parent().hit_something()
	pass # Replace with function body.

func distance_from_player(player_position):
	return player_position + player_position.direction_to(global_position).normalized() * DISTANCE_FROM_PLAYER


func _on_AttackTimer_timeout():
	print("attack")
	state = ATTACK

func end_attack():
	set_attack_cooldown()
	state = CHASE
