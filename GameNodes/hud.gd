extends CanvasLayer
@export var changeLight : int

signal lightsSignal

func _on_texture_button_toggled(toggled_on: bool) -> void:
	changeLight = toggled_on
	lightsSignal.emit()
