extends Node2D

@onready var directional_light_2d: DirectionalLight2D = $DirectionalLight2D

func _on_canvas_layer_lights_signal() -> void:
	directional_light_2d.energy = $HUD_Switch.changeLight
