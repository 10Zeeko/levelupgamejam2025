extends Area2D

@export var player_controller: CharacterBody2D
@onready var timer: Timer = $Timer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var first_time = true
var teleport_start_position : Vector2

func _ready() -> void:
	sprite_2d.play("default")

func _on_timer_timeout() -> void:
	if first_time:
		self.global_position = teleport_start_position
		first_time = false
	
	var target_position = player_controller.global_position
	var tw = create_tween()
	tw.tween_property(self, "global_position", target_position, 1.0).set_trans(Tween.TRANS_LINEAR)

func _on_hud_switch_lights_signal() -> void:
	if player_controller:
		timer.start()
		teleport_start_position = player_controller.global_position
