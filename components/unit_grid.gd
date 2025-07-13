class_name UnitGrid extends Node

signal unit_grid_changed

@export var size: int

var units: Dictionary

func _ready() -> void:
	for q in range(-size / 2, size / 2 + 1):
		for r in range(-size / 2, size / 2 + 1):
			if abs(q + r) > size / 2:
				continue
			units[Vector2i(q, r)] = null

func add_unit(coord: Vector2i, unit: Node) -> void:
	units[coord] = unit
	unit_grid_changed.emit()
	
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
