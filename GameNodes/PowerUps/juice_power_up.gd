extends Area2D

@export var player_controller: CharacterBody2D
@onready var timer: Timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body == player_controller:
		player_controller.get_power_up_effect()
		self.visible = false
		collision_shape_2d.disabled = true
		timer.start()

func _on_timer_timeout() -> void:
	self.visible = true
	collision_shape_2d.disabled = false
