extends StaticBody2D

@export var next_level : PackedScene

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().change_scene_to_packed(next_level)
