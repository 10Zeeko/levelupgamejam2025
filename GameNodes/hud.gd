extends CanvasLayer
@export var changeLight : int
@export var level_time : float
@onready var texture_button: TextureButton = $Control/TextureButton
@onready var timer: Timer = $Control/Timer
@onready var level_timer: Node2D = $LevelTimer

signal lightsSignal

func _on_texture_button_toggled(toggled_on: bool) -> void:
	changeLight = toggled_on
	lightsSignal.emit()
	if toggled_on:
		level_timer.timer_time = level_time
		level_timer.start_timer()
	else:
		level_timer.restart_timer()

func hide_hud():
	var tw = create_tween()
	tw.tween_property(
		texture_button,
		"modulate",
		Color(1, 1, 1, 0.0), 
		0.1               # duration in seconds
	)
	timer.start()

func show_hud():
	var tw = create_tween()
	tw.tween_property(
		texture_button,
		"modulate",
		Color(1, 1, 1, 1.0),
		0.1
	)
	texture_button.disabled = false

func _on_timer_timeout() -> void:
	texture_button.disabled = true
