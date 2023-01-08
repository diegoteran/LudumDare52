extends RigidBody2D

var PICKUP_SPEED = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.pickup_count += 1
	pass # Replace with function body.

func _physics_process(delta):
	if LevelManager.room_cleared:
		linear_velocity = (Globals.get_player().global_position - global_position).normalized() * PICKUP_SPEED

func _on_Area2D_area_entered(area):
	collect()
	LevelManager.pickup_count -= 1
	queue_free()
	pass # Replace with function body.

func collect():
	print("Been picked up")
	pass
