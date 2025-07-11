extends Node

var level_completed : bool = false
var levels : Array[PackedScene]
var current_level : int = 0
var record_timers : Array[float]

var time_passed : float = 0.0
var count_time : bool = false

var player_controller : CharacterBody2D

func _ready() -> void:
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
		if record_timers[current_level] < time_passed:
			record_timers[current_level] = time_passed
			print(record_timers)
		time_passed = 0.0
		get_tree().change_scene_to_packed(levels[current_level])
	else:
		get_tree().reload_current_scene()

func kill_player():
	player_controller.kill_player()
