extends Node

const GHOST_ENEMY = preload("res://Materials/Particles/ghost_enemy.tres")

var materials = [GHOST_ENEMY]

func _ready() -> void:
	for material in materials:
		var particles_instance = GPUParticles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_modulate(Color(1,1,1,0))
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)
