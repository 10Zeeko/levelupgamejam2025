extends StaticBody2D

@export var next_level : PackedScene

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Congratulations!")
