class_name InventoryItem
extends Node2D

@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var canvas_group: CanvasGroup = $CanvasGroup
@onready var sprite_2d: Sprite2D = $CanvasGroup/Sprite2D

const MY_SCENE = preload("res://scenes/inventory/inventory_item/inventory_item.tscn")
const GRID_SIZE_PX = 32

@export var item_data: ItemData
var item_ID: int
var selected := false
var grid_anchor = null

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
	canvas_group.modulate = Color(1, 1, 1, 0.85)

func _on_item_drag_ended(_starting_position: Vector2) -> void:
	canvas_group.modulate = Color(1, 1, 1, 1)
