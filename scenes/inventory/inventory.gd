class_name Inventory
extends GridContainer

@export_category("Grid Settings")
@export var size_x: int = 8
@export var size_y: int = 8

const GRID_SIZE_PX = 32
const GRID_CENTER_OFFSET_PX = Vector2(GRID_SIZE_PX / 2, GRID_SIZE_PX / 2)

var slot_map: Dictionary[Vector2i, InventorySlot]
var held_item: InventoryItem
var hovered_slots: Array[InventorySlot] = []

func _ready() -> void:
	self.columns = size_x
	for i in range(size_x * size_y):
		create_slot(i)

func _process(_delta: float) -> void:
	if held_item:
		_unhover_all_slots()
		var can_place := _can_place_held_item()
		for slot in _get_hovered_inventory_slots():
			if _can_place_held_item():
				slot.hover(InventorySlot.HoverMode.DEFAULT)
			else:
				slot.hover(InventorySlot.HoverMode.INVALID)
			hovered_slots.append(slot)

func create_slot(index: int) -> void:
	var coordinate = Vector2i(index % size_x, index / size_x)
	var inventory_slot := InventorySlot.create_instance(self, coordinate)
	slot_map[coordinate] = inventory_slot

func hold_item(item: InventoryItem) -> void:
	held_item = item
	held_item.drag_and_drop.drag_canceled.connect(_on_held_item_drag_canceled)
	held_item.drag_and_drop.drag_dropped.connect(_on_held_item_drag_dropped)

func unhold_item() -> void:
	held_item = null
	_unhover_all_slots()

func _put_held_item_to_slots() -> void:
	held_item.global_position = slot_map[_get_item_coordinate()].global_position + GRID_CENTER_OFFSET_PX
	var slots := _get_hovered_inventory_slots()
	for slot in slots:
		slot.set_item(held_item)

func _cancel_held_item_drag(starting_position: Vector2) -> void:
	held_item.global_position = starting_position

func _unhover_all_slots() -> void:
	for slot in hovered_slots:
		slot.unhover()
	hovered_slots.clear()

func _is_slot_available(coord: Vector2i) -> bool:
	if coord.x < 0 or coord.x >= size_x:
		return false
	if coord.y < 0 or coord.y >= size_y:
		return false
	if slot_map[coord].state == InventorySlot.States.TAKEN:
		return false
		
	return true 

func _get_item_coordinate() -> Vector2i:
	var item_pos := self.get_local_mouse_position() + held_item.drag_and_drop.offset
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
	_cancel_held_item_drag(starting_position)
	unhold_item()
	
func _on_held_item_drag_dropped(starting_position: Vector2) -> void:
	if _can_place_held_item():
		_put_held_item_to_slots()
	else:
		_cancel_held_item_drag(starting_position)
	unhold_item()
