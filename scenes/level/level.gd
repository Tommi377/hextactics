extends Node

@export var hex_grid_size: int = 5
@onready var tile_map_controller: TileMapController = %TileMap

func _ready() -> void:
	tile_map_controller.generate_tile_map(hex_grid_size)
	
	AStar2D.new()
