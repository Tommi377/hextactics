extends Node2D
class_name TileMapController

@onready var tile_map: TileMapLayer = %TileMapLayer

func generate_tile_map(hex_grid_size: int):
	tile_map.generate_grid(hex_grid_size)
