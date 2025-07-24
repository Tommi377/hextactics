class_name NavDebug
extends Node2D

@export var box_color: Color
@export var path_color: Color
@export var game_area: PlayArea
@export var battle_grid: UnitGrid

var paths := {}

func _ready() -> void:
	UnitNavigation.path_calculated.connect(_on_path_calculated)


func _draw() -> void:
	for id in UnitNavigation.astar.get_point_ids():
		if UnitNavigation.astar.is_point_disabled(id):
			var coord = UnitNavigation.astar.get_point_position(id)
			var pos = game_area.get_global_from_tile(coord) - global_position
			draw_rect(Rect2(pos, Vector2(4, 4)), box_color)
			
	for path in paths.values():
		draw_path(path, path_color)


func draw_path(points: Array[Vector2i], color: Color) -> void:
	for i in range(1, points.size()):
		var from := game_area.get_global_from_tile(points[i - 1]) - global_position
		var to := game_area.get_global_from_tile(points[i]) - global_position
		draw_line(from, to, color)


func _on_path_calculated(path: Array[Vector2i], coord: Vector2i) -> void:
	var unit := battle_grid.get_unit(coord)
	paths[unit] = path
	queue_redraw()
