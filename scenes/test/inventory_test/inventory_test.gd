extends Node

@export var items: Array[ItemData] = []

@onready var inventory_item: InventoryItem = $InventoryItem
@onready var inventory_ui: Inventory = %InventoryUI
@onready var spawn_point: Marker2D = $SpawnPoint

func _ready() -> void:
	register_item(inventory_item)
	
func spawn_random_item() -> void:
	var item_data := items.pick_random() as ItemData
	var item := InventoryItem.create_instance(self, item_data, randi())
	item.global_position = spawn_point.global_position
	register_item(item)

func register_item(item: InventoryItem) -> void:
	item.drag_and_drop.drag_started.connect(_on_item_drag_started.bind(item))

func _on_item_drag_started(item: InventoryItem) -> void:
	inventory_ui.hold_item(item)

func _on_button_pressed() -> void:
	spawn_random_item()
