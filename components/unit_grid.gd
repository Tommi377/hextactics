class_name UnitGrid extends Node

signal unit_grid_changed

@onready var level: Level = $"../.."
@warning_ignore("integer_division")
@onready var limit := level.hex_grid_size / 2

var units: Dictionary[Vector2i, Unit]

func _ready() -> void:
	for q in range(-limit, limit + 1):
		for r in range(-limit, limit + 1):
			if abs(q + r) > limit:
				continue
			units[Vector2i(q, r)] = null

func get_unit(coord: Vector2i) -> Unit:
	return units[coord]

func add_unit(coord: Vector2i, unit: Unit) -> void:
	units[coord] = unit
	unit_grid_changed.emit()
	
func remove_unit(coord: Vector2i) -> bool:
	var unit := units[coord]
	
	if not unit:
		return false
	
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
