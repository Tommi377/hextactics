class_name Inventory
extends Node

@export_category("Grid Settings")
@export var size_x: int = 8
@export var size_y: int = 8

@onready var grid_container: GridContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer

const GRID_SIZE_PX = 32
const GRID_CENTER_OFFSET_PX = Vector2(GRID_SIZE_PX / 2, GRID_SIZE_PX / 2)

var slot_map: Dictionary[Vector2i, InventorySlot]
var held_item: InventoryItem
var hovered_slots: Array[InventorySlot] = []

func _ready() -> void:
	grid_container.columns = size_x
	for i in range(size_x * size_y):
		create_slot(i)

func _process(_delta: float) -> void:
	if held_item:
		for slot in hovered_slots:
			slot.unhover()
		hovered_slots.clear()
		for slot in _get_hovered_inventory_slots():
			slot.hover()
			hovered_slots.append(slot)

func create_slot(index: int) -> void:
	var coordinate = Vector2i(index % size_x, index / size_x)
	var inventory_slot := InventorySlot.create_instance(grid_container, coordinate)
	slot_map[coordinate] = inventory_slot

func hold_item(item: InventoryItem) -> void:
	held_item = item
	held_item.drag_and_drop.drag_canceled.connect(_on_held_item_drag_canceled)
	held_item.drag_and_drop.drag_dropped.connect(_on_held_item_drag_dropped)

func _is_slot_available(coord: Vector2i) -> bool:
	if coord.x < 0 or coord.x >= size_x:
		return false
	if coord.y < 0 or coord.y >= size_y:
		return false
	if slot_map[coord].state == InventorySlot.States.TAKEN:
		return false
		
	return true 

func _get_item_coordinate() -> Vector2i:
	var item_pos := grid_container.get_local_mouse_position() + held_item.drag_and_drop.offset
	var result = Vector2i(item_pos / GRID_SIZE_PX)
	if item_pos.x < 0:
		result -= Vector2i(1, 0)
	if item_pos.y < 0:
		result -= Vector2i(0, 1)
	return result

func _can_place_held_item() -> bool:
	var item_coord := _get_item_coordinate()
	for offset: Vector2i in held_item.item_data.item_cells: 
		var final_coord := item_coord + offset
		if not _is_slot_available(final_coord):
			return false
	return true

func _get_hovered_inventory_slots() -> Array[InventorySlot]:
	var item_coord := _get_item_coordinate()
	var result: Array[InventorySlot] = []
	for offset: Vector2i in held_item.item_data.item_cells: 
		var final_coord := item_coord + offset
		if _is_slot_available(final_coord):
			result.append(slot_map[final_coord])
	return result

func _on_held_item_drag_canceled(starting_position: Vector2) -> void:
	held_item.global_position = starting_position
	
func _on_held_item_drag_dropped(starting_position: Vector2) -> void:
	if _can_place_held_item():
		held_item.global_position = slot_map[_get_item_coordinate()].global_position + GRID_CENTER_OFFSET_PX
	else:
		held_item.global_position = starting_position
