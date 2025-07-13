extends Node2D

@onready var directional_light_2d: DirectionalLight2D = $DirectionalLight2D
@export var switch_run_label : Label

func _ready() -> void:
	Globals.level_completed = false

func _on_canvas_layer_lights_signal() -> void:
	directional_light_2d.energy = 0.97 if $HUD_Switch.changeLight else 0.0
	
	if switch_run_label != null:
		if switch_run_label.visible:
			switch_run_label.visible = false
		else:
			switch_run_label.visible = true
