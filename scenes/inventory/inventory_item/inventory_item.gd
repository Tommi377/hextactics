class_name InventoryItem
extends Node2D

@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var canvas_group: CanvasGroup = $CanvasGroup
@onready var sprite_2d: Sprite2D = $CanvasGroup/Sprite2D

@onready var default_z_index = z_index

const MY_SCENE = preload("res://scenes/inventory/inventory_item/inventory_item.tscn")
const GRID_SIZE_PX = 32

@export var item_data: ItemData

var item_ID: int
var original_rotation := 0.0

static func create_instance(parent: Node, item_data: ItemData, id: int) -> InventoryItem:
	var inventoryItem := MY_SCENE.instantiate()
	inventoryItem.item_ID = id
	inventoryItem.item_data = item_data.duplicate()
	
	parent.add_child(inventoryItem)
	return inventoryItem

func _ready() -> void:
	assert(item_data)
	if item_data:
		_update_collision_shape()
		
	drag_and_drop.drag_started.connect(_on_item_drag_started)
	drag_and_drop.drag_canceled.connect(_on_item_drag_ended)
	drag_and_drop.drag_dropped.connect(_on_item_drag_ended)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("rotate") and drag_and_drop.dragging:
		global_rotation += deg_to_rad(90)
		drag_and_drop.offset = Transform2D().rotated(deg_to_rad(90)) * drag_and_drop.offset

func get_item_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for cell in item_data.item_cells:
		var rotated_cell = Transform2D().rotated(global_rotation) * Vector2(cell)
		cells.append(Vector2i(roundf(rotated_cell.x), roundf(rotated_cell.y)))
	return cells

func _update_collision_shape() -> void:
	for offset: Vector2i in item_data.item_cells:
		if offset == Vector2i(0, 0):
			continue
		var new_pos := Vector2(GRID_SIZE_PX, GRID_SIZE_PX) * Vector2(offset)
		var duplicated_sprite := sprite_2d.duplicate()
		var duplicated_collider := collision_shape_2d.duplicate()
		duplicated_sprite.position = new_pos
		duplicated_collider.position = new_pos
		canvas_group.add_child(duplicated_sprite)
		add_child(duplicated_collider)

func _on_item_drag_started() -> void:
	z_index = 99
	original_rotation = global_rotation
	canvas_group.modulate = Color(1, 1, 1, 0.85)

func _on_item_drag_ended(_starting_position: Vector2) -> void:
	z_index = default_z_index
	canvas_group.modulate = Color(1, 1, 1, 1)
