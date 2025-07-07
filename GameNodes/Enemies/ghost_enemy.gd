extends CharacterBody2D

@export var player_controller: CharacterBody2D
@onready var timer: Timer = $Timer

func _on_timer_timeout() -> void:
	if player_controller:
		var target_position = player_controller.global_position
		var tw = create_tween()
		tw.tween_property(self, "global_position", target_position, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_hud_switch_lights_signal() -> void:
	timer.start()
	self.global_position = player_controller.global_position
