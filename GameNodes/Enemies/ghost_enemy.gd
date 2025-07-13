extends Area2D

@export var player_controller: CharacterBody2D
@export var delay : float = 1.0
@export var start_delay : float = 1.0
@onready var move_timer: Timer = $MoveTimer
@onready var record_timer: Timer = $RecordTimer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var start_after_timer: Timer = $StartAfterTimer
@onready var spawn_particles: GPUParticles2D = $SpawnParticles

@export var enemy_audios_streams : Array[AudioStreamOggVorbis]
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


var first_time = true
var teleport_start_position : Vector2

var path_queue: Array[Vector2] = []

func _ready() -> void:
	sprite_2d.play("default")
	start_after_timer.wait_time = start_delay
	set_process(true)

func _process(_delta: float) -> void:
	if Globals.level_completed:
		disable_and_fade_out()
		set_process(false)

func _on_record_timer_timeout() -> void:
	if player_controller:
		path_queue.append(player_controller.global_position)

func _on_move_timer_timeout() -> void:
	if path_queue.size() > 0:
		var next_position = path_queue.pop_front()
		if first_time:
			self.global_position = next_position
			first_time = false
			spawn_particles.emitting = true
			audio_stream_player.stream = enemy_audios_streams[randi_range(0, enemy_audios_streams.size()-1)]
			audio_stream_player.play()
			Globals.shake_for_time($"..", 50.0, 0.25)
		var tw = create_tween()
		tw.tween_property(self, "global_position", next_position, 0.2).set_trans(Tween.TRANS_LINEAR)

func _on_hud_switch_lights_signal() -> void:
	start_after_timer.start()
	record_timer.wait_time = 0.2
	record_timer.start()

func _on_start_after_timer_timeout() -> void:
	move_timer.wait_time = delay
	move_timer.start()


func _on_body_entered(body: Node2D) -> void:
	if body == player_controller:
		Globals.kill_player()
		Globals.shake_for_time($"..", 50.0, 0.1)
		
func disable_and_fade_out() -> void:
	record_timer.stop()
	move_timer.stop()
	start_after_timer.stop()

	set_deferred("monitoring", false)
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)

	var fade_tween := create_tween()
	fade_tween.tween_property(sprite_2d, "modulate:a", 0.0, 0.5)
	fade_tween.tween_callback(Callable(self, "queue_free"))
