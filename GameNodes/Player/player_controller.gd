extends CharacterBody2D
@export var playerSheet : CompressedTexture2D
@export var eyesSheet : CompressedTexture2D

var SPEED = 300.0
const ACCEL = 12.0

var input: Vector2

enum State{
	IDLE,
	WALK,
	RUN
}

var current_state = State.IDLE
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var eyes_sprite: Sprite2D = $EyesSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var slowed_player = false
var dash_ready = false

func get_input():
	input.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	if Input.get_action_strength("Walking"):
		current_state = State.WALK
	if Input.get_action_strength("Running"):
		current_state = State.RUN
	if input.x != 0:
		sprite_2d.flip_h = input.x < 0
		eyes_sprite.flip_h = input.x < 0
	
	return input.normalized()

func _process(delta: float):
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

func enter_dark_mode():
	sprite_2d.texture = eyesSheet

func enter_light_mode():
	sprite_2d.texture = playerSheet
	
func slow_player():
	slowed_player = true

func remove_effect_player():
	slowed_player = false
