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

const TRANSITIONS_OVERLAY = preload("res://GameNodes/Menus/transitions_overlay.tscn")
var transitions_node : Node

var shake_target: Node = null
var shake_timer: Timer = null
var shake_amount: float = 0.0
var shake_active: bool = false
var original_shake_position: Vector2 = Vector2.ZERO

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
	
	# Transitions
	
	transitions_node = TRANSITIONS_OVERLAY.instantiate()
	add_child(transitions_node)
	
	# Game levels
	levels.append(preload("res://Scenes/main_scene.tscn"))
	levels.append(preload("res://Scenes/first_level.tscn"))
	levels.append(preload("res://Scenes/second_level.tscn"))
	levels.append(preload("res://Scenes/third_level.tscn"))
	levels.append(preload("res://Scenes/fourth_level.tscn"))
	levels.append(preload("res://Scenes/fifth_level.tscn"))
	levels.append(preload("res://Scenes/end_of_the_game.tscn"))
	
	record_timers.resize(levels.size()-1)

func _physics_process(delta: float) -> void:
	if count_time:
		time_passed =  time_passed + delta

func change_level():
	if level_completed:
		count_time = false
		time_passed = 0.0
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
		tw.tween_property(music_player, "volume_db", -20.0, 0.5)
		player_controller.remove_power_up_effect()

func lights_on():
	if music_player:
		var tw = create_tween()
		tw.tween_property(music_player, "volume_db", 0.0, 0.5)

func get_time():
	return time_passed
	
func transition_fade_in():
	var anim := transitions_node.get_node("AnimationPlayer")
	anim.play("Fade In")

func transition_fade_out():
	var anim := transitions_node.get_node("AnimationPlayer")
	anim.play("Fade out")
	
func shake_for_time(target: Node, intensity: float, duration: float) -> void:
	if not target:
		return
	shake_target = target
	original_shake_position = target.position

	var tween := create_tween()
	var steps := int(duration / 0.05)
	for i in range(steps):
		var offset := Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(target, "position", original_shake_position + offset, 0.025)
		tween.tween_property(target, "position", original_shake_position, 0.025)

func start_shake(target: Node, intensity: float) -> void:
	if not target:
		return
	if shake_active:
		stop_shake()

	shake_active = true
	shake_target = target
	shake_amount = intensity
	original_shake_position = target.position

	shake_timer = Timer.new()
	shake_timer.wait_time = 0.05
	shake_timer.timeout.connect(_on_shake_timeout)
	shake_timer.autostart = true
	shake_timer.one_shot = false
	add_child(shake_timer)

func stop_shake() -> void:
	if shake_timer and shake_timer.is_inside_tree():
		shake_timer.stop()
		shake_timer.queue_free()
	shake_timer = null
	shake_active = false
	if shake_target:
		shake_target.position = original_shake_position
	shake_target = null

func _on_shake_timeout() -> void:
	if shake_target:
		var offset := Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
		shake_target.position = original_shake_position + offset
