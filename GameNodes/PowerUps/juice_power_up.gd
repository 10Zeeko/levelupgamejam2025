extends Area2D

@export var player_controller: CharacterBody2D
@onready var timer: Timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var position_curve: Curve
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var travel_time: float = 2.0
var time_passed: float = 0.0
var original_position: Vector2

func _ready() -> void:
	original_position = sprite_2d.position

func _process(delta: float) -> void:
	if position_curve:
		time_passed += delta
		var t := fmod(time_passed / travel_time, 1.0)
		var y_offset := position_curve.sample(t) * 20.0
		sprite_2d.position.y = original_position.y + y_offset

func _on_body_entered(body: Node2D) -> void:
	if body == player_controller:
		player_controller.get_power_up_effect()
		self.visible = false
		collision_shape_2d.set_deferred("disabled", true)
		timer.start()

func _on_timer_timeout() -> void:
	self.visible = true
	collision_shape_2d.disabled = false
