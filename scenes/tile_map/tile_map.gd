extends TileMapLayer

const SIZE = 4

func _ready():
	generate_grid()
	
func generate_grid():
	for q in range(-SIZE / 2, SIZE / 2 + 1):
		for r in range(-SIZE / 2, SIZE / 2 + 1):
			for s in range(-SIZE / 2, SIZE / 2 + 1):
				if q + r + s != 0:
					continue
				
				print("%s, %s, %s" % [q, r, s])
				set_cell(Vector2(q,r), 0, Vector2(0, 0))
