extends Area2D

@export var player_controller: CharacterBody2D
@export var delay : float = 1.0
@export var start_delay : float = 1.0
@onready var move_timer: Timer = $MoveTimer
@onready var record_timer: Timer = $RecordTimer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var start_after_timer: Timer = $StartAfterTimer
@onready var spawn_particles: GPUParticles2D = $SpawnParticles

var first_time = true
var teleport_start_position : Vector2

var path_queue: Array[Vector2] = []

func _ready() -> void:
	sprite_2d.play("default")
	start_after_timer.wait_time = start_delay

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
