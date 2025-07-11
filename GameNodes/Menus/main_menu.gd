extends Control

@export var next_level : PackedScene

func _on_button_pressed() -> void:
	call_deferred("_change_scene")

func _change_scene():
	Globals.level_completed = true
	Globals.change_level()
