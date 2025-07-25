class_name Inventory
extends Node

@export_category("Grid Settings")
@export var size_x: int = 8
@export var size_y: int = 8

@onready var grid_container: GridContainer = $InventoryUI/ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer

var slot_map: Dictionary[Vector2i, InventorySlot]
var held_item: InventoryItem

func _ready() -> void:
	grid_container.columns = size_x
	for i in range(size_x * size_y):
		create_slot(i)
		
	# DEBUG
	hold_item($InventoryItem)

func create_slot(index: int) -> void:
	var coordinate = Vector2i(index % size_x, index / size_x)
	var inventory_slot := InventorySlot.create_instance(grid_container, coordinate)
	slot_map[coordinate] = inventory_slot
	inventory_slot.slot_entered.connect(_on_slot_entered)
	inventory_slot.slot_exited.connect(_on_slot_exited)

func hold_item(item: InventoryItem) -> void:
	held_item = item
	held_item.drag_and_drop.drag_canceled.connect(_on_held_item_drag_canceled)
	held_item.drag_and_drop.drag_dropped.connect(_on_held_item_drag_dropped)

func is_slot_available(slot: InventorySlot) -> bool:
	for offset in held_item.item_data.item_cells:
		var coord_to_check := slot.coordinate + offset
		if coord_to_check.x < 0 or coord_to_check.x >= size_x:
			return false
		if coord_to_check.y < 0 or coord_to_check.y >= size_y:
			return false
		if slot_map[coord_to_check].state == InventorySlot.States.TAKEN:
			return false
		
	return true 

func _get_hovered_inventory_slot() -> InventorySlot:
	return slot_map[Vector2i(0, 0)]

func _on_held_item_drag_canceled(starting_position: Vector2) -> void:
	held_item.global_position = starting_position
	
func _on_held_item_drag_dropped(starting_position: Vector2) -> void:
	if held_item and is_slot_available(_get_hovered_inventory_slot()):
		print('yesy')
	held_item.global_position = starting_position

func _on_slot_entered(slot: InventorySlot) -> void:
	pass
	
func _on_slot_exited(slot: InventorySlot) -> void:
	pass
