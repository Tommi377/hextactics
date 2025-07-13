class_name TileMapController extends Node2D

@export var tile_map: TileMapLayer

var rng = RandomNumberGenerator.new()

func generate_tile_map(size: int):
	@warning_ignore("integer_division")
	var limit: int = size / 2
	for q in range(-limit, limit + 1):
		for r in range(-limit, limit + 1):
			if abs(q + r) > limit:
				continue
			tile_map.set_cell(Vector2(q, r), 1, Vector2(0, rng.randi_range(0, 7)))
