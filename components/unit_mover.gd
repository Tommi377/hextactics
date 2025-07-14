class_name UnitMover extends Node

@export var play_areas: Array[PlayArea]

func _ready() -> void:
	# Testing purposes
	var units := get_tree().get_nodes_in_group("units")
	for unit: Unit in units:
		var play_area = _get_play_area_for_position(unit.global_position)
		setup_unit(unit)
		_move_unit(unit, play_area, play_area.get_tile_from_global(unit.global_position))

func setup_unit(unit: Unit) -> void:
	unit.drag_and_drop.drag_started.connect(_on_unit_drag_started.bind(unit))
	unit.drag_and_drop.drag_canceled.connect(_on_unit_drag_canceled.bind(unit))
	unit.drag_and_drop.drag_dropped.connect(_on_unit_drag_dropped.bind(unit))

func _set_highlighters(enabled: bool) -> void:
	for play_area in play_areas:
		play_area.tile_highlighter.enabled = enabled

func _get_play_area_for_position(global: Vector2) -> PlayArea:
	for i in play_areas.size():
		var tile := play_areas[i].get_tile_from_global(global)
		if play_areas[i].is_tile_in_bounds(tile):
			return play_areas[i]
	
	return null

func _reset_unit_to_starting_position(starting_position: Vector2, unit: Unit) -> void:
	var play_area := _get_play_area_for_position(starting_position)
	var tile := play_area.get_tile_from_global(starting_position)

	unit.global_position = starting_position
	play_area.unit_grid.add_unit(tile, unit)

func _move_unit(unit: Unit, play_area: PlayArea, tile: Vector2i) -> void:
	play_area.unit_grid.add_unit(tile, unit)
	unit.global_position = play_area.get_global_from_tile(tile)
	unit.reparent.call_deferred(play_area.unit_grid)

func _on_unit_drag_started(unit: Unit) -> void:
	_set_highlighters(true)
	var play_area = _get_play_area_for_position(unit.global_position)
	if not play_area:
		return
	
	var tile = play_area.get_tile_from_global(unit.global_position)
	play_area.unit_grid.remove_unit(tile)

func _on_unit_drag_canceled(starting_position: Vector2, unit: Unit) -> void:
	_set_highlighters(false)
	_reset_unit_to_starting_position(starting_position, unit)
	
func _on_unit_drag_dropped(starting_position: Vector2, unit: Unit) -> void:
	_set_highlighters(false)

	# Find the play area that mouse is pointing to
	var found_index = play_areas.find_custom(
		func (area: PlayArea): return area.is_tile_in_bounds(area.get_hovered_tile())
	)
	if found_index == -1:
		_reset_unit_to_starting_position(starting_position, unit)
		return

	var old_area := _get_play_area_for_position(starting_position)
	var new_area := play_areas[found_index]

	var old_tile := old_area.get_tile_from_global(starting_position)
	var new_tile := new_area.get_hovered_tile()

	# Unit swapping
	if new_area.unit_grid.is_occupied(new_tile):
		var old_unit := new_area.unit_grid.get_unit(new_tile)
		new_area.unit_grid.remove_unit(new_tile)
		_move_unit(old_unit, old_area, old_tile)

	_move_unit(unit, new_area, new_tile)
