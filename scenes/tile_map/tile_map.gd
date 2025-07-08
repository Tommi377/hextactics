extends TileMapLayer

var rng = RandomNumberGenerator.new()
	
func generate_grid(size: int):
	for q in range(-size / 2, size / 2 + 1):
		for r in range(-size / 2, size / 2 + 1):
			for s in range(-size / 2, size / 2 + 1):
				if q + r + s != 0:
					continue
				set_cell(Vector2(q,r), 0, Vector2(rng.randi_range(0, 3), rng.randi_range(0, 4)))
