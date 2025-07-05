extends CharacterBody2D

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
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func get_input():
	input.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	if Input.get_action_strength("Walking"):
		current_state = State.WALK
	if Input.get_action_strength("Running"):
		current_state = State.RUN
	if input.x != 0:
		sprite_2d.flip_h = input.x < 0
	
	return input.normalized()

func _process(delta: float):
	current_state = State.IDLE
	
	var playerInput = get_input()
	velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
	
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
	
	move_and_slide()
