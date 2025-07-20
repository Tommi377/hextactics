class_name PlayArea extends TileMapLayer

@export var unit_grid: UnitGrid
@export var tile_highlighter: TileHighlighter

func _ready() -> void:
	pass
	
func get_tile_from_global(global: Vector2) -> Vector2i:
	return local_to_map(to_local(global))
	
func get_global_from_tile(tile: Vector2i) -> Vector2:
	return to_global(map_to_local(tile))
	
func get_hovered_tile() -> Vector2i:
	return local_to_map(get_local_mouse_position())

func is_tile_in_bounds(tile: Vector2) -> bool:
	return HexUtility.hex_cell_distance(tile, Vector2.ZERO) <= unit_grid.limit
