extends Node

var level_completed : bool = false
var levels : Array[PackedScene]
var current_level : int = 0
var record_timers : Array[float]

var time_passed : float = 0.0
var count_time : bool = false

var player_controller : CharacterBody2D

const GLOBAL_MUSIC = preload("res://Sounds/global_music.ogg")
const PLAYER_DEATH = preload("res://Sounds/PlayerSounds/player_death.ogg")
var music_player : AudioStreamPlayer
var sfx_player : AudioStreamPlayer

func _ready() -> void:
	# Game Audio
	music_player = AudioStreamPlayer.new()
	sfx_player = AudioStreamPlayer.new()
	
	music_player.stream = GLOBAL_MUSIC
	music_player.bus = "Music"
	music_player.autoplay = true
	add_child(music_player)

	sfx_player.bus = "SFX"
	add_child(sfx_player)

	music_player.play()
	
	# Game levels
	levels.append(preload("res://Scenes/main_scene.tscn"))
	levels.append(preload("res://Scenes/first_level.tscn"))
	levels.append(preload("res://Scenes/second_level.tscn"))
	levels.append(preload("res://Scenes/third_level.tscn"))
	levels.append(preload("res://Scenes/fourth_level.tscn"))
	levels.append(preload("res://Scenes/fifth_level.tscn"))
	levels.append(preload("res://Scenes/end_of_the_game.tscn"))
	
	record_timers.resize(levels.size())

func _physics_process(delta: float) -> void:
	if count_time:
		time_passed =  time_passed + delta

func change_level():
	if level_completed:
		count_time = false
		time_passed = 0.0
		print(record_timers)
		get_tree().change_scene_to_packed(levels[current_level])
	else:
		get_tree().reload_current_scene()

func player_sleeping():
	if player_controller != null:
		player_controller.is_sleeping()

func kill_player():
	if player_controller != null:
		player_controller.kill_player()
		if sfx_player != null:
			sfx_player.stream = PLAYER_DEATH
			sfx_player.play()
		await get_tree().create_timer(1.0).timeout
		change_level()

func lights_off():
	if music_player:
		var tw = create_tween()
		tw.tween_property(music_player, "volume_db", -10.0, 0.5)
		player_controller.remove_power_up_effect()

func lights_on():
	if music_player:
		var tw = create_tween()
		tw.tween_property(music_player, "volume_db", 0.0, 0.5)

func get_time():
	return time_passed
