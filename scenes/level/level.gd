class_name Level extends Node

@export var hex_grid_size: int = 5
@export var tile_map_controller: TileMapController

func _ready() -> void:
	tile_map_controller.generate_tile_map(hex_grid_size)
	
	AStar2D.new()
