extends Control

@onready var grid_container: GridContainer = $CenterContainer/GridContainer
const RECORDS_THEME = preload("res://Materials/records_theme.tres")
const COLUMNS := 3

func _ready() -> void:
	Globals.transition_fade_out()
	
	var total_levels := Globals.record_timers.size()
	var padded_total := int(ceil(total_levels / float(COLUMNS))) * COLUMNS

	# Add labels with levels and tags
	for i in range(0, padded_total, COLUMNS):
		for j in range(COLUMNS):
			var idx := i + j
			var label := Label.new()
			if idx < total_levels:
				label.text = "Level " + str(idx + 1)
				label.modulate = Color(0.655,0.655,0.655, 1.0)
			else:
				label.text = ""
			label.theme = RECORDS_THEME
			grid_container.add_child(label)

		for j in range(COLUMNS):
			var idx := i + j
			var label := Label.new()
			if idx < total_levels:
				label.text = format_time(Globals.record_timers[idx])
			else:
				label.text = ""
			label.theme = RECORDS_THEME
			grid_container.add_child(label)

func format_time(time: float) -> String:
	var seconds := int(time)
	var milliseconds := int((time - seconds) * 100)
	return str(seconds).pad_zeros(2) + "s" + str(milliseconds).pad_zeros(2) + "ms"
