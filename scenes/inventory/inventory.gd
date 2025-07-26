class_name Inventory
extends GridContainer

@export_category("Grid Settings")
@export var size_x: int = 8
@export var size_y: int = 8

const GRID_SIZE_PX = 32
const GRID_CENTER_OFFSET_PX = Vector2(GRID_SIZE_PX / 2, GRID_SIZE_PX / 2)

var slot_map: Dictionary[Vector2i, InventorySlot]
var item_to_slots: Dictionary

var held_item: InventoryItem
var hovered_slots: Array[InventorySlot] = []

func _ready() -> void:
	self.columns = size_x
	for i in range(size_x * size_y):
		create_slot(i)

func _process(_delta: float) -> void:
	if held_item:
		_unhover_all_slots()
		for slot in _get_hovered_inventory_slots(held_item, _get_item_coordinate()):
			if _can_place_held_item(_get_item_coordinate()):
				slot.hover(InventorySlot.HoverMode.DEFAULT)
			else:
				slot.hover(InventorySlot.HoverMode.INVALID)
			hovered_slots.append(slot)
			
func _input(event: InputEvent) -> void:
		if event.is_action_pressed("test1"):
			print(item_to_slots.keys())

func create_slot(index: int) -> void:
	var coordinate = Vector2i(index % size_x, index / size_x)
	var inventory_slot := InventorySlot.create_instance(self, coordinate)
	slot_map[coordinate] = inventory_slot

func hold_item(item: InventoryItem) -> void:
	held_item = item
	held_item.drag_and_drop.drag_canceled.connect(_on_held_item_drag_canceled)
	held_item.drag_and_drop.drag_dropped.connect(_on_held_item_drag_dropped)
	
	if item_to_slots.has(held_item):
		for slot: InventorySlot in item_to_slots[held_item]:
			slot.free_item()
		item_to_slots.erase(held_item)

func unhold_item() -> void:
	held_item.drag_and_drop.drag_canceled.disconnect(_on_held_item_drag_canceled)
	held_item.drag_and_drop.drag_dropped.disconnect(_on_held_item_drag_dropped)
	held_item = null
	_unhover_all_slots()

func _put_item_to_slots(item: InventoryItem, item_coord: Vector2i) -> void:
	item.global_position = slot_map[item_coord].global_position + GRID_CENTER_OFFSET_PX
	var slots := _get_hovered_inventory_slots(held_item, item_coord)
	for slot in slots:
		slot.set_item(item) 

	item_to_slots[held_item] = slots

func _cancel_held_item_drag(starting_position: Vector2) -> void:
	held_item.global_position = starting_position
	held_item.global_rotation = held_item.original_rotation
	var coords = _global_to_grid_coords(starting_position)
	if _is_slot_available(coords):
		_put_item_to_slots(held_item, _global_to_grid_coords(starting_position))

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
	return _local_to_grid_coords(item_pos)
	
func _local_to_grid_coords(local_coords: Vector2) -> Vector2i:
	var result = Vector2i(local_coords / GRID_SIZE_PX)
	if local_coords.x < 0:
		result -= Vector2i(1, 0)
	if local_coords.y < 0:
		result -= Vector2i(0, 1)
	return result

func _global_to_grid_coords(global_pos: Vector2) -> Vector2i:
	return _local_to_grid_coords(global_pos - self.global_position)

func _can_place_held_item(item_coord: Vector2i) -> bool:
	for cell_offset: Vector2i in held_item.get_item_cells(): 
		var final_coord := item_coord + cell_offset
		if not _is_slot_available(final_coord):
			return false
	return true

func _get_hovered_inventory_slots(item: InventoryItem, item_coord: Vector2i) -> Array[InventorySlot]:
	var result: Array[InventorySlot] = []
	for offset: Vector2i in item.get_item_cells(): 
		var final_coord := item_coord + offset
		if _is_slot_available(final_coord):
			result.append(slot_map[final_coord])
	return result

func _on_held_item_drag_canceled(starting_position: Vector2) -> void:
	_cancel_held_item_drag(starting_position)
	unhold_item()
	
func _on_held_item_drag_dropped(starting_position: Vector2) -> void:
	var item_coords = _get_item_coordinate()
	if _can_place_held_item(item_coords):
		_put_item_to_slots(held_item,item_coords)
	else:
		_cancel_held_item_drag(starting_position)
	unhold_item()
