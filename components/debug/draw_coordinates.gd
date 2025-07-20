class_name DrawCoordinates
extends Node2D

@export var limit: int
@export var offset: Vector2 :
	set(value):
		offset = value
		queue_redraw()
	
@export var game_area: PlayArea

func _draw() -> void:
	@warning_ignore("integer_division")
	for q in range(-limit, limit + 1):
		for r in range(-limit, limit + 1):
			if abs(q + r) > limit:
				continue
			var pos := game_area.get_global_from_tile(Vector2i(q, r)) + offset - global_position
			draw_string(ThemeDB.fallback_font, pos, "%d %d" % [q, r],
				HORIZONTAL_ALIGNMENT_CENTER, 24, 8, Color(0,0,0,0.5))
