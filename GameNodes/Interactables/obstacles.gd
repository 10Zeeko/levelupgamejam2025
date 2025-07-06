extends TileMapLayer

@export var player_controller = CharacterBody2D

func _on_obstacles_area_2d_body_entered(body: Node2D) -> void:
	if body == player_controller:
		player_controller.slow_player()

func _on_obstacles_area_2d_body_exited(body: Node2D) -> void:
	if body == player_controller:
		player_controller.remove_effect_player()
