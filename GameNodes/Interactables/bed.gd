extends StaticBody2D

@export var next_level : PackedScene
var light_is_off = false
@onready var timer: Timer = $Timer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and light_is_off:
		timer.start()
		Globals.level_completed = true
		Globals.count_time = false
		Globals.player_sleeping()
		Globals.transition_fade_in()

func _change_scene():
	if Globals.record_timers[Globals.current_level] < Globals.time_passed:
			Globals.record_timers[Globals.current_level] = Globals.time_passed
	Globals.current_level += 1
	Globals.change_level()

func _on_hud_switch_lights_signal() -> void:
	light_is_off = true


func _on_timer_timeout() -> void:
	call_deferred("_change_scene")
