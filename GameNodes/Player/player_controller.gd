extends CharacterBody2D

@export var playerSheet : CompressedTexture2D
@export var eyesSheet : CompressedTexture2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var eyes_sprite: Sprite2D = $EyesSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var power_up_particles: CPUParticles2D = $Power_Up_Particles
@onready var dash_audio_player: AudioStreamPlayer = $DashAudioPlayer
@export var dash_audios_streams : Array[AudioStreamOggVorbis]
@export var death_particles : PackedScene = preload("res://Materials/Particles/player_dies.tscn")

var SPEED = 300.0
const ACCEL = 12.0
const DASH_SPEED    = 1200.0
const DASH_TIME     = 0.2
const DASH_COOLDOWN = 0.3

var dash_ready = false
var is_dashing     = false
var dash_dir       = Vector2.ZERO
var dash_timer     = 0.0
var dash_cd_timer  = 0.0
var original_mask  = self.collision_layer

var input_dir: Vector2

enum State{
	IDLE,
	WALK,
	RUN
}

var current_state = State.IDLE
var slowed_player = false

func _ready() -> void:
	Globals.player_controller = self

func get_input():
	input_dir.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_dir.y = Input.get_action_strength("Down")  - Input.get_action_strength("Up")
	input_dir = input_dir.normalized()

	if Input.get_action_strength("Walking"):
		current_state = State.WALK
	if Input.get_action_strength("Running"):
		current_state = State.RUN
	if Input.get_action_strength("Reset"):
		Globals.change_level()
	
	if input_dir.x != 0:
		sprite_2d.flip_h  = input_dir.x < 0
		eyes_sprite.flip_h = input_dir.x < 0

	if Input.is_action_just_pressed("Dash") and dash_cd_timer <= 0 and not is_dashing and dash_ready:
		start_dash()

	return input_dir

func _process(delta: float):
	if dash_cd_timer > 0:
		dash_cd_timer -= delta

	if is_dashing:
		dash_timer -= delta
		velocity = dash_dir * DASH_SPEED
		move_and_slide()

		if dash_timer <= 0:
			end_dash()
		return
	
	current_state = State.IDLE
	
	var playerInput = get_input()
	
	match current_state:
		State.IDLE:
			animation_player.play("Idle")
		State.WALK:
			animation_player.play("Walk")
			animation_player.speed_scale = 1.0
			SPEED = 300.0
		State.RUN:
			animation_player.play("Walk")
			animation_player.speed_scale = 1.5
			SPEED = 500.0
	
	velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
	if slowed_player:
		velocity = velocity/1.2
	
	move_and_slide()

func start_dash():
	# choose direction (fallback to facing)
	if input_dir == Vector2.ZERO:
		dash_dir = Vector2.LEFT  if sprite_2d.flip_h else Vector2.RIGHT
	else:
		dash_dir = input_dir
	
	is_dashing    = true
	dash_timer    = DASH_TIME
	dash_cd_timer = DASH_COOLDOWN
	
	dash_audio_player.stream = dash_audios_streams[randi_range(0, dash_audios_streams.size()-1)]
	dash_audio_player.play()

	# ignore objects on Layer 3 (bit 2)
	collision_mask &= ~(1 << 2)

func end_dash():
	is_dashing    = false
	collision_mask = original_mask
	velocity       = Vector2.ZERO
	remove_power_up_effect()

func enter_dark_mode():
	sprite_2d.texture = eyesSheet

func enter_light_mode():
	sprite_2d.texture = playerSheet
	
func slow_player():
	slowed_player = true

func remove_effect_player():
	slowed_player = false

func get_power_up_effect():
	dash_ready = true
	power_up_particles.visible = true
	
func remove_power_up_effect():
	dash_ready = false
	power_up_particles.visible = false

func kill_player():
	var particles_instance = death_particles.instantiate()
	get_tree().current_scene.add_child(particles_instance)
	particles_instance.global_position = global_position
	self.queue_free()

func is_sleeping():
	var tw = create_tween()
	tw.tween_property(
		$ZIcon,
		"modulate",
		Color(1, 1, 1, 1.0),
		0.3
	)
