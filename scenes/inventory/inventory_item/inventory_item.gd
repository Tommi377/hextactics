class_name InventoryItem
extends Node2D

@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const MY_SCENE = preload("res://scenes/inventory/inventory_item/inventory_item.tscn")
const GRID_SIZE_PX = 32

@export var item_data: ItemData
var item_ID: int
var selected := false
var grid_anchor = null

static func create_instance(parent: Node, item_data: ItemData, id: int) -> InventoryItem:
	var inventoryItem := MY_SCENE.instantiate()
	parent.add_child(inventoryItem)
	inventoryItem.id = id
	inventoryItem.item_data = item_data
	inventoryItem._update_collision_shape()
	
	return inventoryItem

func _ready() -> void:
	print(item_data)
	if item_data:
		_update_collision_shape()

func _update_collision_shape() -> void:
	for offset: Vector2i in item_data.item_cells:
		if offset == Vector2i(0, 0):
			continue
		var duplicated := collision_shape_2d.duplicate()
		duplicated.position = Vector2(GRID_SIZE_PX, GRID_SIZE_PX) * Vector2(offset)
		add_child(duplicated)
