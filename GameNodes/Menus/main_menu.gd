extends Control

@export var next_level : PackedScene
@onready var world_environment: WorldEnvironment = $WorldEnvironment

var base_intensity := 0.75
var flicker_timer := 0.0
var flicker_interval := 0.05

func _process(delta: float) -> void:
	flicker_timer -= delta
	if flicker_timer <= 0.0:
		flicker_timer = randf_range(0.03, 0.45)
		var flicker = randf_range(-0.25, 0.25)
		var new_intensity = clamp(base_intensity + flicker, 0.0, 1.0)
		world_environment.environment.glow_intensity = new_intensity

func _on_button_pressed() -> void:
	call_deferred("_change_scene")
	Globals.transition_fade_in()

func _change_scene():
	Globals.level_completed = true
	Globals.change_level()
