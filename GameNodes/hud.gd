extends CanvasLayer
@export var changeLight : int
@export var level_time : float
@onready var texture_button: TextureButton = $Control/TextureButton
@onready var timer: Timer = $Control/Timer
@onready var level_timer: Node2D = $LevelTimer

@export var switch_audios_streams : Array[AudioStreamOggVorbis]
@onready var switch_stream_player: AudioStreamPlayer = $SwitchStreamPlayer
@export var dark_noise_streams : Array[AudioStreamOggVorbis]
@onready var dark_noise_player: AudioStreamPlayer = $DarkNoisePlayer

var seconds : float
var miliseconds : float
var current_time : float

signal lightsSignal

func _ready() -> void:
	hide_hud()
	Globals.lights_on()
	Globals.count_time = false
	Globals.time_passed = 0
	Globals.transition_fade_out()

func _on_texture_button_toggled(toggled_on: bool) -> void:
	changeLight = toggled_on
	lightsSignal.emit()
	Globals.lights_off()
	texture_button.disabled = true
	
	switch_stream_player.stream = switch_audios_streams[randi_range(0, switch_audios_streams.size()-1)]
	switch_stream_player.play()
	
	dark_noise_player.stream = dark_noise_streams[randi_range(0, dark_noise_streams.size()-1)]
	dark_noise_player.play()
	
	if toggled_on:
		level_timer.timer_time = level_time
		level_timer.start_timer()
		Globals.count_time = true
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

func _process(_delta: float) -> void:
	current_time = Globals.get_time()
	seconds = fmod(current_time, 60)
	miliseconds = fmod(current_time, 1) * 100
	$Control/HBoxContainer/Seconds.text = "%02d" % seconds
	$Control/HBoxContainer/Miliseconds.text = "%02d" % miliseconds
