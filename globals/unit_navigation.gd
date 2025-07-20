extends Node

signal path_calculated(points: Array[Vector2i], moving_unit: BattleUnit)

var battle_grid: UnitGrid
var game_area: PlayArea
var astar: AStar2D

func initialize(grid: UnitGrid, area: PlayArea) -> void:
	astar = AStar2D.new()
	battle_grid = grid
	game_area = area
	
	var all_points = battle_grid.units.keys()
	
	for i in range(all_points.size()):
		var current = all_points[i]
		astar.add_point(i, current)
	
	for i in range(all_points.size()):
		var current = all_points[i]
		for neighbor in HexUtility.get_neighbors(current):
			var j = all_points.find(neighbor)
			if j != -1:
				astar.connect_points(i, j)
	
	battle_grid.unit_grid_changed.connect(update_occupied_tiles)

func update_occupied_tiles() -> void:
	print('called update_occupied_tiles')
	for tile in battle_grid.units.keys():
		astar.set_point_disabled(astar.get_closest_point(tile, true), battle_grid.is_occupied(tile))
	
func get_next_position(moving_unit: BattleUnit, target_unit: BattleUnit) -> Vector2:
	var current_tile := game_area.get_tile_from_global(moving_unit.global_position)
	var target_tile := game_area.get_tile_from_global(moving_unit.global_position)
	
	var current_id := astar.get_closest_point(current_tile, true)
	var target_id := astar.get_closest_point(target_tile, true)
	
	astar.set_point_disabled(current_id, false)
	var path := astar.get_id_path(current_id, target_id, true)
	path_calculated.emit(path, moving_unit)
	
	if path.size() == 1 and path[0] == current_id:
		astar.set_point_disabled(current_id, true)
		return Vector2(-1, -1)
		
	var next_tile := astar.get_point_position(path[1])
	battle_grid.remove_unit(current_tile)
	battle_grid.add_unit(next_tile, moving_unit)
	astar.set_point_disabled(path[1], true)
	
	return game_area.get_global_from_tile(next_tile)
