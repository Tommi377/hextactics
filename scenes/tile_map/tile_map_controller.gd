class_name TileMapController extends Node2D

@export var tile_map: TileMapLayer

var rng = RandomNumberGenerator.new()

func generate_tile_map(size: int):
	for q in range(-size / 2, size / 2 + 1):
		for r in range(-size / 2, size / 2 + 1):
			if abs(q + r) > size / 2:
				continue
			tile_map.set_cell(Vector2(q,r), 0, Vector2(rng.randi_range(0, 3), rng.randi_range(0, 4)))
