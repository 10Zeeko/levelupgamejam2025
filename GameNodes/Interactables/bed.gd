extends StaticBody2D

@export var next_level : PackedScene
var light_is_off = false
@onready var timer: Timer = $Timer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and light_is_off:
		timer.start()
		Globals.level_completed = true
		Globals.player_sleeping()

func _change_scene():
	Globals.current_level += 1
	Globals.change_level()

func _on_hud_switch_lights_signal() -> void:
	light_is_off = true


func _on_timer_timeout() -> void:
	call_deferred("_change_scene")
