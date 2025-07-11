extends TileMapLayer

@export var player_controller = CharacterBody2D
@export var legos_sounds : Array[AudioStreamOggVorbis]

var audio_player: AudioStreamPlayer2D
var player_inside: bool = false

func _ready():
	# Crear el nodo de audio si no existe
	audio_player = AudioStreamPlayer2D.new()
	audio_player.name = "LegoAudioPlayer"
	add_child(audio_player)

	audio_player.finished.connect(_on_audio_finished)

func _on_obstacles_area_2d_body_entered(body: Node2D) -> void:
	if body == player_controller:
		player_inside = true
		player_controller.slow_player()
		_play_random_sound()

func _on_obstacles_area_2d_body_exited(body: Node2D) -> void:
	if body == player_controller:
		player_inside = false
		player_controller.remove_effect_player()
		audio_player.stop()

func _play_random_sound():
	if legos_sounds.is_empty():
		return

	if player_inside:
		var random_index = randi() % legos_sounds.size()
		audio_player.stream = legos_sounds[random_index]
		audio_player.play()

func _on_audio_finished():
	_play_random_sound()
