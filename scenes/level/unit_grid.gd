class_name UnitGrid extends Node

signal unit_grid_changed

@onready var level: Level = $"../.."
@warning_ignore("integer_division")
@onready var limit := level.hex_grid_size / 2

@onready var game_area: PlayArea = %GameArea

var units: Dictionary[Vector2i, Node]

func _ready() -> void:
	for q in range(-limit, limit + 1):
		for r in range(-limit, limit + 1):
			if abs(q + r) > limit:
				continue
			units[Vector2i(q, r)] = null

func get_unit(coord: Vector2i) -> Node:
	return units[coord]

func add_unit(coord: Vector2i, unit: Node) -> void:
	units[coord] = unit
	if unit.has_method("set_coordinate"):
		unit.set_coordinate(coord)
	unit.tree_exited.connect(_on_unit_tree_exited.bind(unit, coord))
	unit_grid_changed.emit()
	
func remove_unit(coord: Vector2i) -> bool:
	var unit := units[coord]
	
	if not unit:
		return false
	
	unit.tree_exited.disconnect(_on_unit_tree_exited)
	units[coord] = null
	unit_grid_changed.emit()
	return true
	
func is_occupied(coord: Vector2i) -> bool:
	return units[coord] != null

func is_grid_full() -> bool:
	return units.keys().all(is_occupied)
	
func get_first_empty_tile() -> Vector2i:
	for coord in units:
		if not is_occupied(coord):
			return coord
			
	# No empty tile
	return Vector2i(-1, -1)

func get_all_units() -> Array[Unit]:
	var unit_array: Array[Unit] = []
	
	for unit: Unit in units.values():
		if unit:
			unit_array.append(unit)
			
	return unit_array
	
func get_all_occupied() -> Array[Vector2i]:
	var tile_array: Array[Vector2i] = []
	
	for tile: Vector2i in units.keys():
		if units[tile]:
			tile_array.append(tile)
			
	return tile_array

func _on_unit_tree_exited(unit: Node, tile: Vector2i) -> void:
	if unit.is_queued_for_deletion():
		units[tile] = null
		unit_grid_changed.emit()
