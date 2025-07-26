extends Node

@onready var inventory_item: InventoryItem = $InventoryItem
@onready var inventory_ui: Inventory = $UI/InventoryUI

func _ready() -> void:
	register_item(inventory_item)

func register_item(item: InventoryItem) -> void:
	item.drag_and_drop.drag_started.connect(_on_item_drag_started.bind(item))

func _on_item_drag_started(item: InventoryItem) -> void:
	inventory_ui.hold_item(item)
