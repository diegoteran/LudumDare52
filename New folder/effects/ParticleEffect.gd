extends Node2D

var color = Color.whitesmoke

onready var deathTimer = $DeathTimer
onready var particles = $Particles2D

func _ready():
	deathTimer.start(particles.lifetime)
	particles.process_material.color = color
	particles.emitting = true

func _on_DeathTimer_timeout():
	queue_free()

func set_particles_color(new_color: Color):
	color = new_color
