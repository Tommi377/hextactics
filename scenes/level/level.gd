class_name Level extends Node2D

@export var hex_grid_size: int = 5
@onready var tile_map_controller: TileMapController = %TileMapController
@onready var battle_grid: UnitGrid = %BattleUnitGrid
@onready var game_area: PlayArea = %GameArea

func _ready() -> void:
	tile_map_controller.generate_tile_map(hex_grid_size)
	UnitNavigation.initialize(battle_grid, game_area)
