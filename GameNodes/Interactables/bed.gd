extends StaticBody2D

@export var next_level : PackedScene
var light_is_off = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and light_is_off:
		call_deferred("_change_scene")

func _change_scene():
	get_tree().change_scene_to_packed(next_level)

func _on_hud_switch_lights_signal() -> void:
	light_is_off = true
